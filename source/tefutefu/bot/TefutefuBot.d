module tefutefu.bot.TefutefuBot;

import twitter4d;
import tefutefu.service.TefutefuServiceManager;
import tefutefu.coreServices.TefutefuUserStream,
       tefutefu.coreServices.TefutefuReactionStore;
import tefutefu.bot.Egosa,
       tefutefu.bot.OutPut;

public class TefutefuBot {
  private string        consumerKey,
                        consumerSecret,
                        accessToken,
                        accessTokenSecret;
  private Twitter4D t4d;
  
  public this() {
    this.t4d = new Twitter4D([
        "consumerKey"       : "",
        "consumerSecret"    : "",
        "accessToken"       : "",
        "accessTokenSecret" : ""
        ]);
  }
  
  public void boot() {
    TefutefuServiceManager  tsm            = new TefutefuServiceManager(t4d);
    TefutefuReactionStore   reactionStore  = new TefutefuReactionStore(t4d, tsm);
    // TODO: フォールスローのテストをする。
    reactionStore.addNewReaction(new Egosa(t4d));
    reactionStore.addNewReaction(new OutPut());

    tsm.addNewService(reactionStore);
    tsm.startService("TefutefuReactionStore");

    TefutefuUserStream userStreamService = new TefutefuUserStream(tsm, t4d);
    tsm.addNewService(userStreamService);
    tsm.startService("TefutefuUserStream");
  }
}
