import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:serasa_challenge/core/constants/app_images.dart';
import 'package:serasa_challenge/core/extensions/navigator_extensions.dart';
import 'package:serasa_challenge/core/routes/app_routes.dart';
import 'package:serasa_challenge/domain/repositories/movie_repository.dart';

class HomePage extends StatefulWidget {
  final MovieRepository? repository;

  const HomePage({super.key, this.repository});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      switch (index) {
        case 0:
          context.pushReplacementNamed(AppRoutes.movieSearch);
          break;
        case 1:
          context.pushReplacementNamed(AppRoutes.recentMovies);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'Selecione uma opção abaixo',
          style: TextStyle(fontSize: 18),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppImages.searchIcon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 0
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppImages.historyIcon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 1
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'Recentes',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
