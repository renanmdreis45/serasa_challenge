import 'package:serasa_challenge/domain/entities/movie_details.dart';

import '../entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> searchMovies(String query, {int page = 1});
  Future<MovieDetails> getMovieDetails(String id);
  Future<List<Movie>> getRecentMovies();
  Future<void> saveRecentMovie(Movie movie);
}
