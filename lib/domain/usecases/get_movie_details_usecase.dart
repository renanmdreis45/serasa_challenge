import '../entities/movie_details.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetailsUseCase {
  final MovieRepository repository;

  GetMovieDetailsUseCase(this.repository);

  Future<MovieDetails> call(String movieId) async {
    return await repository.getMovieDetails(movieId.trim());
  }
}
