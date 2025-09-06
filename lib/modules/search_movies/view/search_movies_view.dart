import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:serasa_challenge/core/constants/app_images.dart';
import 'package:serasa_challenge/core/extensions/navigator_extensions.dart';
import 'package:serasa_challenge/core/routes/app_routes.dart';

import '../viewmodel/bloc/movie_search_bloc.dart';
import '../viewmodel/bloc/movie_search_state.dart';
import 'widgets/movie_card.dart';
import 'widgets/search_text_field.dart';

class SearchMoviesView extends StatefulWidget {
  const SearchMoviesView({super.key});

  @override
  State<SearchMoviesView> createState() => _SearchMoviesViewState();
}

class _SearchMoviesViewState extends State<SearchMoviesView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchTextField(controller: _searchController),
          const SizedBox(height: 24),

          Expanded(
            child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
              builder: (context, state) {
                if (state is MovieSearchInitial) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppImages.searchIcon,
                          width: 64,
                          height: 64,
                          colorFilter: const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Digite algo para buscar filmes',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                if (state is MovieSearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is MovieSearchError) {
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

                if (state is MovieSearchEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.movie_filter_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum filme encontrado',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                if (state is MovieSearchLoaded) {
                  return ListView.builder(
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];
                      return MovieCard(
                        movie: movie,
                        onTap: () {
                          context.read<MovieSearchBloc>().saveRecentMovie(
                            movie,
                          );
                          context.pushNamed(
                            AppRoutes.movieDetails,
                            arguments: movie.id,
                          );
                        },
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
