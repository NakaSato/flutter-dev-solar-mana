import 'package:equatable/equatable.dart';

/// Base failure class for error handling
///
/// All failures in the application should extend this class to ensure
/// consistent error handling patterns across features.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Server-related failures
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message, {this.statusCode});

  @override
  List<Object> get props => [message, if (statusCode != null) statusCode!];
}

/// Network connection failures
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Local database related failures
class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure(super.message);
}

/// Cache related failures
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Validation failures
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure(super.message, {this.fieldErrors});

  @override
  List<Object> get props => [message, if (fieldErrors != null) fieldErrors!];
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Authorization failures
class ForbiddenFailure extends Failure {
  const ForbiddenFailure(super.message);
}

/// Not found failures
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// Generic application failures
class AppFailure extends Failure {
  const AppFailure(super.message);
}

/// Unexpected/unknown failures
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}
