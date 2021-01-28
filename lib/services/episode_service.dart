import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/episode.dart';
import '../utils/fs_path.dart';

class EpisodeService {
  final _ref = FirebaseFirestore.instance.collection(FsPath.episodesCollection);

  Future<List<Episode>> getSeriesEpisodes(String seriesId) async {
    final query = await _ref
        .orderBy(Episode.noField)
        .where(Episode.seriesIdField, isEqualTo: seriesId)
        .get();
    return query.docs.map((doc) => Episode.fromDocSnapshot(doc)).toList();
  }
}
