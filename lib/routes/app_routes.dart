import 'package:go_router/go_router.dart';
import 'package:kiruhuku_choice/screens/choice_screen.dart';
import 'package:kiruhuku_choice/screens/history_screen.dart';
import 'package:kiruhuku_choice/screens/home_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/choice',
      builder: (context, state) => const ChoiceScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
  ],
);
