/// Represents the status of an entity.
enum Status {
  newEntity,
  inProgress,
  done,
  closed,
  canceled,
  pending,
  accepted,
  denied;

  /// Converts an integer from the backend to a Status enum.
  static Status fromInt(int value) {
    return Status.values[value];
  }

  /// Converts a Status enum to an integer for the backend.
  int toInt() {
    return Status.values.indexOf(this);
  }
}