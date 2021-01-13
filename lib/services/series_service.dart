import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/series.dart';
import '../utils/fs_path.dart';

class SeriesService {
  final _ref = FirebaseFirestore.instance.collection(FsPath.seriesCollection);

  Stream<List<Series>> streamSeriesList() {
    return _ref.orderBy(Series.createdField, descending: true).snapshots().map(
        (query) =>
            query.docs.map((doc) => Series.fromDocSnapshot(doc)).toList());
  }
}
