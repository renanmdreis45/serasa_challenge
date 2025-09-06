import '../../../../domain/entities/movie.dart';

abstract class RecentMoviesState {}

class RecentMoviesInitial extends RecentMoviesState {}

class RecentMoviesLoading extends RecentMoviesState {}

class RecentMoviesLoaded extends RecentMoviesState {
  final List<Movie> movies;
  
  RecentMoviesLoaded({required this.movies});
}

class RecentMoviesEmpty extends RecentMoviesState {}

class RecentMoviesError extends RecentMoviesState {
  final String message;
  
  RecentMoviesError({required this.message});
}
