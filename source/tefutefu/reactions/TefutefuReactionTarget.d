module tefutefu.reactions.TefutefuReactionTarget;

public class TefutefuReactionTarget {
  public string targetUserScreenName;
  public long   targetTweetID;

  public this(long targetTweetID, string targetUserScreenName) {
    this(targetUserScreenName, targetTweetID);
  }

  public this(string targetUserScreenName, long targetTweetID) {
    this.targetUserScreenName  = targetUserScreenName;
    this.targetTweetID         = targetTweetID;
  }
}
