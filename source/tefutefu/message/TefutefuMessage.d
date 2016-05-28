module tefutefu.message.TefutefuMessage;
import tefutefu.commons.Importance;

class TefutefuMessage(T) {
  private string     id;
  private Importance importance = Importance.MID;
  public  T          data;

  this() {}

  this(T data) {
    this.data = data;
  }

  public @property string getId() {
    return this.id;
  }

  public @property Importance getImportance() {
    return this.importance;
  }
}
