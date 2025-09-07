import 'package:serasa_challenge/domain/entities/movie.dart';
import 'package:serasa_challenge/domain/entities/movie_details.dart';

class TestFixtures {
  static Movie get testMovie1 => Movie(
    id: 'tt0111161',
    title: 'The Shawshank Redemption',
    director: 'Frank Darabont',
    year: 1994,
    poster: 'https://example.com/poster1.jpg',
  );

  static Movie get testMovie2 => Movie(
    id: 'tt0068646',
    title: 'The Godfather',
    director: 'Francis Ford Coppola',
    year: 1972,
    poster: 'https://example.com/poster2.jpg',
  );

  static Movie get testMovie3 => Movie(
    id: 'tt0071562',
    title: 'The Godfather Part II',
    director: 'Francis Ford Coppola',
    year: 1974,
    poster: 'https://example.com/poster3.jpg',
  );

  static List<Movie> get testMoviesList => [testMovie1, testMovie2, testMovie3];

  static MovieDetails get testMovieDetails => MovieDetails(
    title: 'The Shawshank Redemption',
    director: 'Frank Darabont',
    year: 1994,
    genre: 'Drama',
    synopsis:
        'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.',
    poster: 'https://example.com/poster1.jpg',
  );

  static Movie get emptyMovie =>
      Movie(id: '', title: '', director: '', year: 0, poster: '');

  static MovieDetails get emptyMovieDetails => MovieDetails(
    title: '',
    director: '',
    year: 0,
    genre: '',
    synopsis: '',
    poster: '',
  );
}
