class Movie {
  final String id;
  final String title;
  final String director;
  final int year;
  final String poster;

  Movie._({
    required this.id,
    required this.title,
    required this.director,
    required this.year,
    required this.poster,
  });

  factory Movie({
    required String id,
    required String title,
    required String director,
    required int year,
    required String poster,
  }) => Movie._(
    id: id,
    title: title,
    director: director,
    year: year,
    poster: poster,
  );
}
