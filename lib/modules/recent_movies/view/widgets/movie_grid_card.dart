import 'package:flutter/material.dart';
import 'package:serasa_challenge/domain/entities/movie.dart';

import 'movie_grid_info.dart';
import 'movie_grid_poster.dart';

class MovieGridCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;

  const MovieGridCard({super.key, required this.movie, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 3, child: MovieGridPoster(movie: movie)),
            Expanded(flex: 1, child: MovieGridInfo(movie: movie)),
          ],
        ),
      ),
    );
  }
}
