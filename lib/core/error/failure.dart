abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([String? message]) : super(message ?? "Server Error occurred");
}

class NetworkFailure extends Failure {
  NetworkFailure({required String message}) : super("No Internet Connection");
}
