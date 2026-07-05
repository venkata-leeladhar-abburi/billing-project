/// Sealed class representing all possible failure states surfaced to the UI.
/// Every repository method returns `Either<Failure, T>` (or an
/// `AsyncValue.guard`-wrapped error) using one of these subtypes — never a
/// raw exception or DioException.
sealed class Failure {
  const Failure({required this.code, required this.message});

  final String code;
  final String message;
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.code, required super.message});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.code, required super.message});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.code, required super.message});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.code, required super.message});
}

class InsufficientCreditsFailure extends Failure {
  const InsufficientCreditsFailure({
    required super.code,
    required super.message,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.code, required super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.code, required super.message});
}
