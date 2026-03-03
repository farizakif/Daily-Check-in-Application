class CheckInAlreadyDoneException implements Exception {
  final String message;

  CheckInAlreadyDoneException(
      [this.message = 'You have already checked in today.']);

  @override
  String toString() => 'CheckInAlreadyDoneException: $message';
}
