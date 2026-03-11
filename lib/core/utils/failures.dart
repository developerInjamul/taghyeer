abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  NetworkFailure() : super('No internet connection. Please check your network.');
}

class TimeoutFailure extends Failure {
  TimeoutFailure() : super('Request timed out. Please try again.');
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class AuthFailure extends Failure {
  AuthFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure() : super('Failed to load cached data.');
}

class UnknownFailure extends Failure {
  UnknownFailure() : super('Something went wrong. Please try again.');
}

class EmptyFailure extends Failure {
  EmptyFailure() : super('No data found.');
}
