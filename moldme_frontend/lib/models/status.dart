enum Status {
  NEW,
  INPROGRESS,
  DONE,
  CLOSED,
  CANCELED,
  PENDING,
  ACCEPTED,
  DENIED,
}


int statusToInt(Status status) {
  return Status.values.indexOf(status);
}

Status intToStatus(int status) {
  return Status.values[status];
}
