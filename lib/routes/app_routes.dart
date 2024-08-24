import 'package:go_router/go_router.dart';
import 'package:kiruhuku_choice/screens/choice_screen.dart';
import 'package:kiruhuku_choice/screens/clothes_list_screen.dart';
import 'package:kiruhuku_choice/screens/history_screen.dart';
import 'package:kiruhuku_choice/screens/home_screen.dart';
import 'package:kiruhuku_choice/screens/register_clothes_screen.dart';
import 'package:kiruhuku_choice/screens/testpage.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/choice',
      builder: (context, state) {
        final Map<String, dynamic>? extra = state.extra as Map<String, dynamic>?; // null 安全のため修正
        final city = extra?['city'] ?? 'Unknown City'; // デフォルト値を指定
        final season = extra?['season'] ?? 'Unknown Season'; // デフォルト値を指定
        return ChoiceScreen(city: city, season: season);
      },
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/registerClothes',
      builder: (context, state) => const RegisterClothesScreen(),
    ),
    GoRoute(
      path: '/clothesList',
      builder: (context, state) => const ClothesListScreen(),
    ),
    GoRoute(
      path: '/testpage',
      builder: (context, state) => const Testpage(),
    ),
  ],
);
