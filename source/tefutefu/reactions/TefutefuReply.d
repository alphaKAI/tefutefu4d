module tefutefu.reactions.TefutefuReply;
import tefutefu.reactions.TefutefuReaction,
       tefutefu.reactions.TefutefuReactionTypes;

public abstract class TefutefuReply : TefutefuReaction {
  public this() {
    super(TefutefuReactionTypes.Reply);
  }
}
