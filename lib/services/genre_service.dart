import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/genre.dart';
import '../utils/fs_path.dart';

class GenreService {
  final _ref = FirebaseFirestore.instance.collection(FsPath.genresCollection);

  Stream<List<Genre>> streamGenres() {
    return _ref.orderBy(Genre.nameField).snapshots().map((query) =>
        query.docs.map((doc) => Genre.fromDocSnapshot(doc)).toList());
  }
}
