class Movie {
  final String title;
  final String director;
  final int year;

  Movie._({required this.title, required this.director, required this.year});

  factory Movie({
    required String title,
    required String director,
    required int year,
  }) => Movie._(title: title, director: director, year: year);

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] as String,
      director: json['director'] as String,
      year: json['year'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'director': director, 'year': year};
  }
}