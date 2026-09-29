/// Base failure class for domain/data errors
abstract class Failure {
  final String message;
  final Object? cause;
  const Failure(this.message, [this.cause]);

  @override
  String toString() =>
      '$runtimeType: $message${cause != null ? ' (Cause: $cause)' : ''}';
}

class StorageFailure extends Failure {
  const StorageFailure(super.message, [super.cause]);
}

class CurriculumFailure extends Failure {
  const CurriculumFailure(super.message, [super.cause]);
}

class HardwareFailure extends Failure {
  const HardwareFailure(super.message, [super.cause]);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [super.cause]);
}
