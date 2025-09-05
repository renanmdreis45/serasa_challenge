import '../../domain/entities/movie.dart';

abstract class MovieLocalDataSource {
  Future<List<Movie>> getRecentMovies();
  Future<void> saveRecentMovie(Movie movie);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  static const int _maxRecentMovies = 10;
  static final List<Movie> _recentMovies = [];

  @override
  Future<List<Movie>> getRecentMovies() async {
    return List.from(_recentMovies);
  }

  @override
  Future<void> saveRecentMovie(Movie movie) async {
    try {
      _recentMovies.removeWhere(
        (m) =>
            m.title == movie.title &&
            m.director == movie.director &&
            m.year == movie.year,
      );

      _recentMovies.insert(0, movie);

      if (_recentMovies.length > _maxRecentMovies) {
        _recentMovies.removeRange(_maxRecentMovies, _recentMovies.length);
      }
    } catch (e) {
      throw Exception('Erro ao salvar filme recente: $e');
    }
  }
}
