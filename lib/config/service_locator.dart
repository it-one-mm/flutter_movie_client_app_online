import 'package:get_it/get_it.dart';
import '../services/genre_service.dart';
import '../services/movie_service.dart';
import '../services/series_service.dart';

final getIt = GetIt.I;

void setup() {
  getIt.registerLazySingleton<GenreService>(() => GenreService());
  getIt.registerLazySingleton<MovieService>(() => MovieService());
  getIt.registerLazySingleton<SeriesService>(() => SeriesService());
}
