module tefutefu.bot.OutPut;

import tefutefu.reactions.TefutefuReaction,
       tefutefu.reactions.TefutefuReactionContainer,
       tefutefu.reactions.TefutefuReactionTypes,
       tefutefu.reactions.TefutefuTwitterStatuses;
import tefutefu.util.Status;
import std.stdio;

public class OutPut : TefutefuReaction {
  public this() {
    super(TefutefuReactionTypes.Display);
    this.reactionName = "OutPut";
  }

  public override TefutefuReactionContainer process(Status status) {
    TefutefuReactionContainer trc = new TefutefuReactionContainer(
        this.type,
        this
      );

    writeln("------------------------------------");
    writefln("%s(@%s) : %s",
        status.user["screen_name"],
        status.user["id_str"],
        status.text);
    writeln("------------------------------------");

    return trc;
  }

  public override bool match(Status status) {
    return true;
  }

  public override void processReturnedJson(TefutefuTwitterStatuses returnedValue) {}

  public override void afterProcess() {}
}
