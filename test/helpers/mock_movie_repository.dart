import 'package:serasa_challenge/domain/entities/movie.dart';
import 'package:serasa_challenge/domain/entities/movie_details.dart';
import 'package:serasa_challenge/domain/repositories/movie_repository.dart';

class MockMovieRepository implements MovieRepository {
  List<Movie>? _searchResult;
  MovieDetails? _movieDetailsResult;
  List<Movie>? _recentMoviesResult;
  Exception? _searchException;
  Exception? _movieDetailsException;
  Exception? _recentMoviesException;
  Exception? _saveException;

  List<Movie> _savedMovies = [];

  void setSearchMoviesResult(List<Movie> movies) {
    _searchResult = movies;
    _searchException = null;
  }

  void setSearchMoviesException(Exception exception) {
    _searchException = exception;
    _searchResult = null;
  }

  void setMovieDetailsResult(MovieDetails movieDetails) {
    _movieDetailsResult = movieDetails;
    _movieDetailsException = null;
  }

  void setMovieDetailsException(Exception exception) {
    _movieDetailsException = exception;
    _movieDetailsResult = null;
  }

  void setRecentMoviesResult(List<Movie> movies) {
    _recentMoviesResult = movies;
    _recentMoviesException = null;
  }

  void setRecentMoviesException(Exception exception) {
    _recentMoviesException = exception;
    _recentMoviesResult = null;
  }

  void setSaveRecentMovieException(Exception exception) {
    _saveException = exception;
  }

  List<Movie> get savedMovies => _savedMovies;

  void reset() {
    _searchResult = null;
    _movieDetailsResult = null;
    _recentMoviesResult = null;
    _searchException = null;
    _movieDetailsException = null;
    _recentMoviesException = null;
    _saveException = null;
    _savedMovies.clear();
  }

  @override
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    if (_searchException != null) {
      throw _searchException!;
    }
    return _searchResult ?? [];
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

  @override
  Future<List<Movie>> getRecentMovies() async {
    if (_recentMoviesException != null) {
      throw _recentMoviesException!;
    }
    return _recentMoviesResult ?? [];
  }

  @override
  Future<void> saveRecentMovie(Movie movie) async {
    if (_saveException != null) {
      throw _saveException!;
    }
    _savedMovies.add(movie);
  }
}
