import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:movie_client_app/ad_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/genre_service.dart';
import 'services/movie_service.dart';
import 'services/series_service.dart';
import 'config/service_locator.dart';
import 'config/my_router.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AdHelper.logger.i("Handling a background message: ${message?.notification}");
  AdHelper.logger.i("Handling a background message: ${message?.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FlutterDownloader.initialize();
  setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(
          value: getIt<GenreService>().streamGenres(),
          lazy: false,
        ),
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
          accentColor: Colors.redAccent,
        ),
        initialRoute: MyRouter.LOADING_SCREEN,
        onGenerateRoute: MyRouter.onGenerateRoute,
      ),
    );
  }
}
