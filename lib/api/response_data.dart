import '../data/error/app_error.dart';

class ResponseData<T> {
  final T? serverResponse;
  final AppError? error;

  ResponseData._({
    this.serverResponse,
    this.error,
  });

  factory ResponseData.success(T data) {
    return ResponseData._(
      serverResponse: data,
    );
  }

  factory ResponseData.error(Object error) {
    final AppError appError = AppError.unknownFailure(error.toString());
    return ResponseData._(
      error: appError,
    );
  }

  void result({
    required Function(T) onSuccess,
    required Function(AppError) onError,
  }) {
    if (serverResponse != null) {
      onSuccess(serverResponse as T);
    } else if (error != null) {
      onError(error!);
    }
  }
}
