import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../api/clients/http_get_client.dart';
import '../api/exceptions/exceptions.dart';
import '../api/mappers/movie_details_mapper.dart';
import '../api/mappers/movie_mapper.dart';

abstract class MovieRemoteDataSource {
  Future<List<Movie>> searchMovies(String query);
  Future<MovieDetails> getMovieDetails(String id);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final IHttpAdapter httpAdapter;
  final String baseUrl;
  final String apiKey;

  MovieRemoteDataSourceImpl({
    required this.httpAdapter,
    this.baseUrl = 'http://www.omdbapi.com',
    this.apiKey = '9679c274',
  });

  @override
  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await httpAdapter.get<Map<String, dynamic>>(
        baseUrl,
        queryParams: {'s': query, 'apikey': apiKey, 'type': 'movie'},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!;

        if (data['Response'] == 'True' && data['Search'] != null) {
          final List<dynamic> searchResults = data['Search'];
          return MovieMapper.fromJsonList(searchResults);
        } else {
          return [];
        }
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
        baseUrl,
        queryParams: {'i': id, 'apikey': apiKey, 'plot': 'full'},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!;

        if (data['Response'] == 'True') {
          return MovieDetailsMapper.fromJson({
            'id': id,
            'title': data['Title'] ?? '',
            'director': data['Director'] ?? '',
            'year': int.tryParse(data['Year'] ?? '0') ?? 0,
            'genre': data['Genre'] ?? '',
            'synopsis': data['Plot'] ?? '',
            'poster': data['Poster'] ?? '',
          });
        } else {
          throw BadResponseException(
            data['Error'] ?? 'Filme não encontrado',
            statusCode: 404,
          );
        }
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
