import 'package:flutter/material.dart';
import 'package:serasa_challenge/core/routes/app_router.dart';
import 'package:serasa_challenge/core/routes/app_routes.dart';
import 'package:serasa_challenge/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineVault - Your Personal Movie Collection',
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
