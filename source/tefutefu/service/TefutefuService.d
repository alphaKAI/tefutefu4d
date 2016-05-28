module tefutefu.service.TefutefuService;
import tefutefu.service.ServiceType;
import tefutefu.message.TefutefuMessageQueues;
import tefutefu.util.Status;

abstract public class TefutefuService(T) : TefutefuMessageQueues!T {
  public ServiceType type;
  public string      serviceName;
  public bool        running;

  public this(ServiceType type, string name) {
    this.type        = type;
    this.serviceName = name;
  }

  public abstract void start();
  public abstract void stop();
}
