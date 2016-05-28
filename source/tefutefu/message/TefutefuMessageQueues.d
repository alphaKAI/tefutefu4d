module tefutefu.message.TefutefuMessageQueues;
import tefutefu.commons.Importance;
import tefutefu.message.TefutefuMessage;
import std.stdio;
public class TefutefuMessageQueues(T) {
  public TefutefuMessage!(T)[] recvQueue;

  public void pushToRecvQueue(TefutefuMessage!T newMessage) {
    this.recvQueue ~= newMessage;
  }

  public void checkRecvQueue() {
    if (this.recvQueue.length) {
      TefutefuMessage!T[][Importance] tasks;

      tasks[Importance.LOW]  = [];
      tasks[Importance.MID]  = [];
      tasks[Importance.HIGH] = [];
      
      foreach (TefutefuMessage!T message; this.recvQueue) {
        tasks[message.getImportance] ~= message;
      }

      this.recvQueue = [];
      
      Importance[] importances = [Importance.HIGH, Importance.MID, Importance.LOW];
      
      foreach (Importance importance; importances) {
        foreach (TefutefuMessage!T message; tasks[importance]) {
          this.recvReaction(message);
        }
      }
    }
  }

  public void recvReaction(TefutefuMessage!T message) {}  
}
