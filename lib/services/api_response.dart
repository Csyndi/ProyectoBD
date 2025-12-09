class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.statusCode,
  });

  factory ApiResponse.success({T? data, String? message}) => ApiResponse<T>(
        success: true,
        data: data,
        message: message,
      );

  factory ApiResponse.error({
    required String message,
    int? statusCode,
  }) => ApiResponse<T>(
        success: false,
        message: message,
        statusCode: statusCode,
      );
}