import 'package:flutter/material.dart';
import '../models/genre.dart';
import '../screens/genre_screen.dart';
import '../screens/search_screen.dart';
import '../screens/home_screen.dart';
import '../screens/movies_screen.dart';
import '../screens/series_screen.dart';
import '../screens/loading_screen.dart';

class MyRouter {
  static const String LOADING_SCREEN = 'loading_screen';
  static const String HOME_SCREEN = 'home_screen';
  static const String MOVIES_SCREEN = 'movies_screen';
  static const String SERIES_SCREEN = 'series_screen';
  static const String GENRE_SCREEN = 'genre_screen';
  static const String SEARCH_SCREEN = 'search_screen';

  static RouteSettings _settings;

  static PageRouteBuilder<dynamic> _buildRoute(Widget widget) {
    return PageRouteBuilder(
      settings: _settings,
      pageBuilder: (context, _, __) => widget,
    );
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    _settings = settings;
    switch (settings.name) {
      case LOADING_SCREEN:
        return _buildRoute(LoadingScreen());
      case HOME_SCREEN:
        return _buildRoute(HomeScreen());
      case MOVIES_SCREEN:
        return _buildRoute(MoviesScreen());
      case SERIES_SCREEN:
        return _buildRoute(SeriesScreen());
      case SEARCH_SCREEN:
        return _buildRoute(SearchScreen());
      case GENRE_SCREEN:
        final Genre genre = _settings?.arguments;
        return _buildRoute(GenreScreen(genre: genre));
    }

    return _buildRoute(
      Scaffold(
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      ),
    );
  }
}
