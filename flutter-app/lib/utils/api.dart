class ApiResponse {
  String msg;
  bool error;
  dynamic data;

  ApiResponse({required this.error, required this.msg, required this.data});
}

class ApiMessages {
  static const wentWrong = 'Something went wrong';
}
