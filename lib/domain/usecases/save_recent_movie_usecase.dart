import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class SaveRecentMovieUseCase {
  final MovieRepository repository;

  SaveRecentMovieUseCase(this.repository);

  Future<void> call(Movie movie) async {
    await repository.saveRecentMovie(movie);
  }
}
