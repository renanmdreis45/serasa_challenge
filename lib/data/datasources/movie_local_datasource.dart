import 'dart:convert';

import 'package:serasa_challenge/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/movie.dart';
import '../mappers/movie_mapper.dart';

abstract class MovieLocalDataSource {
  Future<List<Movie>> getRecentMovies();
  Future<void> saveRecentMovie(Movie movie);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  @override
  Future<List<Movie>> getRecentMovies() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final moviesJsonList =
          prefs.getStringList(AppConstants.recentMoviesKey) ?? [];

      final List<Map<String, dynamic>> movieMaps = moviesJsonList
          .map((jsonString) => json.decode(jsonString) as Map<String, dynamic>)
          .toList();

      return MovieMapper.fromJsonList(movieMaps);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveRecentMovie(Movie movie) async {
    try {
      final currentMovies = await getRecentMovies();

      currentMovies.removeWhere(
        (m) =>
            m.title == movie.title &&
            m.director == movie.director &&
            m.year == movie.year,
      );

      currentMovies.insert(0, movie);

      if (currentMovies.length > AppConstants.maxRecentMovies) {
        currentMovies.removeRange(AppConstants.maxRecentMovies, currentMovies.length);
      }

      await _saveMoviesList(currentMovies);
    } catch (e) {
      throw Exception('Erro ao salvar filme recente: $e');
    }
  }

  Future<void> _saveMoviesList(List<Movie> movies) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> moviesJsonList = movies
        .map((movie) => json.encode(MovieMapper.toJson(movie)))
        .toList();

    await prefs.setStringList(AppConstants.recentMoviesKey, moviesJsonList);
  }
}
