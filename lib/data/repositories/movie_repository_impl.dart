import 'package:flutter/foundation.dart';

import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/repositories/movie_repository.dart';
import '../api/exceptions/exceptions.dart';
import '../datasources/movie_local_datasource.dart';
import '../datasources/movie_remote_datasource.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Movie>> searchMovies(String query) async {
    try {
      if (query.trim().isEmpty) {
        throw ArgumentError('Query não pode ser vazia');
      }

      final movies = await remoteDataSource.searchMovies(query);
      return movies;
    } on HttpException {
      rethrow;
    } catch (e) {
      throw Exception('Erro ao buscar filmes: $e');
    }
  }

  @override
  Future<MovieDetails> getMovieDetails(String id) async {
    try {
      if (id.trim().isEmpty) {
        throw ArgumentError('ID do filme não pode ser vazio');
      }

      final movieDetails = await remoteDataSource.getMovieDetails(id);

      return movieDetails;
    } on HttpException {
      rethrow;
    } catch (e) {
      throw Exception('Erro ao buscar detalhes do filme: $e');
    }
  }

  @override
  Future<List<Movie>> getRecentMovies() async {
    try {
      return await localDataSource.getRecentMovies();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveRecentMovie(Movie movie) async {
    try {
      await localDataSource.saveRecentMovie(movie);
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao salvar filme recente: $e');
      }
    }
  }
}
