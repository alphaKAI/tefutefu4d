module tefutefu.coreServices.TefutefuUserStream;
import tefutefu.message.TefutefuMessage;
import tefutefu.service.ServiceType,
       tefutefu.service.TefutefuService,
       tefutefu.service.TefutefuServiceManager;
import tefutefu.util.Status;
import twitter4d;
import std.stdio,
       std.regex,
       std.conv,
       std.json;
import core.thread;

public class TefutefuUserStream : TefutefuService!Status {
  private TefutefuServiceManager tsm;
  private Twitter4D t4d;

  public this(TefutefuServiceManager tsm, Twitter4D t4d) {
    super(ServiceType.Streamer, "TefutefuUserStream");
    this.tsm = tsm;
    this.t4d = t4d;
  }

  public override void start() {
    this.running = true;

    new Thread(() {
      foreach (status; t4d.stream) {
        if (running == false) break;
        if(match(status.to!string, regex(r"\{.*\}"))){
          auto parsed = parseJSON(status);
          if("text" in parsed.object) {
            this.processStatus(new Status(parsed));
          }
        }
      }
    }).start;
  }
  
  public override void stop() {
    this.running = false;
  }
  
  void processStatus(Status status) {
    writeln("Get a new status");
    this.tsm.streamStatusQueues.pushToRecvQueue(new TefutefuMessage!Status(status));
    this.tsm.processTweetEvent();
  }

}
