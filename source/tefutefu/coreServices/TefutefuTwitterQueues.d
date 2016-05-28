module tefutefu.coreServices.TefutefuTwitterQueues;

import tefutefu.commons.Importance;
import tefutefu.message.TefutefuMessage;
import tefutefu.message.TefutefuMessageQueues;
import tefutefu.reactions.TefutefuReactionContainer;
import tefutefu.reactions.TefutefuReactionTypes;
import tefutefu.reactions.TefutefuTwitterStatuses;
import tefutefu.service.TefutefuServiceManager;
import tefutefu.util.Status;
import twitter4d;
import std.conv,
       std.json;

public class TefutefuTwitterQueues : TefutefuMessageQueues!TefutefuReactionContainer {
  public  Twitter4D              t4d;
  private TefutefuServiceManager tsm;

  public this(Twitter4D t4d, TefutefuServiceManager tsm) {
    this.t4d = t4d;
    this.tsm = tsm;
  }

  public override void recvReaction(TefutefuMessage!TefutefuReactionContainer message) {
    TefutefuReactionContainer trc     = message.data;
    TefutefuTwitterStatuses ttrv = new TefutefuTwitterStatuses();

    // TODO : switchに書き換える
    if (trc.type == TefutefuReactionTypes.Fav) {
      try {
        ttrv.addNewStatus(
            new Status(
              parseJSON(t4d.request("POST", "favorites/create.json", ["id" : trc.target.targetTweetID.to!string]))
            )
          );
      } catch (Exception e) {
      }
    }

    if (ttrv.hasStatuses && trc.reaction.needReturnedValue) {
      trc.reaction.processReturnedJson(ttrv);
    }

    if (trc.reaction.hasAfterProcess) {
      trc.reaction.afterProcess();
    }
  }

}
