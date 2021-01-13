import 'package:cloud_firestore/cloud_firestore.dart';

class Series {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String genreId;
  final String genreName;
  final int viewCount;

  Series({
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.genreId,
    this.genreName,
    this.viewCount,
  });

  static const String titleField = 'title';
  static const String imageUrlField = 'imageUrl';
  static const String descriptionField = 'description';
  static const String genreIdField = 'genreId';
  static const String genreNameField = 'genreName';
  static const String viewCountField = 'viewCount';
  static const String createdField = 'created';

  factory Series.fromDocSnapshot(QueryDocumentSnapshot docSnapshot) {
    final data = docSnapshot.data();
    return Series(
      id: docSnapshot.id,
      title: data[titleField],
      imageUrl: data[imageUrlField],
      description: data[descriptionField],
      genreId: data[genreIdField],
      genreName: data[genreNameField],
      viewCount: data[viewCountField] ?? 0,
    );
  }
}
