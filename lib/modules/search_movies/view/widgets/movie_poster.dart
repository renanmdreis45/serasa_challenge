import 'package:flutter/material.dart';
import 'package:serasa_challenge/core/widgets/no_image_placeholder.dart';
import 'package:serasa_challenge/domain/entities/movie.dart';

class MoviePoster extends StatelessWidget {
  const MoviePoster({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: movie.poster.isNotEmpty && movie.poster != 'N/A'
            ? Image.network(
                movie.poster,
                fit: BoxFit.cover,
                width: 60,
                height: 80,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return NoImagePlaceholder(
                    width: 60,
                    height: 80,
                    iconSize: 24,
                    borderRadius: BorderRadius.circular(8),
                  );
                },
              )
            : NoImagePlaceholder(
                width: 60,
                height: 80,
                iconSize: 24,
                borderRadius: BorderRadius.circular(8),
              ),
      ),
    );
  }
}
