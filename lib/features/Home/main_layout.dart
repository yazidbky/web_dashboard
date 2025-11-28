import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/features/Home/side_bar.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late String _currentRoute;

  @override
  void initState() {
    super.initState();
    _currentRoute = widget.currentRoute;
  }

  void _onRouteChanged(String route) {
    if (_currentRoute != route) {
      Navigator.pushReplacementNamed(
        context,
        route,
        arguments: null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    if (SizeConfig.isMobile) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        drawer: SideBar(
          currentRoute: _currentRoute,
          onRouteChanged: _onRouteChanged,
        ),
        body: SafeArea(
          child: widget.child,
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Row(
            children: [
              SideBar(
                currentRoute: _currentRoute,
                onRouteChanged: _onRouteChanged,
              ),
              Expanded(
                child: widget.child,
              ),
            ],
          ),
        ),
      );
    }
  }
}

