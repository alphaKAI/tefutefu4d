module tefutefu.reactions.TefutefuReactionContainer;
import tefutefu.reactions.TefutefuReaction,
       tefutefu.reactions.TefutefuReactionTypes,
       tefutefu.reactions.TefutefuReactionTarget,
       tefutefu.reactions.TefutefuReactionContainer;
public class TefutefuReactionContainer {
  public TefutefuReactionTypes  type;
  public TefutefuReactionTarget target;
  public string                 generatedText;
  public TefutefuReaction       reaction;

  public this(
      TefutefuReactionTypes  type,
      TefutefuReaction reaction) {
    this.type   = type;
    this.reaction = reaction;
  }

  public this(
      TefutefuReactionTypes  type,
      TefutefuReactionTarget target,
      TefutefuReaction reaction
  ) {
    this.type   = type;
    this.target = target;
  }

  public this(
      TefutefuReactionTypes  type,
      TefutefuReactionTarget target,
      string                 generatedText,
      TefutefuReaction reaction
  ) {
    this.type          = type;
    this.target        = target;
    this.generatedText = generatedText;
  }
}
