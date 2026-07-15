import 'package:go_router/go_router.dart';

import '../presentation/pages/carousel_editor/carousel_canvas_page.dart';
import '../presentation/pages/carousel_viewer/carousel_viewer_page.dart';
import '../presentation/pages/export/export_page.dart';
import '../presentation/pages/logs/logs_page.dart';
import '../presentation/pages/paywall/paywall_page.dart';
import '../presentation/pages/profile/profile_page.dart';
import '../presentation/pages/profile_setup/profile_setup_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/profile-setup',
        name: 'profileSetup',
        builder: (context, state) => const ProfileSetupPage(),
      ),
      GoRoute(
        path: '/carousel/:id',
        name: 'carouselViewer',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CarouselViewerPage(carouselId: id);
        },
      ),
      GoRoute(
        path: '/carousel-editor/:id',
        name: 'carouselEditor',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CarouselCanvasPage(carouselId: id);
        },
      ),
      GoRoute(
        path: '/export/:id',
        name: 'export',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ExportPage(carouselId: id);
        },
      ),
      GoRoute(
        path: '/logs',
        name: 'logs',
        builder: (context, state) => const LogsPage(),
      ),
      GoRoute(
        path: '/paywall',
        name: 'paywall',
        builder: (context, state) => const PaywallPage(),
      ),
    ],
  );
}
