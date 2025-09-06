import '../../../domain/entities/movie.dart';

class MovieMapper {
  static Movie fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['imdbID'] as String? ?? json['id'] as String? ?? '',
      title: json['Title'] as String? ?? json['title'] as String? ?? '',
      director:
          json['Director'] as String? ?? json['director'] as String? ?? 'N/A',
      year: _parseYear(json),
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

  static Map<String, dynamic> toJson(Movie movie) {
    return {
      'id': movie.id,
      'title': movie.title,
      'director': movie.director,
      'year': movie.year,
      'poster': movie.poster,
    };
  }

  static List<Movie> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<Movie> movies) {
    return movies.map((movie) => toJson(movie)).toList();
  }
}
