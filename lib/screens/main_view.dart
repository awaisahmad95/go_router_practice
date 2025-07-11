import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainView extends StatefulWidget {
  const MainView(this.navigationShell, {super.key});

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  // final _pageViewController = PageController();

  // int _activePage = 0;

  @override
  Widget build(BuildContext context) {
    // print(navigationShell.currentIndex);
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.navigationShell.currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Shop'),
        ],
        onTap: (index) {
          _onTap(index, context);
        },
      ),
    );
  }

  void _onTap(int index, BuildContext context) {
    // debugPrint('index: $index');
    // (index == 0) ? context.go('/home') : context.go('/shop');
    // _pageViewController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.linear);

    widget.navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}