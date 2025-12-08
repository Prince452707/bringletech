abstract class Failure {
  final String message;
  final String title;

  const Failure(this.message, [this.title = 'Error']);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.title = 'Server Error']);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.title = 'Connection Error']);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, [super.title = 'Cache Error']);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message, [super.title = 'Unexpected Error']);
}
