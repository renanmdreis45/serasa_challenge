import 'package:flutter_test/flutter_test.dart';
import 'package:serasa_challenge/data/api/exceptions/exceptions.dart';
import 'package:serasa_challenge/data/datasources/movie_remote_datasource.dart';

import '../../helpers/api_test_fixtures.dart';
import '../../helpers/mock_http_adapter.dart';

void main() {
  group('MovieRemoteDataSourceImpl', () {
    late MovieRemoteDataSourceImpl sut;
    late MockHttpAdapter mockHttpAdapter;

    setUp(() {
      mockHttpAdapter = MockHttpAdapter();
      sut = MovieRemoteDataSourceImpl(
        httpAdapter: mockHttpAdapter,
        apiKey: 'test-api-key',
      );
    });

    group('searchMovies', () {
      test('should return movies when search is successful', () async {
        const query = 'Shawshank';
        final httpResponse = ApiTestFixtures.successfulSearchHttpResponse;
        mockHttpAdapter.setResponse(httpResponse);

        final result = await sut.searchMovies(query);

        expect(result, hasLength(2));
        expect(result[0].id, equals('tt0111161'));
        expect(result[0].title, equals('The Shawshank Redemption'));
        expect(result[0].director, equals('Frank Darabont'));
        expect(result[0].year, equals(1994));
        expect(result[0].poster, equals('https://example.com/poster1.jpg'));

        expect(result[1].id, equals('tt0068646'));
        expect(result[1].title, equals('The Godfather'));
        expect(result[1].director, equals('Francis Ford Coppola'));
        expect(result[1].year, equals(1972));
        expect(result[1].poster, equals('https://example.com/poster2.jpg'));
      });

      test('should return empty list when no movies found', () async {
        const query = 'NonExistentMovie';
        final httpResponse = ApiTestFixtures.emptySearchHttpResponse;
        mockHttpAdapter.setResponse(httpResponse);

        final result = await sut.searchMovies(query);

        expect(result, isEmpty);
      });

      test('should throw HttpException when status code is not 200', () async {
        const query = 'ErrorQuery';
        final httpResponse = ApiTestFixtures.networkErrorHttpResponse;
        mockHttpAdapter.setResponse(httpResponse);

        expect(() => sut.searchMovies(query), throwsA(isA<HttpException>()));
      });

      test(
        'should throw HttpException when API returns unauthorized',
        () async {
          const query = 'UnauthorizedQuery';
          final httpResponse = ApiTestFixtures.unauthorizedHttpResponse;
          mockHttpAdapter.setResponse(httpResponse);

          expect(() => sut.searchMovies(query), throwsA(isA<HttpException>()));
        },
      );

      test('should throw Exception when HTTP adapter throws', () async {
        const query = 'ExceptionQuery';
        const errorMessage = 'Network connection failed';
        mockHttpAdapter.setException(Exception(errorMessage));

        expect(() => sut.searchMovies(query), throwsA(isA<Exception>()));
      });
    });

    group('getMovieDetails', () {
      test('should return movie details when request is successful', () async {
        const imdbId = 'tt0111161';
        final httpResponse = ApiTestFixtures.movieDetailsHttpResponse;
        mockHttpAdapter.setResponse(httpResponse);

        final result = await sut.getMovieDetails(imdbId);

        expect(result.title, equals('The Shawshank Redemption'));
        expect(result.director, equals('Frank Darabont'));
        expect(result.year, equals(1994));
        expect(result.genre, equals('Drama'));
        expect(result.synopsis, contains('Two imprisoned men bond'));
        expect(result.poster, equals('https://example.com/poster1.jpg'));
      });

      test('should throw HttpException when movie not found', () async {
        const imdbId = 'tt0000000';
        final httpResponse = ApiTestFixtures.movieNotFoundHttpResponse;
        mockHttpAdapter.setResponse(httpResponse);

        expect(
          () => sut.getMovieDetails(imdbId),
          throwsA(isA<HttpException>()),
        );
      });

      test('should throw HttpException when status code is not 200', () async {
        const imdbId = 'tt0111161';
        final httpResponse = ApiTestFixtures.networkErrorHttpResponse;
        mockHttpAdapter.setResponse(httpResponse);

        expect(
          () => sut.getMovieDetails(imdbId),
          throwsA(isA<HttpException>()),
        );
      });

      test('should throw Exception when HTTP adapter throws', () async {
        const imdbId = 'tt0111161';
        const errorMessage = 'Connection timeout';
        mockHttpAdapter.setException(Exception(errorMessage));

        expect(() => sut.getMovieDetails(imdbId), throwsA(isA<Exception>()));
      });
    });
  });
}
