import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  Movie({
    this.id,
    this.title,
    this.imageUrl,
    this.genreId,
    this.genreName,
    this.key,
    this.viewCount,
  });

  final String id;
  final String title;
  final String imageUrl;
  final String genreId;
  final String genreName;
  final String key;
  final int viewCount;

  static const String titleField = 'title';
  static const String imageUrlField = 'imageUrl';
  static const String genreIdField = 'genreId';
  static const String genreNameField = 'genreName';
  static const String keyField = 'key';
  static const String viewCountField = 'viewCount';
  static const String createdField = 'created';

  factory Movie.fromDocSnapshot(QueryDocumentSnapshot docSnapshot) {
    final data = docSnapshot.data();
    return Movie(
      id: docSnapshot?.id,
      title: data[titleField],
      imageUrl: data[imageUrlField],
      genreId: data[genreIdField],
      genreName: data[genreNameField],
      key: data[keyField],
      viewCount: data[viewCountField] ?? 0,
    );
  }
}
