import 'package:flutter_test/flutter_test.dart';
import 'package:serasa_challenge/domain/entities/movie_details.dart';

void main() {
  group('MovieDetails Entity Tests', () {
    test('should create MovieDetails instance with factory constructor', () {
      const title = 'The Shawshank Redemption';
      const director = 'Frank Darabont';
      const year = 1994;
      const genre = 'Drama';
      const synopsis =
          'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.';
      const poster = 'https://example.com/poster.jpg';

      final movieDetails = MovieDetails(
        title: title,
        director: director,
        year: year,
        genre: genre,
        synopsis: synopsis,
        poster: poster,
      );

      expect(movieDetails.title, equals(title));
      expect(movieDetails.director, equals(director));
      expect(movieDetails.year, equals(year));
      expect(movieDetails.genre, equals(genre));
      expect(movieDetails.synopsis, equals(synopsis));
      expect(movieDetails.poster, equals(poster));
    });

    test('should create MovieDetails instance with empty values', () {
      final movieDetails = MovieDetails(
        title: '',
        director: '',
        year: 0,
        genre: '',
        synopsis: '',
        poster: '',
      );

      expect(movieDetails.title, equals(''));
      expect(movieDetails.director, equals(''));
      expect(movieDetails.year, equals(0));
      expect(movieDetails.genre, equals(''));
      expect(movieDetails.synopsis, equals(''));
      expect(movieDetails.poster, equals(''));
    });

    test('should maintain immutability of MovieDetails properties', () {
      final movieDetails = MovieDetails(
        title: 'The Shawshank Redemption',
        director: 'Frank Darabont',
        year: 1994,
        genre: 'Drama',
        synopsis: 'Two imprisoned men bond over a number of years...',
        poster: 'https://example.com/poster.jpg',
      );

      expect(movieDetails.title, equals('The Shawshank Redemption'));
      expect(movieDetails.director, equals('Frank Darabont'));
      expect(movieDetails.year, equals(1994));
      expect(movieDetails.genre, equals('Drama'));
      expect(
        movieDetails.synopsis,
        equals('Two imprisoned men bond over a number of years...'),
      );
      expect(movieDetails.poster, equals('https://example.com/poster.jpg'));
    });

    test('should handle long synopsis text', () {
      const longSynopsis = '''
        This is a very long synopsis that might contain multiple paragraphs and special characters.
        It should test the ability of the MovieDetails entity to handle large amounts of text
        without any issues. The synopsis might include quotes "like this", apostrophes, 
        and even some emoji 🎬📽️🎭. It could also contain HTML entities and other special 
        formatting that needs to be preserved correctly.
        
        Sometimes synopses contain plot details, character names, and extensive descriptions
        of the movie's themes and storyline. This test ensures our entity can handle all
        of this information properly.
      ''';

      final movieDetails = MovieDetails(
        title: 'Test Movie',
        director: 'Test Director',
        year: 2023,
        genre: 'Test Genre',
        synopsis: longSynopsis,
        poster: 'https://example.com/poster.jpg',
      );

      expect(movieDetails.synopsis, equals(longSynopsis));
      expect(movieDetails.synopsis.length, greaterThan(500));
    });

    test('should handle multiple genres in genre field', () {
      final movieDetails = MovieDetails(
        title: 'Multi-Genre Movie',
        director: 'Versatile Director',
        year: 2023,
        genre: 'Action, Drama, Thriller, Science Fiction',
        synopsis: 'A movie that spans multiple genres.',
        poster: 'https://example.com/poster.jpg',
      );

      expect(movieDetails.genre, contains('Action'));
      expect(movieDetails.genre, contains('Drama'));
      expect(movieDetails.genre, contains('Thriller'));
      expect(movieDetails.genre, contains('Science Fiction'));
    });

    test('should handle special characters in all fields', () {
      final movieDetails = MovieDetails(
        title: 'Título com Acentos & Símbolos: àáâãäçéêë',
        director: 'Diretør with Spëcial Charactërs',
        year: 2023,
        genre: 'Gênero Especial',
        synopsis:
            'Sinopse com caracteres especiais: "aspas", \'apostrofes\', & símbolos únicos!',
        poster: 'https://example.com/pôster-especial.jpg',
      );

      expect(movieDetails.title, contains('àáâãäçéêë'));
      expect(movieDetails.director, contains('Spëcial Charactërs'));
      expect(movieDetails.genre, contains('Gênero'));
      expect(movieDetails.synopsis, contains('"aspas"'));
      expect(movieDetails.poster, contains('pôster-especial'));
    });

    test('should handle negative year values', () {
      final movieDetails = MovieDetails(
        title: 'Ancient Movie',
        director: 'Historical Director',
        year: -500, // Before Christ era
        genre: 'Historical',
        synopsis: 'A movie set in ancient times.',
        poster: 'https://example.com/ancient.jpg',
      );

      expect(movieDetails.year, equals(-500));
    });
  });
}
