import 'package:equatable/equatable.dart';

import '../../../../domain/entities/movie.dart';

abstract class MovieSearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class MovieSearchInitial extends MovieSearchState {}

class MovieSearchLoading extends MovieSearchState {}

class MovieSearchLoaded extends MovieSearchState {
  final List<Movie> movies;
  final bool hasReachedMax;
  final int currentPage;

  MovieSearchLoaded({
    required this.movies,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  MovieSearchLoaded copyWith({
    List<Movie>? movies,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return MovieSearchLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [movies, hasReachedMax, currentPage];
}

class MovieSearchLoadingMore extends MovieSearchLoaded {
  MovieSearchLoadingMore({
    required super.movies,
    required super.currentPage,
    super.hasReachedMax,
  });
}

class MovieSearchError extends MovieSearchState {
  final String message;

  MovieSearchError({required this.message});

  @override
  List<Object> get props => [message];
}

class MovieSearchEmpty extends MovieSearchState {}
