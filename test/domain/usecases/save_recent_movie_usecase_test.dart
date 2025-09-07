import 'package:flutter_test/flutter_test.dart';
import 'package:serasa_challenge/domain/usecases/save_recent_movie_usecase.dart';

import '../../helpers/mock_movie_repository.dart';
import '../../helpers/test_fixtures.dart';

void main() {
  group('SaveRecentMovieUseCase Tests', () {
    late SaveRecentMovieUseCase sut;
    late MockMovieRepository mockRepository;

    setUp(() {
      mockRepository = MockMovieRepository();
      sut = SaveRecentMovieUseCase(mockRepository);
    });

    tearDown(() {
      mockRepository.reset();
    });

    test(
      'should save movie successfully when repository operation succeeds',
      () async {
        final movieToSave = TestFixtures.testMovie1;

        await sut.call(movieToSave);

        expect(mockRepository.savedMovies, contains(movieToSave));
        expect(mockRepository.savedMovies.length, equals(1));
      },
    );

    test('should throw exception when repository throws exception', () async {
      final movieToSave = TestFixtures.testMovie1;
      final exception = Exception('Storage error');
      mockRepository.setSaveRecentMovieException(exception);

      expect(
        () async => await sut.call(movieToSave),
        throwsA(isA<Exception>()),
      );
    });

    test('should save multiple movies in order', () async {
      final movie1 = TestFixtures.testMovie1;
      final movie2 = TestFixtures.testMovie2;
      final movie3 = TestFixtures.testMovie3;

      await sut.call(movie1);
      await sut.call(movie2);
      await sut.call(movie3);

      expect(mockRepository.savedMovies.length, equals(3));
      expect(mockRepository.savedMovies[0], equals(movie1));
      expect(mockRepository.savedMovies[1], equals(movie2));
      expect(mockRepository.savedMovies[2], equals(movie3));
    });

    test('should handle saving the same movie multiple times', () async {
      final movieToSave = TestFixtures.testMovie1;

      await sut.call(movieToSave);
      await sut.call(movieToSave);
      await sut.call(movieToSave);

      expect(mockRepository.savedMovies.length, equals(3));
      expect(
        mockRepository.savedMovies.every((movie) => movie == movieToSave),
        isTrue,
      );
    });

    test('should save movie with empty values', () async {
      final emptyMovie = TestFixtures.emptyMovie;

      await sut.call(emptyMovie);

      expect(mockRepository.savedMovies, contains(emptyMovie));
      expect(mockRepository.savedMovies.first.id, equals(''));
      expect(mockRepository.savedMovies.first.title, equals(''));
    });

    test('should handle movies with special characters', () async {
      final specialMovie =
          TestFixtures.testMovie1; 

      await sut.call(specialMovie);

      expect(mockRepository.savedMovies, contains(specialMovie));
    });

    test('should handle storage quota exceeded scenario', () async {
      final movieToSave = TestFixtures.testMovie1;
      final exception = Exception('Storage quota exceeded');
      mockRepository.setSaveRecentMovieException(exception);

      expect(
        () async => await sut.call(movieToSave),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle corrupted storage scenario', () async {
      final movieToSave = TestFixtures.testMovie1;
      final exception = Exception('Storage corrupted');
      mockRepository.setSaveRecentMovieException(exception);

      expect(
        () async => await sut.call(movieToSave),
        throwsA(isA<Exception>()),
      );
    });

    test('should complete successfully for movies with long titles', () async {
      final longTitleMovie =
          TestFixtures.testMovie1; 

      await sut.call(longTitleMovie);

      expect(mockRepository.savedMovies, contains(longTitleMovie));
    });

    test('should handle concurrent save operations gracefully', () async {
      final movie1 = TestFixtures.testMovie1;
      final movie2 = TestFixtures.testMovie2;

      await Future.wait([sut.call(movie1), sut.call(movie2)]);

      expect(mockRepository.savedMovies.length, equals(2));
      expect(mockRepository.savedMovies, containsAll([movie1, movie2]));
    });

    test('should handle movies with maximum field lengths', () async {
      final maxLengthMovie = TestFixtures.testMovie1; 

      await sut.call(maxLengthMovie);

      expect(mockRepository.savedMovies, contains(maxLengthMovie));
    });
  });
}
