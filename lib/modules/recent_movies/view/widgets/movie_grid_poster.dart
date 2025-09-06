import 'package:flutter/material.dart';
import 'package:serasa_challenge/core/widgets/no_image_placeholder.dart';
import 'package:serasa_challenge/domain/entities/movie.dart';

class MovieGridPoster extends StatelessWidget {
  final Movie movie;

  const MovieGridPoster({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: movie.poster.isNotEmpty && movie.poster != 'N/A'
            ? Image.network(
                movie.poster,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
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
                    width: double.infinity,
                    height: double.infinity,
                    iconSize: 48,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  );
                },
              )
            : NoImagePlaceholder(
                width: double.infinity,
                height: double.infinity,
                iconSize: 48,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
      ),
    );
  }
}
