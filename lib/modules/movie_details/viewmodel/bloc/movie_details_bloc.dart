import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serasa_challenge/domain/usecases/get_movie_details_usecase.dart';
import 'package:serasa_challenge/modules/movie_details/viewmodel/bloc/movie_details_event.dart';
import 'package:serasa_challenge/modules/movie_details/viewmodel/bloc/movie_details_state.dart';


class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetailsUseCase getMovieDetailsUseCase;

  MovieDetailBloc({required this.getMovieDetailsUseCase})
    : super(MovieDetailInitial()) {
    on<GetMovieDetail>(_onGetMovieDetail);
  }

  Future<void> _onGetMovieDetail(
    GetMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(MovieDetailLoading());

    try {
      final result = await getMovieDetailsUseCase(event.imdbId);
      emit(MovieDetailLoaded(movieDetail: result));
    } catch (e) {
      emit(MovieDetailError(message: e.toString()));
    }
  }
}
