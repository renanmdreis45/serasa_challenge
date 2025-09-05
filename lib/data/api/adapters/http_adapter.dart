import 'package:dio/dio.dart';
import 'package:serasa_challenge/data/api/clients/http_get_client.dart';

import '../exceptions/exceptions.dart';
import '../response/http_response.dart';

class DioHttpAdapter implements IHttpAdapter {
  final Dio dio;

  DioHttpAdapter({Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {'Content-Type': 'application/json'},
            ),
          );

  @override
  Future<HttpResponse<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.get(url, queryParameters: queryParams);
      return _toHttpResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  HttpResponse<T> _toHttpResponse<T>(Response response) {
    return HttpResponse<T>(
      data: response.data,
      statusCode: response.statusCode ?? 500,
    );
  }

  HttpException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ConnectionTimeoutException();
      case DioExceptionType.receiveTimeout:
        return ReceiveTimeoutException();
      case DioExceptionType.badResponse:
        return BadResponseException(
          e.response?.statusMessage ?? "Erro inesperado",
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.connectionError:
        return ConnectionErrorException();
      default:
        return UnknownHttpException(e.message ?? "Erro não identificado");
    }
  }
}
