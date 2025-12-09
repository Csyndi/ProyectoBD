import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class DioClient {
  late Dio _dio;

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.timeout,
      receiveTimeout: ApiConstants.timeout,
    ));

    // Agregar interceptor de logging (opcional)
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
    ));

    // Agregar interceptor para JWT si lo implementas después
 _dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) {
    print('URL: ${options.uri}');
    print('Headers: ${options.headers}');
    print('Body: ${options.data}');
    return handler.next(options);
  },
  onResponse: (response, handler) {
    print('Response Status: ${response.statusCode}');
    print('Response Data: ${response.data}');
    return handler.next(response);
  },
  onError: (error, handler) {
    print('Error: ${error.message}');
    print('Error Response: ${error.response?.data}');
    return handler.next(error);
  },
));
  }

  Dio get dio => _dio;
}