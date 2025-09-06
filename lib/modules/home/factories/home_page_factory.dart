import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serasa_challenge/core/widgets/main_navigation_wrapper.dart';
import 'package:serasa_challenge/data/api/adapters/dio_http_adapter.dart';
import 'package:serasa_challenge/data/datasources/movie_local_datasource.dart';
import 'package:serasa_challenge/data/datasources/movie_remote_datasource.dart';
import 'package:serasa_challenge/data/repositories/movie_repository_impl.dart';
import 'package:serasa_challenge/domain/repositories/movie_repository.dart';
import 'package:serasa_challenge/domain/usecases/get_movie_details_usecase.dart';
import 'package:serasa_challenge/domain/usecases/get_recent_movies_usecase.dart';
import 'package:serasa_challenge/domain/usecases/save_recent_movie_usecase.dart';
import 'package:serasa_challenge/domain/usecases/search_movies_usecase.dart';
import 'package:serasa_challenge/modules/movie_details/viewmodel/bloc/movie_details_bloc.dart';
import 'package:serasa_challenge/modules/recent_movies/viewmodel/bloc/recent_movies_bloc.dart';
import 'package:serasa_challenge/modules/search_movies/viewmodel/bloc/movie_search_bloc.dart';

Widget makeHomePage({String? routeName}) {
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

  final searchMoviesUseCase = SearchMoviesUseCase(movieRepository);
  final saveRecentMovieUseCase = SaveRecentMovieUseCase(movieRepository);
  final getMovieDetailsUseCase = GetMovieDetailsUseCase(movieRepository);
  final getRecentMoviesUseCase = GetRecentMoviesUseCase(movieRepository);

  final movieSearchBloc = MovieSearchBloc(
    searchMoviesUseCase: searchMoviesUseCase,
    saveRecentMovieUseCase: saveRecentMovieUseCase,
  );

  final movieDetailsBloc = MovieDetailBloc(
    getMovieDetailsUseCase: getMovieDetailsUseCase,
  );

  final recentMoviesBloc = RecentMoviesBloc(
    getRecentMoviesUseCase: getRecentMoviesUseCase,
  );

  return MultiBlocProvider(
    providers: [
      BlocProvider<MovieSearchBloc>.value(value: movieSearchBloc),
      BlocProvider<MovieDetailBloc>.value(value: movieDetailsBloc),
      BlocProvider<RecentMoviesBloc>.value(value: recentMoviesBloc),
    ],
    child: MainNavigationWrapper(initialRoute: routeName),
  );
}
