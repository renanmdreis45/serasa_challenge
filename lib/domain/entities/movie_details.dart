class MovieDetails {
  final String title;
  final String director;
  final int year;
  final String genre;
  final String synopsis;
  final String poster;

  MovieDetails._({
    required this.title,
    required this.director,
    required this.year,
    required this.genre,
    required this.synopsis,
    required this.poster,
  });

  factory MovieDetails({
    required String title,
    required String director,
    required int year,
    required String genre,
    required String synopsis,
    required String poster,
  }) => MovieDetails._(
    title: title,
    director: director,
    year: year,
    genre: genre,
    synopsis: synopsis,
    poster: poster,
  );
}
