enum ApiStatus { initial, loading, success, failure }

class ApiState<T> {
  final ApiStatus status;
  final T? data;
  final String? errorMessage;

  ApiState({required this.status, this.data, this.errorMessage});

  factory ApiState.initial() => ApiState(status: ApiStatus.initial);
  factory ApiState.loading() => ApiState(status: ApiStatus.loading);
  factory ApiState.success(T data) =>
      ApiState(status: ApiStatus.success, data: data);
  factory ApiState.failure(String message) =>
      ApiState(status: ApiStatus.failure, errorMessage: message);

  bool get isLoading => status == ApiStatus.loading;
  bool get isSuccess => status == ApiStatus.success;
  bool get isFailure => status == ApiStatus.failure;
}
