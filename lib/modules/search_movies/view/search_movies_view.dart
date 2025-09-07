import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/constants/app_images.dart';
import '../../../core/extensions/navigator_extensions.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/responsive_builder.dart';
import '../../../domain/entities/movie.dart';
import '../viewmodel/bloc/movie_search_bloc.dart';
import '../viewmodel/bloc/movie_search_event.dart';
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
  final PagingController<int, Movie> _pagingController = PagingController(
    firstPageKey: 1,
  );
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      if (_currentQuery.isNotEmpty) {
        context.read<MovieSearchBloc>().add(
          LoadMoreMovies(query: _currentQuery, page: pageKey),
        );
      }
    });
  }

  bool _movieExists(Movie movie) {
    final currentList = _pagingController.itemList ?? [];
    return currentList.any((existingMovie) => existingMovie.id == movie.id);
  }

  List<Movie> _filterDuplicates(List<Movie> newMovies) {
    return newMovies.where((movie) => !_movieExists(movie)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchTextField(
            controller: _searchController,
            onChanged: (query) {
              if (query.trim().isNotEmpty) {
                _currentQuery = query.trim();
                _pagingController.value = PagingState(
                  nextPageKey: 1,
                  itemList: [],
                  error: null,
                );
                context.read<MovieSearchBloc>().add(SearchMovies(query: query));
              } else {
                _currentQuery = '';
                _pagingController.value = PagingState(
                  nextPageKey: null,
                  itemList: [],
                  error: null,
                );
                context.read<MovieSearchBloc>().add(ClearSearchResults());
              }
            },
          ),
          const SizedBox(height: 24),

          Expanded(
            child: BlocConsumer<MovieSearchBloc, MovieSearchState>(
              listener: (context, state) {
                if (state is MovieSearchLoaded) {
                  final isFirstPage = state.currentPage == 1;

                  if (isFirstPage) {
                    _pagingController.value = PagingState(
                      nextPageKey: state.hasReachedMax
                          ? null
                          : state.currentPage + 1,
                      itemList: state.movies,
                      error: null,
                    );
                  } else {
                    final uniqueMovies = _filterDuplicates(state.movies);
                    if (uniqueMovies.isNotEmpty) {
                      if (state.hasReachedMax) {
                        _pagingController.appendLastPage(uniqueMovies);
                      } else {
                        final nextPageKey = state.currentPage + 1;
                        _pagingController.appendPage(uniqueMovies, nextPageKey);
                      }
                    } else if (state.hasReachedMax) {
                      _pagingController.appendLastPage([]);
                    }
                  }
                } else if (state is MovieSearchError) {
                  _pagingController.error = state.message;
                } else if (state is MovieSearchEmpty) {
                  _pagingController.value = PagingState(
                    nextPageKey: null,
                    itemList: [],
                    error: null,
                  );
                } else if (state is MovieSearchInitial) {
                  _pagingController.value = PagingState(
                    nextPageKey: null,
                    itemList: [],
                    error: null,
                  );
                }
              },
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

                return PagedListView<int, Movie>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Movie>(
                    itemBuilder: (context, movie, index) {
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
                    firstPageProgressIndicatorBuilder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    newPageProgressIndicatorBuilder: (_) => const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    firstPageErrorIndicatorBuilder: (_) => Center(
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
                            'Erro: ${_pagingController.error}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _pagingController.refresh(),
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    ),
                    newPageErrorIndicatorBuilder: (_) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Erro ao carregar mais filmes: ${_pagingController.error}',
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () =>
                                  _pagingController.retryLastFailedRequest(),
                              child: const Text('Tentar novamente'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    noItemsFoundIndicatorBuilder: (_) => const Center(
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
                    ),
                  ),
                );
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
    _pagingController.dispose();
    super.dispose();
  }
}
