import 'package:serasa_challenge/data/datasources/movie_remote_datasource.dart';
import 'package:serasa_challenge/domain/entities/movie.dart';
import 'package:serasa_challenge/domain/entities/movie_details.dart';

class MockMovieRemoteDataSource implements MovieRemoteDataSource {
  List<Movie>? _searchMoviesResult;
  MovieDetails? _movieDetailsResult;
  Exception? _searchMoviesException;
  Exception? _movieDetailsException;

  void setSearchMoviesResult(List<Movie> movies) {
    _searchMoviesResult = movies;
    _searchMoviesException = null;
  }

  void setSearchMoviesException(Exception exception) {
    _searchMoviesException = exception;
    _searchMoviesResult = null;
  }

  void setMovieDetailsResult(MovieDetails movieDetails) {
    _movieDetailsResult = movieDetails;
    _movieDetailsException = null;
  }

  void setMovieDetailsException(Exception exception) {
    _movieDetailsException = exception;
    _movieDetailsResult = null;
  }

  void reset() {
    _searchMoviesResult = null;
    _movieDetailsResult = null;
    _searchMoviesException = null;
    _movieDetailsException = null;
  }

  @override
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    if (_searchMoviesException != null) {
      throw _searchMoviesException!;
    }
    return _searchMoviesResult ?? [];
  }

  @override
  Future<MovieDetails> getMovieDetails(String id) async {
    if (_movieDetailsException != null) {
      throw _movieDetailsException!;
    }
    if (_movieDetailsResult == null) {
      throw Exception('Movie not found');
    }
    return _movieDetailsResult!;
  }
}
