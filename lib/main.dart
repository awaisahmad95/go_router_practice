import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router_practice/screens/change_password.dart';
import 'package:go_router_practice/screens/main_view.dart';
import 'package:go_router_practice/screens/profile.dart';
import 'package:go_router_practice/screens/settings.dart';
import 'package:go_router_practice/screens/shop.dart';
import 'package:go_router_practice/screens/shop_detail.dart';
import 'package:go_router_practice/screens/splash.dart';
import 'firebase_options.dart';
import 'screens/home.dart';
import 'use_path_url_strategy.dart' if (dart.library.html) 'package:flutter_web_plugins/url_strategy.dart';

late FirebaseApp app;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  GoRouter.optionURLReflectsImperativeAPIs = true;

  await dotenv.load();

  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // runApp(const MaterialApp(
  //   home: Scaffold(
  //     body: AuthenticationPage(),
  //   ),
  // ));

  runApp(
    MaterialApp.router(
      routerConfig: router2,
      title: 'Go Router Practice',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    ),
  );
}

// Create keys for `root` & `section` navigator avoiding unnecessary rebuilds
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKeyTab1 = GlobalKey<NavigatorState>();
final _shellNavigatorKeyTab2 = GlobalKey<NavigatorState>();

// final router1 = GoRouter(
//   navigatorKey: _rootNavigatorKey,
//   initialLocation: '/splash',
//   routes: <RouteBase>[
//     GoRoute(
//       path: '/splash',
//       parentNavigatorKey: _rootNavigatorKey,
//       builder: (context, state) => const Splash(),
//     ),
//     ShellRoute(
//       navigatorKey: _shellNavigatorKeyTab1,
//       builder: (context, state, navigationShell) {
//         // Return the widget that implements the custom shell (e.g a BottomNavigationBar).
//         // The [StatefulNavigationShell] is passed to be able to navigate to other branches in a stateful way.
//         return MainView(navigationShell);
//       },
//       routes: [
//         // The route branch for the 1 Tab
//         GoRoute(
//           parentNavigatorKey: _shellNavigatorKeyTab1,
//           path: '/home',
//           builder: (context, state) => const HomePage(),
//         ),
//
//         // The route branch for 2º Tab
//         GoRoute(
//           parentNavigatorKey: _shellNavigatorKeyTab1,
//           path: '/shop',
//           builder: (context, state) => const ShopPage(),
//           routes: <RouteBase>[
//             GoRoute(
//               parentNavigatorKey: _shellNavigatorKeyTab1,
//               path: 'shopDetail/:id/:key',
//               builder: (context, state) => const ShopDetailPage(),
//             ),
//           ],
//         ),
//       ],
//     ),
//   ],
// );

final router2 = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: <RouteBase>[
    GoRoute(
      path: '/splash',
      name: 'splash',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const Splash(),
    ),
    StatefulShellRoute.indexedStack(
      // parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state, navigationShell) {
        // Return the widget that implements the custom shell (e.g a BottomNavigationBar).
        // The [StatefulNavigationShell] is passed to be able to navigate to other branches in a stateful way.
        return MainView(navigationShell);
      },
      branches: [
        // The route branch for the 1 Tab
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKeyTab1,
          routes: [
            GoRoute(
              // parentNavigatorKey: _shellNavigatorKeyTab1,
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomePage(),
              routes: [
                GoRoute(
                  // parentNavigatorKey: _shellNavigatorKeyTab1,
                  path: '/profile',
                  name: 'profile',
                  builder: (context, state) => const ProfilePage(),
                  routes: [
                    GoRoute(
                      // parentNavigatorKey: _shellNavigatorKeyTab1,
                      path: '/changePassword',
                      name: 'changePassword',
                      builder: (context, state) => const ChangePasswordPage(),
                    ),
                  ],
                ),
                GoRoute(
                  // parentNavigatorKey: _shellNavigatorKeyTab1,
                  path: '/settings',
                  name: 'settings',
                  builder: (context, state) => const SettingsPage(),
                ),
              ],
            ),
          ],
        ),

        // The route branch for 2º Tab
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKeyTab2,
          routes: <RouteBase>[
            GoRoute(
              // parentNavigatorKey: _shellNavigatorKeyTab2,
              path: '/shop',
              name: 'shop',
              builder: (context, state) => const ShopPage(),
              routes: <RouteBase>[
                GoRoute(
                  // parentNavigatorKey: _rootNavigatorKey,
                  path: 'shopDetail/:id/:key',
                  name: 'shopDetail',
                  builder: (context, state) => const ShopDetailPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
