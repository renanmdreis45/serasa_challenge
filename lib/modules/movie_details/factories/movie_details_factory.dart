import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serasa_challenge/data/api/adapters/dio_http_adapter.dart';
import 'package:serasa_challenge/data/datasources/movie_local_datasource.dart';
import 'package:serasa_challenge/data/datasources/movie_remote_datasource.dart';
import 'package:serasa_challenge/data/repositories/movie_repository_impl.dart';
import 'package:serasa_challenge/domain/repositories/movie_repository.dart';
import 'package:serasa_challenge/domain/usecases/get_movie_details_usecase.dart';
import 'package:serasa_challenge/modules/movie_details/viewmodel/bloc/movie_details_bloc.dart';

import '../view/movie_details_view.dart';

Widget makeMovieDetailsPage(String movieId) {
  final httpAdapter = DioHttpAdapter();
  final movieRemoteDataSource = MovieRemoteDataSourceImpl(
    httpAdapter: httpAdapter,
    baseUrl: 'http://www.omdbapi.com',
    apiKey: '9679c274',
  );
  final movieLocalDataSource = MovieLocalDataSourceImpl();

  final MovieRepository movieRepository = MovieRepositoryImpl(
    remoteDataSource: movieRemoteDataSource,
    localDataSource: movieLocalDataSource,
  );

  final getMovieDetailsUseCase = GetMovieDetailsUseCase(movieRepository);

  final movieDetailsBloc = MovieDetailBloc(
    getMovieDetailsUseCase: getMovieDetailsUseCase,
  );

  return BlocProvider<MovieDetailBloc>.value(
    value: movieDetailsBloc,
    child: MovieDetailsView(movieId: movieId),
  );
}
