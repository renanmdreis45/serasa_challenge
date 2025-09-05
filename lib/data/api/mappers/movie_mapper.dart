import '../../../domain/entities/movie.dart';

class MovieMapper {
  static Movie fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] as String? ?? '',
      director: json['director'] as String? ?? '',
      year: json['year'] as int? ?? 0,
    );
  }

  static Map<String, dynamic> toJson(Movie movie) {
    return {
      'title': movie.title,
      'director': movie.director,
      'year': movie.year,
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
