import '../../../domain/entities/movie_details.dart';

class MovieDetailsMapper {
  static MovieDetails fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      title: json['title'] as String? ?? '',
      director: json['director'] as String? ?? '',
      year: json['year'] as int? ?? 0,
      genre: json['genre'] as String? ?? '',
      synopsis: json['synopsis'] as String? ?? '',
    );
  }

  static Map<String, dynamic> toJson(MovieDetails movieDetails) {
    return {
      'title': movieDetails.title,
      'director': movieDetails.director,
      'year': movieDetails.year,
      'genre': movieDetails.genre,
      'synopsis': movieDetails.synopsis,
    };
  }
}
