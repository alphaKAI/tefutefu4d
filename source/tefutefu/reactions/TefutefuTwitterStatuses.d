module tefutefu.reactions.TefutefuTwitterStatuses;

import tefutefu.util.Status;

public class TefutefuTwitterStatuses {
  public Status[] statuses;
  public bool hasStatuses;

  public this() {
    this.statuses    = [];
    this.hasStatuses = false;
  }

  public void addNewStatus(Status status) {
    if (this.hasStatuses == false) {
      this.hasStatuses = true;
    }

    this.statuses ~= status;
  }
}

