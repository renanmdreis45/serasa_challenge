import 'package:serasa_challenge/data/datasources/movie_local_datasource.dart';
import 'package:serasa_challenge/domain/entities/movie.dart';

class MockMovieLocalDataSource implements MovieLocalDataSource {
  List<Movie>? _recentMoviesResult;
  Exception? _getRecentMoviesException;
  Exception? _saveRecentMovieException;

  List<Movie> _savedMovies = [];

  void setGetRecentMoviesResult(List<Movie> movies) {
    _recentMoviesResult = movies;
    _getRecentMoviesException = null;
  }

  void setGetRecentMoviesException(Exception exception) {
    _getRecentMoviesException = exception;
    _recentMoviesResult = null;
  }

  void setSaveRecentMovieException(Exception exception) {
    _saveRecentMovieException = exception;
  }

  List<Movie> get savedMovies => _savedMovies;

  void reset() {
    _recentMoviesResult = null;
    _getRecentMoviesException = null;
    _saveRecentMovieException = null;
    _savedMovies.clear();
  }

  @override
  Future<List<Movie>> getRecentMovies() async {
    if (_getRecentMoviesException != null) {
      throw _getRecentMoviesException!;
    }
    return _recentMoviesResult ?? [];
  }

  @override
  Future<void> saveRecentMovie(Movie movie) async {
    if (_saveRecentMovieException != null) {
      throw _saveRecentMovieException!;
    }
    _savedMovies.add(movie);
  }
}
