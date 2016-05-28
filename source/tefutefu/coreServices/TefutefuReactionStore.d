module tefutefu.coreServices.TefutefuReactionStore;

import tefutefu.message.TefutefuMessage;
import tefutefu.service.ServiceType,
       tefutefu.service.TefutefuService,
       tefutefu.service.TefutefuServiceManager;
import tefutefu.reactions.TefutefuReaction,
       tefutefu.reactions.TefutefuReactionTypes,
       tefutefu.reactions.TefutefuReactionContainer;
import tefutefu.util.Status;
import twitter4d;
import std.stdio,
       std.algorithm;

public class TefutefuReactionStore : TefutefuService!Status {
  public  TefutefuReaction[string]     reactions;
  public  Twitter4D                    t4d;
  private TefutefuServiceManager       tsm;

  public this(Twitter4D t4d, TefutefuServiceManager tsm) {
    super(ServiceType.Daemon, "TefutefuReactionStore");
    this.t4d         = t4d;
    this.tsm         = tsm;
  }

  public bool addNewReaction(TefutefuReaction newReaction) {
    if (this.existReaction(newReaction.reactionName)) {
      return false;
    } else {
      this.reactions[newReaction.reactionName] = newReaction;
      return true;
    }
  }

  public bool existReaction(string name) {
    return name in this.reactions ? true : false;
  }

  public override void recvReaction(TefutefuMessage!Status message) {
    Status                           thisStatus          = message.data;
    TefutefuReaction[]               reactionList;
    TefutefuReactionTypes[]          fallthroughList;
    bool                             fallthrough         = true;
    bool                             fallthroughModified = false;

    if (this.reactions != null) {
      foreach (key, value; this.reactions) {
        writeln("REACTION => " ~ key);
        TefutefuReaction thisReaction = value;

        if (thisReaction.match(thisStatus)) {
          bool granted = false;
          if (fallthroughModified) {
            foreach (TefutefuReactionTypes type; fallthroughList) {
              if (thisReaction.type == type) {
                granted = true;
                break;
              }
            }
          } else {
            granted = true;
          }

          if (granted) {
            writeln("granted: " ~ thisReaction.reactionName);
            reactionList ~= thisReaction;
          }

          if (thisReaction.fallthrough && thisReaction.limited && granted) {
            if (fallthrough == false) {
              fallthrough = true;
            }

            foreach (TefutefuReactionTypes type; thisReaction.fallthroughList) {
              if (!fallthroughList.canFind(type)) {
                fallthroughList ~= type;
              }
            }

            fallthroughModified = true;
          }
        }
      }


      foreach (TefutefuReaction reaction; reactionList) {
        writeln("=> " ~ reaction.reactionName);

        TefutefuReactionContainer trc = reaction.process(thisStatus);

        if (reaction.type != TefutefuReactionTypes.Display) {
          //Queuesに投げる
          writeln("Push new reaction " ~ reaction.reactionName);
          this.tsm.twq.pushToRecvQueue(new TefutefuMessage!TefutefuReactionContainer(trc));
        }
      }

      reactionList = [];

      this.tsm.twq.checkRecvQueue();
    }
  }

  public override void start() {}
  public override void stop() {}
}
