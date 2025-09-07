import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:serasa_challenge/core/constants/app_breakpoints.dart';
import 'package:serasa_challenge/core/constants/app_images.dart';
import 'package:serasa_challenge/core/extensions/navigator_extensions.dart';
import 'package:serasa_challenge/core/widgets/no_image_placeholder.dart';
import 'package:serasa_challenge/core/widgets/responsive_builder.dart';
import 'package:serasa_challenge/modules/movie_details/widgets/movie_details_loading_view.dart';

import '../viewmodel/bloc/movie_details_bloc.dart';
import '../viewmodel/bloc/movie_details_event.dart';
import '../viewmodel/bloc/movie_details_state.dart';

class MovieDetailsView extends StatelessWidget {
  final String movieId;
  final String? movieTitle;

  const MovieDetailsView({super.key, required this.movieId, this.movieTitle});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieDetailBloc>().add(GetMovieDetail(imdbId: movieId));
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          BlocBuilder<MovieDetailBloc, MovieDetailState>(
            builder: (context, state) {
              if (state is MovieDetailLoading) {
                return const LinearProgressIndicator();
              }
              return const SizedBox.shrink();
            },
          ),
          Expanded(
            child: BlocBuilder<MovieDetailBloc, MovieDetailState>(
              builder: (context, state) {
                if (state is MovieDetailLoading) {
                  return MovieDetailsLoadingView(movieTitle: movieTitle);
                }

                if (state is MovieDetailError) {
                  return _buildErrorView(context, state.message);
                }

                if (state is MovieDetailLoaded) {
                  return _buildMovieDetailView(context, state);
                }

                return MovieDetailsLoadingView(movieTitle: movieTitle);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieDetailView(BuildContext context, MovieDetailLoaded state) {
    final movieDetail = state.movieDetail;

    return ResponsiveBuilder(
      builder: (context, constraints) {
        final isTabletOrDesktop =
            AppBreakpoints.isTablet(constraints.maxWidth) ||
            AppBreakpoints.isDesktop(constraints.maxWidth);
        final expandedHeight = isTabletOrDesktop ? 500.0 : 400.0;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: expandedHeight,
              pinned: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    AppImages.arrowBackIcon,
                    width: 24,
                    height: 24,
                  ),
                ),
                onPressed: () => context.pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Theme.of(
                          context,
                        ).scaffoldBackgroundColor.withValues(alpha: 0.8),
                        Theme.of(context).scaffoldBackgroundColor,
                      ],
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child:
                            movieDetail.poster.isNotEmpty &&
                                movieDetail.poster != 'N/A'
                            ? Image.network(
                                movieDetail.poster,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return NoImagePlaceholder(
                                    width: double.infinity,
                                    height: double.infinity,
                                    iconSize: 80,
                                    borderRadius: BorderRadius.circular(12),
                                  );
                                },
                              )
                            : NoImagePlaceholder(
                                width: double.infinity,
                                height: double.infinity,
                                iconSize: 80,
                                borderRadius: BorderRadius.circular(12),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movieDetail.title,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      '${movieDetail.year} • ${movieDetail.genre}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      movieDetail.synopsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movieTitle ?? 'Detalhes do Filme'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar detalhes',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
