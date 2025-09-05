import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetRecentMoviesUseCase {
  final MovieRepository repository;

  GetRecentMoviesUseCase(this.repository);

  Future<List<Movie>> call() async {
    return await repository.getRecentMovies();
  }
}
