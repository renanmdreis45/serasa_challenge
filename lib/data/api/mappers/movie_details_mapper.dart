import '../../../domain/entities/movie_details.dart';

class MovieDetailsMapper {
  static MovieDetails fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      title: json['Title'] as String? ?? json['title'] as String? ?? '',
      director:
          json['Director'] as String? ?? json['director'] as String? ?? '',
      year: _parseYear(json),
      genre: json['Genre'] as String? ?? json['genre'] as String? ?? '',
      synopsis: json['Plot'] as String? ?? json['synopsis'] as String? ?? '',
      poster: json['Poster'] as String? ?? json['poster'] as String? ?? '',
    );
  }

  static int _parseYear(Map<String, dynamic> json) {
    if (json.containsKey('year')) {
      if (json['year'] is int) {
        return json['year'] as int;
      }
      if (json['year'] is String) {
        return int.tryParse(json['year'] as String) ?? 0;
      }
    }

    if (json.containsKey('Year')) {
      return int.tryParse(json['Year'] as String? ?? '0') ?? 0;
    }

    return 0;
  }

  static Map<String, dynamic> toJson(MovieDetails movieDetails) {
    return {
      'title': movieDetails.title,
      'director': movieDetails.director,
      'year': movieDetails.year,
      'genre': movieDetails.genre,
      'synopsis': movieDetails.synopsis,
      'poster': movieDetails.poster,
    };
  }
}
