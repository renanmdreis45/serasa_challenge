import 'package:flutter_test/flutter_test.dart';
import 'package:serasa_challenge/domain/usecases/get_recent_movies_usecase.dart';

import '../../helpers/mock_movie_repository.dart';
import '../../helpers/test_fixtures.dart';

void main() {
  group('GetRecentMoviesUseCase Tests', () {
    late GetRecentMoviesUseCase sut;
    late MockMovieRepository mockRepository;

    setUp(() {
      mockRepository = MockMovieRepository();
      sut = GetRecentMoviesUseCase(mockRepository);
    });

    tearDown(() {
      mockRepository.reset();
    });

    test(
      'should return list of recent movies when repository has data',
      () async {
        final expectedMovies = TestFixtures.testMoviesList;
        mockRepository.setRecentMoviesResult(expectedMovies);

        final result = await sut.call();

        expect(result, equals(expectedMovies));
        expect(result.length, equals(3));
        expect(
          result,
          containsAll([
            TestFixtures.testMovie1,
            TestFixtures.testMovie2,
            TestFixtures.testMovie3,
          ]),
        );
      },
    );

    test('should return empty list when no recent movies exist', () async {
      mockRepository.setRecentMoviesResult([]);

      final result = await sut.call();

      expect(result, isEmpty);
    });

    test('should throw exception when repository throws exception', () async {
      final exception = Exception('Storage error');
      mockRepository.setRecentMoviesException(exception);

      expect(() async => await sut.call(), throwsA(isA<Exception>()));
    });

    test(
      'should return single movie when only one recent movie exists',
      () async {
        final singleMovieList = [TestFixtures.testMovie1];
        mockRepository.setRecentMoviesResult(singleMovieList);

        final result = await sut.call();

        expect(result.length, equals(1));
        expect(result.first, equals(TestFixtures.testMovie1));
      },
    );

    test('should maintain order of recent movies', () async {
      final orderedMovies = [
        TestFixtures.testMovie3, 
        TestFixtures.testMovie1,
        TestFixtures.testMovie2, 
      ];
      mockRepository.setRecentMoviesResult(orderedMovies);

      final result = await sut.call();

      expect(result.length, equals(3));
      expect(result[0], equals(TestFixtures.testMovie3));
      expect(result[1], equals(TestFixtures.testMovie1));
      expect(result[2], equals(TestFixtures.testMovie2));
    });

    test('should handle multiple consecutive calls', () async {
      final firstCallMovies = [TestFixtures.testMovie1];
      final secondCallMovies = [
        TestFixtures.testMovie1,
        TestFixtures.testMovie2,
      ];

      mockRepository.setRecentMoviesResult(firstCallMovies);
      final result1 = await sut.call();
      expect(result1.length, equals(1));

      mockRepository.setRecentMoviesResult(secondCallMovies);
      final result2 = await sut.call();
      expect(result2.length, equals(2));
    });

    test('should handle storage corruption scenario', () async {
      final exception = Exception('Storage corrupted');
      mockRepository.setRecentMoviesException(exception);

      expect(() async => await sut.call(), throwsA(isA<Exception>()));
    });

    test('should handle storage access permission denied', () async {
      final exception = Exception('Permission denied');
      mockRepository.setRecentMoviesException(exception);

      expect(() async => await sut.call(), throwsA(isA<Exception>()));
    });

    test('should handle maximum number of recent movies', () async {
      final maxMovies = List.generate(10, (index) => TestFixtures.testMovie1);
      mockRepository.setRecentMoviesResult(maxMovies);

      final result = await sut.call();

      expect(result.length, equals(10));
      expect(result.every((movie) => movie == TestFixtures.testMovie1), isTrue);
    });

    test(
      'should handle movies with duplicate titles but different IDs',
      () async {
        final duplicateTitleMovies = [
          TestFixtures.testMovie1,
          TestFixtures
              .testMovie2, 
        ];
        mockRepository.setRecentMoviesResult(duplicateTitleMovies);

        final result = await sut.call();

        expect(result.length, equals(2));
        expect(result[0].id, isNot(equals(result[1].id)));
      },
    );

    test(
      'should handle network unavailable scenario when accessing cached data',
      () async {
        final cachedMovies = TestFixtures.testMoviesList;
        mockRepository.setRecentMoviesResult(cachedMovies);

        final result = await sut.call();

        expect(result, equals(cachedMovies));
      },
    );

    test('should return movies with all required fields populated', () async {
      final completeMovies = TestFixtures.testMoviesList;
      mockRepository.setRecentMoviesResult(completeMovies);

      final result = await sut.call();

      for (final movie in result) {
        expect(movie.id, isNotEmpty);
        expect(movie.title, isNotEmpty);
        expect(movie.director, isNotEmpty);
        expect(movie.year, greaterThan(0));
        expect(movie.poster, isNotEmpty);
      }
    });

    test('should handle empty or null fields in movies gracefully', () async {
      final movieWithEmptyFields = [TestFixtures.emptyMovie];
      mockRepository.setRecentMoviesResult(movieWithEmptyFields);

      final result = await sut.call();

      expect(result.length, equals(1));
      expect(result.first.id, equals(''));
      expect(result.first.title, equals(''));
    });
  });
}
