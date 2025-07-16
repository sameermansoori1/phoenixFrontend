import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phoenix_app/core/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  final Widget child;

  const HomeScreen({
    super.key,
    required this.child,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    final location = GoRouterState.of(context).uri.toString();

    int newIndex = 0;
    if (location.startsWith('/shipments')) {
      newIndex = 1;
    } else if (location.startsWith('/profile')) {
      newIndex = 2;
    }

    // Only update if the index actually changed
    if (_selectedIndex != newIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedIndex = newIndex;
          });
        }
      });
    }
  }

  void _onItemTapped(int index) {
    // Prevent unnecessary navigation if already on the same tab
    if (_selectedIndex == index) return;

    // Navigate without setState to avoid double rebuilds
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/shipments');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: widget.child,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.surface,
        height: 85,
        child: Row(
          children: [
            Expanded(
                child: _buildNavItem(
                    "assets/icons/dashboard.png", 'Dashboard', 0)),
            Expanded(
                child: _buildNavItem("assets/icons/box.png", 'Shipments', 1)),
            Expanded(
                child: _buildNavItem("assets/icons/user.png", 'Profile', 2)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String image, String label, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () => _onItemTapped(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Image.asset(
                image,
                height: 20,
                width: 28,
                color: isSelected ? AppColors.blue : AppColors.disabled,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.blue : AppColors.disabled,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
