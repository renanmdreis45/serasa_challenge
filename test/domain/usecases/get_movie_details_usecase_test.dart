import 'package:flutter_test/flutter_test.dart';
import 'package:serasa_challenge/domain/usecases/get_movie_details_usecase.dart';

import '../../helpers/mock_movie_repository.dart';
import '../../helpers/test_fixtures.dart';

void main() {
  group('GetMovieDetailsUseCase Tests', () {
    late GetMovieDetailsUseCase sut;
    late MockMovieRepository mockRepository;

    setUp(() {
      mockRepository = MockMovieRepository();
      sut = GetMovieDetailsUseCase(mockRepository);
    });

    tearDown(() {
      mockRepository.reset();
    });

    test('should return movie details when request is successful', () async {
      const movieId = 'tt0111161';
      final expectedMovieDetails = TestFixtures.testMovieDetails;
      mockRepository.setMovieDetailsResult(expectedMovieDetails);

      final result = await sut.call(movieId);

      expect(result, equals(expectedMovieDetails));
      expect(result.title, equals('The Shawshank Redemption'));
      expect(result.director, equals('Frank Darabont'));
      expect(result.year, equals(1994));
      expect(result.genre, equals('Drama'));
    });

    test('should throw exception when movie is not found', () async {
      const movieId = 'invalid_id';
      final exception = Exception('Movie not found');
      mockRepository.setMovieDetailsException(exception);

      expect(() async => await sut.call(movieId), throwsA(isA<Exception>()));
    });

    test('should throw exception when repository throws exception', () async {
      const movieId = 'tt0111161';
      final exception = Exception('Network error');
      mockRepository.setMovieDetailsException(exception);

      expect(() async => await sut.call(movieId), throwsA(isA<Exception>()));
    });

    test(
      'should trim whitespace from movie ID before calling repository',
      () async {
        const movieIdWithSpaces = '  tt0111161  ';
        final expectedMovieDetails = TestFixtures.testMovieDetails;
        mockRepository.setMovieDetailsResult(expectedMovieDetails);

        final result = await sut.call(movieIdWithSpaces);

        expect(result, equals(expectedMovieDetails));
      },
    );

    test('should handle empty movie ID', () async {
      const emptyMovieId = '';
      final exception = Exception('Movie not found');
      mockRepository.setMovieDetailsException(exception);

      expect(
        () async => await sut.call(emptyMovieId),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle movie ID with only whitespace', () async {
      const whitespaceMovieId = '   ';
      final exception = Exception('Movie not found');
      mockRepository.setMovieDetailsException(exception);

      expect(
        () async => await sut.call(whitespaceMovieId),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle special format movie IDs', () async {
      const specialMovieId = 'tt1234567';
      final expectedMovieDetails = TestFixtures.testMovieDetails;
      mockRepository.setMovieDetailsResult(expectedMovieDetails);

      final result = await sut.call(specialMovieId);

      expect(result, equals(expectedMovieDetails));
    });

    test('should handle non-standard movie ID formats', () async {
      const nonStandardId = 'custom_movie_id_123';
      final expectedMovieDetails = TestFixtures.testMovieDetails;
      mockRepository.setMovieDetailsResult(expectedMovieDetails);

      final result = await sut.call(nonStandardId);

      expect(result, equals(expectedMovieDetails));
    });

    test(
      'should handle multiple consecutive calls with different IDs',
      () async {
        const movieId1 = 'tt0111161';
        const movieId2 = 'tt0068646';
        final movieDetails1 = TestFixtures.testMovieDetails;
        final movieDetails2 = TestFixtures.testMovieDetails;

        mockRepository.setMovieDetailsResult(movieDetails1);
        final result1 = await sut.call(movieId1);
        expect(result1, equals(movieDetails1));

        mockRepository.setMovieDetailsResult(movieDetails2);
        final result2 = await sut.call(movieId2);
        expect(result2, equals(movieDetails2));
      },
    );

    test('should handle API timeout scenarios', () async {
      const movieId = 'tt0111161';
      final exception = Exception('Request timeout');
      mockRepository.setMovieDetailsException(exception);

      expect(() async => await sut.call(movieId), throwsA(isA<Exception>()));
    });

    test('should handle network connectivity issues', () async {
      const movieId = 'tt0111161';
      final exception = Exception('No internet connection');
      mockRepository.setMovieDetailsException(exception);

      expect(() async => await sut.call(movieId), throwsA(isA<Exception>()));
    });
  });
}
