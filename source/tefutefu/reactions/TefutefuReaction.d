module tefutefu.reactions.TefutefuReaction;
import tefutefu.commons.Importance,
       tefutefu.message.TefutefuMessage,
       tefutefu.message.TefutefuMessageQueues,
       tefutefu.util.Status;
import tefutefu.reactions.TefutefuReactionTypes,
       tefutefu.reactions.TefutefuReactionContainer,
       tefutefu.reactions.TefutefuTwitterStatuses;

public abstract class TefutefuReaction : TefutefuMessageQueues!Status {
  public string reactionName;
  public TefutefuReactionTypes type;
  public bool fallthrough = true;
  public bool limited     = false;
  public TefutefuReactionTypes[] fallthroughList = [];
  public Importance importance = Importance.MID;
  public bool hasAfterProcess = false;
  public bool needReturnedValue = false;

  public this(TefutefuReactionTypes type) { this.type = type; }

  public void fallthroughEnable() { this.fallthrough = true; }

  public void fallthroughDisable() { this.fallthrough = false; }
 
  public void addFallthroughList(TefutefuReactionTypes type) {
    this.fallthroughList ~= type;
  }
  
  public void setFallthroughList(TefutefuReactionTypes[] types) {
    foreach (TefutefuReactionTypes type; types) {
      this.addFallthroughList(type);
    }
  }
  
  public abstract bool match(Status status);

  public abstract TefutefuReactionContainer process(Status status);

  public abstract void processReturnedJson(TefutefuTwitterStatuses returnedValue);

  public abstract void afterProcess();
}
