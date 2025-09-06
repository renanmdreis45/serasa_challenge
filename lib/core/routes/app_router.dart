import 'package:flutter/material.dart';
import 'package:serasa_challenge/core/widgets/page_transitions.dart';
import 'package:serasa_challenge/modules/home/factories/home_page_factory.dart';
import 'package:serasa_challenge/modules/movie_details/factories/movie_details_factory.dart';

import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
      case AppRoutes.movieSearch:
      case AppRoutes.recentMovies:
        return PageTransitions.fadeTransition(
          makeHomePage(routeName: settings.name),
          settings: settings,
        );

      case AppRoutes.movieDetails:
        final movieId = settings.arguments as String?;
        return PageTransitions.slideUpTransition(
          makeMovieDetailsPage(movieId ?? ''),
          settings: settings,
        );

      default:
        return _errorRoute(settings);
    }
  }

  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Página não encontrada',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'A página que você está procurando não existe.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      settings: settings,
    );
  }
}
