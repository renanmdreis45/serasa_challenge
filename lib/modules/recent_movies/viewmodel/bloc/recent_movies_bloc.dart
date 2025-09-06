import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/get_recent_movies_usecase.dart';
import 'recent_movies_event.dart';
import 'recent_movies_state.dart';

class RecentMoviesBloc extends Bloc<RecentMoviesEvent, RecentMoviesState> {
  final GetRecentMoviesUseCase getRecentMoviesUseCase;

  RecentMoviesBloc({
    required this.getRecentMoviesUseCase,
  }) : super(RecentMoviesInitial()) {
    on<LoadRecentMovies>(_onLoadRecentMovies);
    on<ClearRecentMovies>(_onClearRecentMovies);
  }

  void _onLoadRecentMovies(
    LoadRecentMovies event,
    Emitter<RecentMoviesState> emit,
  ) async {
    emit(RecentMoviesLoading());
    
    try {
      final movies = await getRecentMoviesUseCase();
      
      if (movies.isEmpty) {
        emit(RecentMoviesEmpty());
      } else {
        emit(RecentMoviesLoaded(movies: movies));
      }
    } catch (e) {
      emit(RecentMoviesError(message: 'Erro inesperado: $e'));
    }
  }

  void _onClearRecentMovies(
    ClearRecentMovies event,
    Emitter<RecentMoviesState> emit,
  ) {
    emit(RecentMoviesEmpty());
  }
}
