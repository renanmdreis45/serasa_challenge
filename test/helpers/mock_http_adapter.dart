import 'package:serasa_challenge/data/api/clients/http_get_client.dart';
import 'package:serasa_challenge/data/api/response/http_response.dart';

class MockHttpAdapter implements IHttpAdapter {
  HttpResponse<dynamic>? _response;
  Exception? _exception;

  void setResponse<T>(HttpResponse<T> response) {
    _response = response as HttpResponse<dynamic>;
    _exception = null;
  }

  void setException(Exception exception) {
    _exception = exception;
    _response = null;
  }

  void reset() {
    _response = null;
    _exception = null;
  }

  @override
  Future<HttpResponse<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    if (_exception != null) {
      throw _exception!;
    }

    if (_response != null) {
      return _response! as HttpResponse<T>;
    }

    throw Exception('No response or exception configured');
  }
}
