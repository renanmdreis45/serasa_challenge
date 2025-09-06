import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serasa_challenge/domain/usecases/save_recent_movie_usecase.dart';
import 'package:serasa_challenge/domain/usecases/search_movies_usecase.dart';

import 'movie_search_event.dart';
import 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMoviesUseCase searchMoviesUseCase;
  final SaveRecentMovieUseCase saveRecentMovieUseCase;

  MovieSearchBloc({
    required this.searchMoviesUseCase,
    required this.saveRecentMovieUseCase,
  }) : super(MovieSearchInitial()) {
    on<SearchMovies>(_onSearchMovies);
    on<ClearSearchResults>(_onClearSearchResults);
  }

  Future<void> _onSearchMovies(
    SearchMovies event,
    Emitter<MovieSearchState> emit,
  ) async {
    emit(MovieSearchLoading());

    try {
      final movies = await searchMoviesUseCase(event.query);

      if (movies.isEmpty) {
        emit(MovieSearchEmpty());
      } else {
        emit(MovieSearchLoaded(movies: movies));
      }
    } catch (error) {
      emit(MovieSearchError(message: error.toString()));
    }
  }

  Future<void> _onClearSearchResults(
    ClearSearchResults event,
    Emitter<MovieSearchState> emit,
  ) async {
    emit(MovieSearchInitial());
  }

  Future<void> saveRecentMovie(movie) async {
    await saveRecentMovieUseCase(movie);
  }
}
