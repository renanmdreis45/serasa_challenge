import 'package:flutter_test/flutter_test.dart';
import 'package:serasa_challenge/data/repositories/movie_repository_impl.dart';
import 'package:serasa_challenge/domain/entities/movie.dart';

import '../../helpers/mock_movie_local_datasource.dart';
import '../../helpers/mock_movie_remote_datasource.dart';
import '../../helpers/test_fixtures.dart';

void main() {
  group('MovieRepositoryImpl', () {
    late MovieRepositoryImpl sut;
    late MockMovieRemoteDataSource mockRemoteDataSource;
    late MockMovieLocalDataSource mockLocalDataSource;

    setUp(() {
      mockRemoteDataSource = MockMovieRemoteDataSource();
      mockLocalDataSource = MockMovieLocalDataSource();
      sut = MovieRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
      );
    });

    group('searchMovies', () {
      test(
        'should return movies from remote data source when successful',
        () async {
          const query = 'Shawshank';
          final expectedMovies = TestFixtures.testMoviesList;
          mockRemoteDataSource.setSearchMoviesResult(expectedMovies);

          final result = await sut.searchMovies(query);

          expect(result, equals(expectedMovies));
        },
      );

      test('should throw Exception when query is empty', () async {
        const query = '';

        expect(() => sut.searchMovies(query), throwsA(isA<Exception>()));
      });

      test('should throw Exception when query is only whitespace', () async {
        const query = '   ';

        expect(() => sut.searchMovies(query), throwsA(isA<Exception>()));
      });

      test('should throw Exception when remote data source fails', () async {
        const query = 'ErrorQuery';
        const errorMessage = 'Network error';
        mockRemoteDataSource.setSearchMoviesException(Exception(errorMessage));

        expect(() => sut.searchMovies(query), throwsA(isA<Exception>()));
      });
    });

    group('getMovieDetails', () {
      test(
        'should return movie details from remote data source when successful',
        () async {
          const imdbId = 'tt0111161';
          final expectedDetails = TestFixtures.testMovieDetails;
          mockRemoteDataSource.setMovieDetailsResult(expectedDetails);

          final result = await sut.getMovieDetails(imdbId);

          expect(result, equals(expectedDetails));
        },
      );

      test('should throw Exception when id is empty', () async {
        const imdbId = '';

        expect(() => sut.getMovieDetails(imdbId), throwsA(isA<Exception>()));
      });

      test('should throw Exception when id is only whitespace', () async {
        const imdbId = '   ';

        expect(() => sut.getMovieDetails(imdbId), throwsA(isA<Exception>()));
      });

      test('should throw Exception when remote data source fails', () async {
        const imdbId = 'tt0000000';
        const errorMessage = 'Movie not found';
        mockRemoteDataSource.setMovieDetailsException(Exception(errorMessage));

        expect(() => sut.getMovieDetails(imdbId), throwsA(isA<Exception>()));
      });
    });

    group('getRecentMovies', () {
      test(
        'should return movies from local data source when successful',
        () async {
          final expectedMovies = TestFixtures.testMoviesList;
          mockLocalDataSource.setGetRecentMoviesResult(expectedMovies);

          final result = await sut.getRecentMovies();

          expect(result, equals(expectedMovies));
        },
      );

      test(
        'should return empty list when local data source has no movies',
        () async {
          final emptyList = <Movie>[];
          mockLocalDataSource.setGetRecentMoviesResult(emptyList);

          final result = await sut.getRecentMovies();

          expect(result, isEmpty);
        },
      );

      test(
        'should return empty list when local data source throws exception',
        () async {
          const errorMessage = 'Storage error';
          mockLocalDataSource.setGetRecentMoviesException(
            Exception(errorMessage),
          );

          final result = await sut.getRecentMovies();

          expect(result, isEmpty);
        },
      );
    });

    group('saveRecentMovie', () {
      test('should save movie to local data source when successful', () async {
        final movie = TestFixtures.testMovie1;

        await sut.saveRecentMovie(movie);

        expect(mockLocalDataSource.savedMovies, contains(movie));
      });

      test(
        'should not throw when local data source throws exception',
        () async {
          final movie = TestFixtures.testMovie1;
          const errorMessage = 'Save operation failed';
          mockLocalDataSource.setSaveRecentMovieException(
            Exception(errorMessage),
          );

          expect(() => sut.saveRecentMovie(movie), returnsNormally);
        },
      );
    });
  });
}
