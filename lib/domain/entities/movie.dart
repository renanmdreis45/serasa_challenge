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
}
