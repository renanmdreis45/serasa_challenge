import 'package:equatable/equatable.dart';
import 'package:serasa_challenge/domain/entities/movie_details.dart';

abstract class MovieDetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetails movieDetail;

  MovieDetailLoaded({required this.movieDetail});

  @override
  List<Object> get props => [movieDetail];
}

class MovieDetailError extends MovieDetailState {
  final String message;

  MovieDetailError({required this.message});

  @override
  List<Object> get props => [message];
}
