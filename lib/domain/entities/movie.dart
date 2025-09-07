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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Movie &&
        other.id == id &&
        other.title == title &&
        other.director == director &&
        other.year == year &&
        other.poster == poster;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        director.hashCode ^
        year.hashCode ^
        poster.hashCode;
  }

  @override
  String toString() {
    return 'Movie(id: $id, title: $title, director: $director, year: $year, poster: $poster)';
  }
}
