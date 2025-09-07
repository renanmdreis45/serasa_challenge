import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:serasa_challenge/core/constants/app_breakpoints.dart';
import 'package:serasa_challenge/core/constants/app_images.dart';
import 'package:serasa_challenge/core/widgets/responsive_builder.dart';
import 'package:serasa_challenge/domain/entities/movie.dart';
import 'package:serasa_challenge/modules/search_movies/view/widgets/movie_poster.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;

  const MovieCard({super.key, required this.movie, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, constraints) {
        final isMobile = AppBreakpoints.isMobile(constraints.maxWidth);
        final padding = isMobile ? 12.0 : 16.0;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(padding),
            leading: MoviePoster(movie: movie),
            title: Text(
              movie.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${movie.year}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ),
            trailing: SvgPicture.asset(
              AppImages.arrowRightIcon,
              width: isMobile ? 20 : 25,
              height: isMobile ? 20 : 25,
              colorFilter: ColorFilter.mode(
                Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            onTap: onTap,
          ),
        );
      },
    );
  }
}
