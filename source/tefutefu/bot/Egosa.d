module tefutefu.bot.Egosa;
import tefutefu.reactions.TefutefuReaction,
       tefutefu.reactions.TefutefuReactionContainer,
       tefutefu.reactions.TefutefuReactionTarget,
       tefutefu.reactions.TefutefuReactionTypes,
       tefutefu.reactions.TefutefuTwitterStatuses;
import tefutefu.util.Status;
import twitter4d;
import std.regex,
       std.conv,
       std.json;

public class Egosa : TefutefuReaction {
  private string  myScreenName;
  private string  myName;
  private string  patternString;
  private Twitter4D t4d;

  public this(Twitter4D t4d) {
    super(TefutefuReactionTypes.Fav);
    this.t4d = t4d;
    this.reactionName = "Egosa";

    auto parsed = parseJSON(t4d.request("GET", "/account/verify_credentials.json"));
    this.myScreenName = parsed.object["screen_name"].str;
    this.myName = parsed.object["name"].str;
    this.patternString = this.myScreenName ~ "|" ~ this.myName;
  }

  public override TefutefuReactionContainer process(Status status) {
    return new TefutefuReactionContainer(
          this.type,
          new TefutefuReactionTarget(status.id_str.to!long, status.user["screen_name"]),
          this
        );
  }

  public override bool match(Status status) {
    return status.text.match(regex(this.patternString)) ? true : false;
  }

  public override void processReturnedJson(TefutefuTwitterStatuses returnedValue) {}

  public override void afterProcess() {}

}
