import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serasa_challenge/core/extensions/navigator_extensions.dart';
import 'package:serasa_challenge/core/routes/app_routes.dart';

import '../viewmodel/bloc/recent_movies_bloc.dart';
import '../viewmodel/bloc/recent_movies_event.dart';
import '../viewmodel/bloc/recent_movies_state.dart';
import 'widgets/movie_grid_card.dart';

class RecentMoviesView extends StatefulWidget {
  const RecentMoviesView({super.key});

  @override
  State<RecentMoviesView> createState() => _RecentMoviesViewState();
}

class _RecentMoviesViewState extends State<RecentMoviesView> {
  @override
  void initState() {
    super.initState();
    context.read<RecentMoviesBloc>().add(LoadRecentMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          Text(
            'Filmes Assistidos Recentemente',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: BlocBuilder<RecentMoviesBloc, RecentMoviesState>(
              builder: (context, state) {
                if (state is RecentMoviesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is RecentMoviesError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Erro: ${state.message}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (state is RecentMoviesEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.movie_filter_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Nenhum filme assistido recentemente',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                if (state is RecentMoviesLoaded) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.7,
                        ),
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];
                      return MovieGridCard(
                        movie: movie,
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.movieDetails,
                            arguments: movie.id,
                          );
                        },
                      );
                    },
                  );
                }

                return const Center(child: Text('Estado não reconhecido'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
