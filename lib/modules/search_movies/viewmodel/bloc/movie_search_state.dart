import 'package:equatable/equatable.dart';
import 'package:serasa_challenge/domain/entities/movie.dart';

abstract class MovieSearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class MovieSearchInitial extends MovieSearchState {}

class MovieSearchLoading extends MovieSearchState {}

class MovieSearchLoaded extends MovieSearchState {
  final List<Movie> movies;

  MovieSearchLoaded({required this.movies});

  @override
  List<Object> get props => [movies];
}

class MovieSearchError extends MovieSearchState {
  final String message;

  MovieSearchError({required this.message});

  @override
  List<Object> get props => [message];
}

class MovieSearchEmpty extends MovieSearchState {}
