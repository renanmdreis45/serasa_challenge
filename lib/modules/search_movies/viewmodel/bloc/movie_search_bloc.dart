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
    on<LoadMoreMovies>(_onLoadMoreMovies);
    on<ClearSearchResults>(_onClearSearchResults);
  }

  Future<void> _onSearchMovies(
    SearchMovies event,
    Emitter<MovieSearchState> emit,
  ) async {
    emit(MovieSearchLoading());

    try {
      final movies = await searchMoviesUseCase(event.query, page: event.page);

      if (movies.isEmpty) {
        emit(MovieSearchEmpty());
      } else {
        emit(
          MovieSearchLoaded(
            movies: movies,
            currentPage: event.page,
            hasReachedMax:
                movies.length <
                10,
          ),
        );
      }
    } catch (error) {
      emit(MovieSearchError(message: error.toString()));
    }
  }

  Future<void> _onLoadMoreMovies(
    LoadMoreMovies event,
    Emitter<MovieSearchState> emit,
  ) async {
    final currentState = state;
    if (currentState is MovieSearchLoaded && !currentState.hasReachedMax) {
      emit(
        MovieSearchLoadingMore(
          movies: currentState.movies,
          currentPage: currentState.currentPage,
          hasReachedMax: currentState.hasReachedMax,
        ),
      );

      try {
        final newMovies = await searchMoviesUseCase(
          event.query,
          page: event.page,
        );

        if (newMovies.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(
            MovieSearchLoaded(
              movies: newMovies,
              currentPage: event.page,
              hasReachedMax: newMovies.length < 10,
            ),
          );
        }
      } catch (error) {
        emit(MovieSearchError(message: error.toString()));
      }
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
