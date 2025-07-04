import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'authentication_page.dart';
import 'firebase_options.dart';
import 'home_view.dart';

late FirebaseApp app;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MaterialApp(
    home: Scaffold(
      body: AuthenticationPage(),
    ),
  ));
}

// Create keys for `root` & `section` navigator avoiding unnecessary rebuilds
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _sectionNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: <RouteBase>[
    GoRoute(
      path: '/splash',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const Splash(),
    ),
    ShellRoute(
      navigatorKey: _sectionNavigatorKey,
      builder: (context, state, navigationShell) {
        // Return the widget that implements the custom shell (e.g a BottomNavigationBar).
        // The [StatefulNavigationShell] is passed to be able to navigate to other branches in a stateful way.
        return MainView(navigationShell);
      },
      routes: [
        // The route branch for the 1 Tab
        GoRoute(
          parentNavigatorKey: _sectionNavigatorKey,
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),

        // The route branch for 2º Tab
        GoRoute(
          parentNavigatorKey: _sectionNavigatorKey,
          path: '/shop',
          builder: (context, state) => const ShopPage(),
          routes: <RouteBase>[
            GoRoute(
              parentNavigatorKey: _sectionNavigatorKey,
              path: 'shopDetail/:id/:key',
              builder: (context, state) => const ShopDetailPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // Person person = Person(firstName: 'firstName', lastName: 'lastName', age: 19);
    // Person.fromJson({});

    return MaterialApp.router(
      routerConfig: router,
      title: 'Go Router Practice',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // builder: (context, child) {
      //   return Center(
      //     child: ColoredBox(
      //       color: Colors.red,
      //       child: child ?? const SizedBox(
      //         width: 200,
      //         height: 200,
      //       ),
      //     ),
      //   );
      // },
    );
  }
}

class MainView extends StatefulWidget {
  const MainView(this.navigationShell, {super.key});

  /// The navigation shell and container for the branch Navigators.
  final Widget navigationShell;

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
        // currentIndex: navigationShell.currentIndex,
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
    debugPrint('index: $index');
    (index == 0) ? context.go('/home') : context.go('/shop');
    // _pageViewController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.linear);

    // navigationShell.goBranch(
    //   index,
    //   // A common pattern when using bottom navigation bars is to support
    //   // navigating to the initial location when tapping the item that is
    //   // already active. This example demonstrates how to support this behavior,
    //   // using the initialLocation parameter of goBranch.
    //   initialLocation: index == navigationShell.currentIndex,
    // );
  }
}

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          context.go('/home');
        },
        child: Text('NEXT'),
      ),
    );
  }
}

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          context.go('/shop/shopDetail/10/gh6fft6c');
        },
        child: Text('SHOP'),
      ),
    );
  }
}

class ShopDetailPage extends StatelessWidget {
  const ShopDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          context.pop();
        },
        child: Text('SHOP DETAIL'),
      ),
    );
  }
}
