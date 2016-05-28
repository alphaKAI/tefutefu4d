module tefutefu.service.TefutefuServiceManager;
import tefutefu.service.TefutefuService;
import tefutefu.util.Status;
import tefutefu.message.TefutefuMessage,
       tefutefu.message.TefutefuMessageQueues;
import tefutefu.coreServices.TefutefuTwitterQueues;
import twitter4d;
import std.stdio;

public class TefutefuServiceManager {
  private TefutefuService!(Status)[string]    services;
  public  Twitter4D                           t4d;
  public  TefutefuMessageQueues!Status        streamStatusQueues;
 public TefutefuTwitterQueues twq;

  public this(Twitter4D t4d) {
    this.t4d = t4d;
    this.twq = new TefutefuTwitterQueues(t4d, this);
    this.streamStatusQueues  = new class() TefutefuMessageQueues!Status {
    public override void recvReaction(TefutefuMessage!Status message) {
      //TODO : 他のサービス(と言うかリアクション処理)にたらい回す
      //Status status = message.data;
      writeln("recvReaction");

      services["TefutefuReactionStore"].pushToRecvQueue(message);
      services["TefutefuReactionStore"].checkRecvQueue();
    }
  };
  
  }

  public bool addNewService(TefutefuService!Status newService) {
    if (this.existService(newService.serviceName)) {
      return false;
    } else {
      services[newService.serviceName] = newService;
      return true;
    }
  }
  
  public bool startService(string serviceName) {
    if (!this.existService(serviceName)) {
      writeln("[Error] - There is no service as" ~ serviceName);
      return false;
    } else {
      if (this.services[serviceName].running) {
        return false;
      } else {
        writeln("Start service : " ~ serviceName);
        this.services[serviceName].start();
        return true;
      }
    }
  }

  public bool stopService(string serviceName) {
    if (!this.existService(serviceName)) {
      writeln("[Error] - There is no service as" ~ serviceName);
      return false;
    } else {
      if (this.services[serviceName].running) {
        writeln("Stop service : " ~ serviceName);
        this.services[serviceName].stop();
        return true;
      } else {
        return false;
      }
    }
  }

  //ユーザーストリームでイベントを読み込んだらこのメソッドが呼ばれる
  //checkRecvQueueで呼ばれるrecvReactionに他のサービスによる反応を記述。
  public void processTweetEvent() {
    this.streamStatusQueues.checkRecvQueue();//Experimental
  }

  public void sendMesseageToService(
      string targetService,
      TefutefuMessage!Status message
  ) {
    if (this.existService(targetService)) {
      this.services[targetService].pushToRecvQueue(message);
    }
  }

  public void checkServices() {
    if (this.services != null) {
      foreach (key, value; this.services) {
        if (value.running == false) {
          value.start();
          writeln("The service of " ~ key ~ " was started");
        }
      }  
    }
  }
  
  public bool existService(string name) { return name in this.services ? true :false; }
}
