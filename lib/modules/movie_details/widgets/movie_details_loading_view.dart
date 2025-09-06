import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:serasa_challenge/core/constants/app_images.dart';
import 'package:serasa_challenge/core/extensions/navigator_extensions.dart';
import 'package:serasa_challenge/core/widgets/no_image_placeholder.dart';
import 'package:serasa_challenge/core/widgets/shimmer_loading.dart';

class MovieDetailsLoadingView extends StatelessWidget {
  final String? movieTitle;

  const MovieDetailsLoadingView({super.key, this.movieTitle});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 400,
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
              child: ShimmerLoading(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.withValues(alpha: 0.3),
                  ),
                  child: const NoImagePlaceholder(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (movieTitle != null && movieTitle!.isNotEmpty) ...[
                  Text(
                    movieTitle!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Carregando detalhes...',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ] else ...[
                  ShimmerLoading(
                    child: const SkeletonBox(
                      height: 28,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Carregando...',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                ShimmerLoading(child: const SkeletonBox(height: 16, width: 80)),
                const SizedBox(height: 24),
                ShimmerLoading(
                  child: const SkeletonBox(height: 20, width: 120),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Sinopse',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ShimmerLoading(
                      child: SkeletonBox(
                        height: 16,
                        width: index == 3 ? 200 : double.infinity,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Informações',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        ShimmerLoading(
                          child: const SkeletonBox(height: 16, width: 80),
                        ),
                        const SizedBox(width: 16),
                        ShimmerLoading(
                          child: const SkeletonBox(height: 16, width: 150),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
