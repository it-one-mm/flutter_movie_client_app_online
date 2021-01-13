import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';
import '../utils/fs_path.dart';

class MovieService {
  final _ref = FirebaseFirestore.instance.collection(FsPath.moviesCollection);

  Stream<List<Movie>> streamMoviesList() {
    return _ref
        .orderBy(Movie.createdField, descending: true)
        .snapshots()
        .map((sn) => sn.docs.map((doc) => Movie.fromDocSnapshot(doc)).toList());
  }
}
