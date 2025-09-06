import 'dart:convert';

import 'package:serasa_challenge/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/movie.dart';
import '../api/mappers/movie_mapper.dart';

abstract class MovieLocalDataSource {
  Future<List<Movie>> getRecentMovies();
  Future<void> saveRecentMovie(Movie movie);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  @override
  Future<List<Movie>> getRecentMovies() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final recentMoviesJsonString = prefs.getString(
        AppConstants.recentMoviesKey,
      );

      if (recentMoviesJsonString == null || recentMoviesJsonString.isEmpty) {
        return [];
      }

      final List<dynamic> recentMoviesJson = jsonDecode(recentMoviesJsonString);
      return recentMoviesJson
          .map((movieJson) => MovieMapper.fromJson(movieJson))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveRecentMovie(Movie movie) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      List<Movie> recentMovies = await getRecentMovies();

      recentMovies.removeWhere((existingMovie) => existingMovie.id == movie.id);

      recentMovies.insert(0, movie);

      if (recentMovies.length > AppConstants.maxRecentMovies) {
        recentMovies = recentMovies.take(AppConstants.maxRecentMovies).toList();
      }

      final recentMoviesJson = recentMovies
          .map((movie) => MovieMapper.toJson(movie))
          .toList();

      final jsonString = jsonEncode(recentMoviesJson);
      await prefs.setString(AppConstants.recentMoviesKey, jsonString);
    } catch (e) {
      print(e);
    }
  }
}
