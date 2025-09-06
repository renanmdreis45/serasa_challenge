import 'package:equatable/equatable.dart';

abstract class MovieSearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchMovies extends MovieSearchEvent {
  final String query;

  SearchMovies({required this.query});

  @override
  List<Object> get props => [query];
}

class ClearSearchResults extends MovieSearchEvent {}
