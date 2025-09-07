import 'package:flutter_test/flutter_test.dart';
import 'package:serasa_challenge/data/datasources/movie_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_fixtures.dart';

void main() {
  group('MovieLocalDataSourceImpl', () {
    late MovieLocalDataSourceImpl sut;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      sut = MovieLocalDataSourceImpl();
    });

    group('getRecentMovies', () {
      test('should return empty list when no movies are stored', () async {
        final result = await sut.getRecentMovies();

        expect(result, isEmpty);
      });

      test('should return list of movies when movies are stored', () async {
        final movies = TestFixtures.testMoviesList;
        for (final movie in movies) {
          await sut.saveRecentMovie(movie);
        }

        final result = await sut.getRecentMovies();

        expect(result, hasLength(3));
        expect(result[0].id, equals('tt0071562')); 
        expect(result[0].title, equals('The Godfather Part II'));
        expect(result[1].id, equals('tt0068646'));
        expect(result[1].title, equals('The Godfather'));
        expect(result[2].id, equals('tt0111161'));
        expect(result[2].title, equals('The Shawshank Redemption'));
      });

      test('should return empty list when stored data is corrupted', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('recent_movies', 'invalid_json');

        final result = await sut.getRecentMovies();

        expect(result, isEmpty);
      });
    });

    group('saveRecentMovie', () {
      test('should save movie to shared preferences', () async {
        final movie = TestFixtures.testMovie1;

        await sut.saveRecentMovie(movie);

        final result = await sut.getRecentMovies();
        expect(result, hasLength(1));
        expect(result[0], equals(movie));
      });

      test('should not save duplicate movies', () async {
        final movie = TestFixtures.testMovie1;

        await sut.saveRecentMovie(movie);
        await sut.saveRecentMovie(movie); 

        final result = await sut.getRecentMovies();
        expect(result, hasLength(1));
        expect(result[0], equals(movie));
      });

      test('should maintain order with most recent first', () async {
        final movie1 = TestFixtures.testMovie1;
        final movie2 = TestFixtures.testMovie2;
        final movie3 = TestFixtures.testMovie3;

        await sut.saveRecentMovie(movie1);
        await sut.saveRecentMovie(movie2);
        await sut.saveRecentMovie(movie3);

        final result = await sut.getRecentMovies();
        expect(result[0], equals(movie3)); 
        expect(result[1], equals(movie2));
        expect(result[2], equals(movie1));
      });

      test('should move existing movie to top when saved again', () async {
        final movie1 = TestFixtures.testMovie1;
        final movie2 = TestFixtures.testMovie2;
        final movie3 = TestFixtures.testMovie3;

        await sut.saveRecentMovie(movie1);
        await sut.saveRecentMovie(movie2);
        await sut.saveRecentMovie(movie3);
        await sut.saveRecentMovie(movie1); 

        final result = await sut.getRecentMovies();
        expect(result[0], equals(movie1)); 
        expect(result[1], equals(movie3));
        expect(result[2], equals(movie2));
        expect(result, hasLength(3)); 
      });
    });
  });
}
