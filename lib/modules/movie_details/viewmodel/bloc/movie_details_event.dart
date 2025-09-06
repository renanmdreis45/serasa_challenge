import 'package:equatable/equatable.dart';

abstract class MovieDetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetMovieDetail extends MovieDetailEvent {
  final String imdbId;

  GetMovieDetail({required this.imdbId});

  @override
  List<Object> get props => [imdbId];
}
