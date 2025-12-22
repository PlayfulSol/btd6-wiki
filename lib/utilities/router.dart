import 'package:go_router/go_router.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '/presentation/screens/tower/single_tower.dart';
import '/presentation/screens/hero/single_hero.dart';
import '/presentation/screens/bloon/single_bloon.dart';
import '/presentation/screens/bloon/boss_bloon.dart';
import '/presentation/screens/bloon/minion_bloon.dart';
import '/presentation/screens/maps/single_map.dart';
import '/presentation/screens/misc/favorite_screen.dart';
import '/main.dart';
import '/analytics/analytics.dart';
import '/utilities/constants.dart';

class AppRouter {
  final FirebaseAnalytics analytics;
  final Map<String, dynamic> baseEntities;

  AppRouter({
    required this.analytics,
    required this.baseEntities,
  });

  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final location = state.uri.path;
      if (location == '/' || location.isEmpty) {
        return '/towers';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/towers',
        builder: (context, state) => MyHomePage(
          analytics: analytics,
          baseEntities: baseEntities,
          initialPageIndex: kTowersIndex,
        ),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return SingleTower(
                towerId: id,
                analyticsHelper: AnalyticsHelper(analytics),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/heroes',
        builder: (context, state) => MyHomePage(
          analytics: analytics,
          baseEntities: baseEntities,
          initialPageIndex: kHeroesIndex,
        ),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return SingleHero(
                heroId: id,
                analyticsHelper: AnalyticsHelper(analytics),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/bloons',
        builder: (context, state) => MyHomePage(
          analytics: analytics,
          baseEntities: baseEntities,
          initialPageIndex: kBloonsIndex,
        ),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return SingleBloon(
                bloonId: id,
                analyticsHelper: AnalyticsHelper(analytics),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/bosses/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BossBloon(
            bossId: id,
            analyticsHelper: AnalyticsHelper(analytics),
          );
        },
      ),
      GoRoute(
        path: '/maps',
        builder: (context, state) => MyHomePage(
          analytics: analytics,
          baseEntities: baseEntities,
          initialPageIndex: kMapsIndex,
        ),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return SingleMap(
                mapId: id,
                analyticsHelper: AnalyticsHelper(analytics),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => FavoriteScreen(
          analyticsHelper: AnalyticsHelper(analytics),
        ),
      ),
      GoRoute(
        path: '/minions/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MinionBloonPage(
            minionId: id,
            analyticsHelper: AnalyticsHelper(analytics),
          );
        },
      ),
    ],
  );
}

