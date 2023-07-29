import 'package:faker_app_flutter_firebase/src/routing/go_router_refresh_stream.dart';
import 'package:faker_app_flutter_firebase/src/screens/custom_profile_screen.dart';
import 'package:faker_app_flutter_firebase/src/screens/custom_sign_in_screen.dart';
import 'package:faker_app_flutter_firebase/src/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  home,
  signIn,
  profile,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/sign-in',
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
    redirect: (context, state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;

      if (isLoggedIn) {
        if (state.location == '/sign-in') {
          return '/home';
        }
      } else {
        // /home and /home/profile are protected routes
        if (state.location.startsWith('/home')) {
          return '/sign-in';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/sign-in',
        name: AppRoute.signIn.name,
        builder: (context, state) => const CustomSignInScreen(),
      ),
      GoRoute(
        path: '/home',
        name: AppRoute.home.name,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'profile',
            name: AppRoute.profile.name,
            builder: (context, state) => const CustomProfileScreen(),
          ),
        ]
      ),
    ],
  );
});
