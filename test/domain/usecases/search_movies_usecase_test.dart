import 'package:flutter_test/flutter_test.dart';
import 'package:serasa_challenge/domain/usecases/search_movies_usecase.dart';

import '../../helpers/mock_movie_repository.dart';
import '../../helpers/test_fixtures.dart';

void main() {
  group('SearchMoviesUseCase Tests', () {
    late SearchMoviesUseCase sut;
    late MockMovieRepository mockRepository;

    setUp(() {
      mockRepository = MockMovieRepository();
      sut = SearchMoviesUseCase(mockRepository);
    });

    tearDown(() {
      mockRepository.reset();
    });

    test('should return list of movies when search is successful', () async {
      const query = 'The Godfather';
      final expectedMovies = TestFixtures.testMoviesList;
      mockRepository.setSearchMoviesResult(expectedMovies);

      final result = await sut.call(query);

      expect(result, equals(expectedMovies));
      expect(result.length, equals(3));
      expect(result.first.title, equals('The Shawshank Redemption'));
    });

    test('should return empty list when no movies found', () async {
      const query = 'NonexistentMovie123';
      mockRepository.setSearchMoviesResult([]);

      final result = await sut.call(query);

      expect(result, isEmpty);
    });

    test('should throw exception when repository throws exception', () async {
      const query = 'The Godfather';
      final exception = Exception('Network error');
      mockRepository.setSearchMoviesException(exception);

      expect(() async => await sut.call(query), throwsA(isA<Exception>()));
    });

    test(
      'should trim whitespace from query before calling repository',
      () async {
        const queryWithSpaces = '  The Godfather  ';
        final expectedMovies = [TestFixtures.testMovie2];
        mockRepository.setSearchMoviesResult(expectedMovies);

        final result = await sut.call(queryWithSpaces);

        expect(result, equals(expectedMovies));
      },
    );

    test('should handle empty query string', () async {
      const emptyQuery = '';
      mockRepository.setSearchMoviesResult([]);

      final result = await sut.call(emptyQuery);

      expect(result, isEmpty);
    });

    test('should handle query with only whitespace', () async {
      const whitespaceQuery = '   ';
      mockRepository.setSearchMoviesResult([]);

      final result = await sut.call(whitespaceQuery);

      expect(result, isEmpty);
    });

    test('should handle special characters in query', () async {
      const specialQuery = 'Movie: The "Special" Characters & Symbols!';
      final expectedMovies = [TestFixtures.testMovie1];
      mockRepository.setSearchMoviesResult(expectedMovies);

      final result = await sut.call(specialQuery);

      expect(result, equals(expectedMovies));
    });

    test('should handle unicode characters in query', () async {
      const unicodeQuery = 'Película com Acentos àáâãäçéêë';
      final expectedMovies = [TestFixtures.testMovie3];
      mockRepository.setSearchMoviesResult(expectedMovies);

      final result = await sut.call(unicodeQuery);

      expect(result, equals(expectedMovies));
    });

    test('should handle very long query strings', () async {
      const longQuery =
          'This is a very long movie search query that might be used by someone who is very specific about what they are looking for in a movie and wants to include many details in their search terms to find exactly what they need';
      final expectedMovies = [TestFixtures.testMovie1];
      mockRepository.setSearchMoviesResult(expectedMovies);

      final result = await sut.call(longQuery);

      expect(result, equals(expectedMovies));
    });

    test('should handle multiple consecutive calls', () async {
      const query1 = 'First Query';
      const query2 = 'Second Query';
      final movies1 = [TestFixtures.testMovie1];
      final movies2 = [TestFixtures.testMovie2, TestFixtures.testMovie3];

      mockRepository.setSearchMoviesResult(movies1);
      final result1 = await sut.call(query1);
      expect(result1, equals(movies1));

      mockRepository.setSearchMoviesResult(movies2);
      final result2 = await sut.call(query2);
      expect(result2, equals(movies2));
    });
  });
}
