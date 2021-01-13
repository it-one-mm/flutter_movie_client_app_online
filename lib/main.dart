import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/movie_service.dart';
import 'services/series_service.dart';
import 'config/service_locator.dart';
import 'config/my_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(
          value: getIt<MovieService>().streamMoviesList(),
          lazy: false,
        ),
        StreamProvider.value(
          value: getIt<SeriesService>().streamSeriesList(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: MyRouter.LOADING_SCREEN,
        onGenerateRoute: MyRouter.onGenerateRoute,
      ),
    );
  }
}
