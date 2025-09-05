class HttpException implements Exception {
  final String message;
  final int? statusCode;

  HttpException(this.message, {this.statusCode});

  @override
  String toString() => 'HttpException: $message (status: $statusCode)';
}

class ConnectionTimeoutException extends HttpException {
  ConnectionTimeoutException() : super("Tempo de conexão excedido");
}

class ReceiveTimeoutException extends HttpException {
  ReceiveTimeoutException() : super("Tempo de resposta excedido");
}

class ConnectionErrorException extends HttpException {
  ConnectionErrorException() : super("Falha de conexão com o servidor");
}

class BadResponseException extends HttpException {
  BadResponseException(super.message, {super.statusCode});
}

class UnknownHttpException extends HttpException {
  UnknownHttpException(String message) : super("Erro desconhecido: $message");
}
