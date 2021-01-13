import 'package:get_it/get_it.dart';
import '../services/movie_service.dart';
import '../services/series_service.dart';

GetIt getIt = GetIt.I;

void setup() {
  getIt.registerLazySingleton(() => MovieService());
  getIt.registerLazySingleton(() => SeriesService());
}
