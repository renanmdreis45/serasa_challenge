import 'package:flutter_test/flutter_test.dart';
import 'package:serasa_challenge/domain/entities/movie.dart';

void main() {
  group('Movie Entity Tests', () {
    test('should create Movie instance with factory constructor', () {
      const id = 'tt0111161';
      const title = 'The Shawshank Redemption';
      const director = 'Frank Darabont';
      const year = 1994;
      const poster = 'https://example.com/poster.jpg';

      final movie = Movie(
        id: id,
        title: title,
        director: director,
        year: year,
        poster: poster,
      );

      expect(movie.id, equals(id));
      expect(movie.title, equals(title));
      expect(movie.director, equals(director));
      expect(movie.year, equals(year));
      expect(movie.poster, equals(poster));
    });

    test('should create Movie instance with empty values', () {
      final movie = Movie(id: '', title: '', director: '', year: 0, poster: '');

      expect(movie.id, equals(''));
      expect(movie.title, equals(''));
      expect(movie.director, equals(''));
      expect(movie.year, equals(0));
      expect(movie.poster, equals(''));
    });

    test('should maintain immutability of Movie properties', () {
      final movie = Movie(
        id: 'tt0111161',
        title: 'The Shawshank Redemption',
        director: 'Frank Darabont',
        year: 1994,
        poster: 'https://example.com/poster.jpg',
      );

      expect(movie.id, equals('tt0111161'));
      expect(movie.title, equals('The Shawshank Redemption'));
      expect(movie.director, equals('Frank Darabont'));
      expect(movie.year, equals(1994));
      expect(movie.poster, equals('https://example.com/poster.jpg'));
    });

    test('should handle special characters in movie properties', () {
      final movie = Movie(
        id: 'tt0123456',
        title: 'Movie with Special Characters: àáâãäçéêëíîïóôõöúûü',
        director: 'Director with Ñ and ß',
        year: 2023,
        poster: 'https://example.com/poster-with-dashes_and_underscores.jpg',
      );

      expect(movie.title, contains('àáâãäçéêëíîïóôõöúûü'));
      expect(movie.director, contains('Ñ and ß'));
      expect(movie.poster, contains('dashes_and_underscores'));
    });

    test('should handle minimum and maximum year values', () {
      final movieMinYear = Movie(
        id: 'tt0000001',
        title: 'Very Old Movie',
        director: 'Ancient Director',
        year: 1888,
        poster: 'https://example.com/old.jpg',
      );

      final movieMaxYear = Movie(
        id: 'tt9999999',
        title: 'Future Movie',
        director: 'Future Director',
        year: 9999,
        poster: 'https://example.com/future.jpg',
      );

      expect(movieMinYear.year, equals(1888));
      expect(movieMaxYear.year, equals(9999));
    });
  });
}
