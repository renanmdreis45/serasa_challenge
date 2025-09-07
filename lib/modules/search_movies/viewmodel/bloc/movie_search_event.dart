import 'package:equatable/equatable.dart';

abstract class MovieSearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchMovies extends MovieSearchEvent {
  final String query;
  final int page;

  SearchMovies({required this.query, this.page = 1});

  @override
  List<Object> get props => [query, page];
}

class LoadMoreMovies extends MovieSearchEvent {
  final String query;
  final int page;

  LoadMoreMovies({required this.query, required this.page});

  @override
  List<Object> get props => [query, page];
}

class ClearSearchResults extends MovieSearchEvent {}
