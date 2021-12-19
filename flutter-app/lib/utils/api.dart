/// Api response for backend is stored in [ApiResponse] class where
/// the [msg] is msg send, [data] is dynamic and which it will store data
/// for display in UI, [error] is the status of error
class ApiResponse {
  String msg;
  bool error;
  dynamic data;

  ApiResponse({required this.error, required this.msg, required this.data});
}

/// Presets for response text to display in things like [snackbar] and others...
class ApiMessages {
  static const wentWrong = 'Something went wrong';
}
