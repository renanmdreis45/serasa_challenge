import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../api/clients/http_get_client.dart';
import '../api/exceptions/exceptions.dart';
import '../api/mappers/mappers.dart';

abstract class MovieRemoteDataSource {
  Future<List<Movie>> searchMovies(String query);
  Future<MovieDetails> getMovieDetails(String id);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final IHttpAdapter httpAdapter;
  final String baseUrl;

  MovieRemoteDataSourceImpl({
    required this.httpAdapter,
    this.baseUrl = '',
  });

  @override
  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await httpAdapter.get<Map<String, dynamic>>(
        '$baseUrl/movies/search',
        queryParams: {'q': query},
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> moviesJson = response.data!['movies'] ?? [];
        return MovieMapper.fromJsonList(moviesJson);
      }

      throw BadResponseException(
        'Falha ao buscar filmes',
        statusCode: response.statusCode,
      );
    } on HttpException {
      rethrow;
    } catch (e) {
      throw UnknownHttpException('Erro inesperado ao buscar filmes: $e');
    }
  }

  @override
  Future<MovieDetails> getMovieDetails(String id) async {
    try {
      final response = await httpAdapter.get<Map<String, dynamic>>(
        '$baseUrl/movies/$id',
      );

      if (response.statusCode == 200 && response.data != null) {
        return MovieDetailsMapper.fromJson(response.data!);
      }

      throw BadResponseException(
        'Falha ao buscar detalhes do filme',
        statusCode: response.statusCode,
      );
    } on HttpException {
      rethrow;
    } catch (e) {
      throw UnknownHttpException('Erro inesperado ao buscar detalhes: $e');
    }
  }
}
