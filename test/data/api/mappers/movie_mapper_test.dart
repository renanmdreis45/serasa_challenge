import 'package:flutter_test/flutter_test.dart';
import 'package:serasa_challenge/data/api/mappers/movie_mapper.dart';
import 'package:serasa_challenge/domain/entities/movie.dart';

import '../../../helpers/test_fixtures.dart';

void main() {
  group('MovieMapper', () {
    group('fromJson', () {
      test('should create Movie from valid JSON', () async {
        final json = {
          'imdbID': 'tt0111161',
          'Title': 'The Shawshank Redemption',
          'Director': 'Frank Darabont',
          'Year': '1994',
          'Poster': 'https://example.com/poster1.jpg',
        };

        final result = MovieMapper.fromJson(json);

        expect(result.id, equals('tt0111161'));
        expect(result.title, equals('The Shawshank Redemption'));
        expect(result.director, equals('Frank Darabont'));
        expect(result.year, equals(1994));
        expect(result.poster, equals('https://example.com/poster1.jpg'));
      });

      test('should handle missing optional fields gracefully', () async {
        final json = {
          'imdbID': 'tt0111161',
          'Title': 'The Shawshank Redemption',
          'Year': '1994',
        };

        final result = MovieMapper.fromJson(json);

        expect(result.id, equals('tt0111161'));
        expect(result.title, equals('The Shawshank Redemption'));
        expect(result.director, equals('N/A'));
        expect(result.year, equals(1994));
        expect(result.poster, equals(''));
      });

      test('should handle invalid year format', () async {
        final json = {
          'imdbID': 'tt0111161',
          'Title': 'The Shawshank Redemption',
          'Director': 'Frank Darabont',
          'Year': 'invalid_year',
          'Poster': 'https://example.com/poster1.jpg',
        };

        final result = MovieMapper.fromJson(json);

        expect(result.id, equals('tt0111161'));
        expect(result.title, equals('The Shawshank Redemption'));
        expect(result.director, equals('Frank Darabont'));
        expect(result.year, equals(0));
        expect(result.poster, equals('https://example.com/poster1.jpg'));
      });

      test('should handle N/A poster value', () async {
        final json = {
          'imdbID': 'tt0111161',
          'Title': 'The Shawshank Redemption',
          'Director': 'Frank Darabont',
          'Year': '1994',
          'Poster': 'N/A',
        };

        final result = MovieMapper.fromJson(json);

        expect(
          result.poster,
          equals('N/A'),
        );
      });

      test('should handle null values', () async {
        final json = <String, dynamic>{
          'imdbID': 'tt0111161',
          'Title': 'The Shawshank Redemption',
          'Director': null,
          'Year': '1994',
          'Poster': null,
        };

        final result = MovieMapper.fromJson(json);

        expect(result.id, equals('tt0111161'));
        expect(result.title, equals('The Shawshank Redemption'));
        expect(result.director, equals('N/A'));
        expect(result.year, equals(1994));
        expect(result.poster, equals(''));
      });
    });

    group('toJson', () {
      test('should convert Movie to JSON', () async {
        final movie = TestFixtures.testMovie1;

        final result = MovieMapper.toJson(movie);

        expect(result['id'], equals('tt0111161'));
        expect(result['title'], equals('The Shawshank Redemption'));
        expect(result['director'], equals('Frank Darabont'));
        expect(result['year'], equals(1994));
        expect(result['poster'], equals('https://example.com/poster1.jpg'));
      });

      test('should handle empty strings in Movie', () async {
        final movie = Movie(
          id: 'tt0111161',
          title: 'The Shawshank Redemption',
          director: '',
          year: 1994,
          poster: '',
        );

        final result = MovieMapper.toJson(movie);

        expect(result['id'], equals('tt0111161'));
        expect(result['title'], equals('The Shawshank Redemption'));
        expect(result['director'], equals(''));
        expect(result['year'], equals(1994));
        expect(result['poster'], equals(''));
      });
    });

    group('fromJsonList', () {
      test('should convert list of JSON objects to list of Movies', () async {
        final jsonList = [
          {
            'imdbID': 'tt0111161',
            'Title': 'The Shawshank Redemption',
            'Director': 'Frank Darabont',
            'Year': '1994',
            'Poster': 'https://example.com/poster1.jpg',
          },
          {
            'imdbID': 'tt0068646',
            'Title': 'The Godfather',
            'Director': 'Francis Ford Coppola',
            'Year': '1972',
            'Poster': 'https://example.com/poster2.jpg',
          },
        ];

        final result = MovieMapper.fromJsonList(jsonList);

        expect(result, hasLength(2));
        expect(result[0].id, equals('tt0111161'));
        expect(result[0].title, equals('The Shawshank Redemption'));
        expect(result[1].id, equals('tt0068646'));
        expect(result[1].title, equals('The Godfather'));
      });

      test('should return empty list for empty JSON list', () async {
        final jsonList = <Map<String, dynamic>>[];

        final result = MovieMapper.fromJsonList(jsonList);

        expect(result, isEmpty);
      });

      test('should skip invalid JSON objects', () async {
        final jsonList = [
          {
            'imdbID': 'tt0111161',
            'Title': 'The Shawshank Redemption',
            'Director': 'Frank Darabont',
            'Year': '1994',
            'Poster': 'https://example.com/poster1.jpg',
          },
          <String, dynamic>{},
          {
            'imdbID': 'tt0068646',
            'Title': 'The Godfather',
            'Director': 'Francis Ford Coppola',
            'Year': '1972',
            'Poster': 'https://example.com/poster2.jpg',
          },
        ];

        final result = MovieMapper.fromJsonList(jsonList);

        expect(result, hasLength(3));
        expect(result[0].id, equals('tt0111161'));
        expect(result[1].id, equals(''));
        expect(result[2].id, equals('tt0068646'));
      });
    });

    group('toJsonList', () {
      test('should convert list of Movies to list of JSON objects', () async {
        final movies = [TestFixtures.testMovie1, TestFixtures.testMovie2];

        final result = MovieMapper.toJsonList(movies);

        expect(result, hasLength(2));
        expect(result[0]['id'], equals('tt0111161'));
        expect(result[0]['title'], equals('The Shawshank Redemption'));
        expect(result[1]['id'], equals('tt0068646'));
        expect(result[1]['title'], equals('The Godfather'));
      });

      test('should return empty list for empty Movies list', () async {
        final movies = <Movie>[];

        final result = MovieMapper.toJsonList(movies);

        expect(result, isEmpty);
      });
    });
  });
}
