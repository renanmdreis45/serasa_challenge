import '../response/http_response.dart';

abstract class IHttpAdapter {
  Future<HttpResponse<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParams,
  });
}
