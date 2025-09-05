import 'package:flutter/material.dart';
import 'package:serasa_challenge/core/routes/app_router.dart';
import 'package:serasa_challenge/core/routes/app_routes.dart';
import 'package:serasa_challenge/modules/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: const HomePage(),
    );
  }
}
