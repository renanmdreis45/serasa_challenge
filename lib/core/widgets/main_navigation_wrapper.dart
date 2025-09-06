import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:serasa_challenge/core/constants/app_images.dart';
import 'package:serasa_challenge/core/routes/app_routes.dart';
import 'package:serasa_challenge/modules/recent_movies/view/recent_movies_view.dart';
import 'package:serasa_challenge/modules/search_movies/view/search_movies_view.dart';

class MainNavigationWrapper extends StatefulWidget {
  final String? initialRoute;

  const MainNavigationWrapper({super.key, this.initialRoute});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;
  int _previousIndex = 0;

  final List<Widget> _pages = [
    const SearchMoviesView(),
    const RecentMoviesView(),
  ];

  @override
  void initState() {
    super.initState();

    if (widget.initialRoute == AppRoutes.recentMovies) {
      _selectedIndex = 1;
      _previousIndex = 1;
    } else {
      _selectedIndex = 0;
      _previousIndex = 0;
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Buscar Filmes' : 'Filmes Recentes'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOutCubic,
        switchOutCurve: Curves.easeInOutCubic,
        transitionBuilder: (Widget child, Animation<double> animation) {
          final isMovingRight = _selectedIndex > _previousIndex;

          final slideAnimation =
              Tween<Offset>(
                begin: isMovingRight
                    ? const Offset(0.3, 0.0)
                    : const Offset(-0.3, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );

          final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          );

          return SlideTransition(
            position: slideAnimation,
            child: FadeTransition(opacity: fadeAnimation, child: child),
          );
        },
        child: Container(
          key: ValueKey<int>(_selectedIndex),
          child: _pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(_selectedIndex == 0 ? 8 : 6),
                decoration: BoxDecoration(
                  color: _selectedIndex == 0
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  AppImages.searchIcon,
                  width: _selectedIndex == 0 ? 26 : 24,
                  height: _selectedIndex == 0 ? 26 : 24,
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 0
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              label: 'Buscar',
            ),
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(_selectedIndex == 1 ? 8 : 6),
                decoration: BoxDecoration(
                  color: _selectedIndex == 1
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  AppImages.historyIcon,
                  width: _selectedIndex == 1 ? 26 : 24,
                  height: _selectedIndex == 1 ? 26 : 24,
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 1
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              label: 'Recentes',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
