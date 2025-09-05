class MovieDetails {
  final String title;
  final String director;
  final int year;
  final String genre;
  final String synopsis;

  MovieDetails._({
    required this.title,
    required this.director,
    required this.year,
    required this.genre,
    required this.synopsis,
  });

  factory MovieDetails({
    required String title,
    required String director,
    required int year,
    required String genre,
    required String synopsis,
  }) => MovieDetails._(
    title: title,
    director: director,
    year: year,
    genre: genre,
    synopsis: synopsis,
  );
}
