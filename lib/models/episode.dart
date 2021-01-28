import 'package:cloud_firestore/cloud_firestore.dart';

class Episode {
  Episode({
    this.id,
    this.seriesId,
    this.seriesTitle,
    this.key,
    this.no,
  });

  final String id;
  final String seriesId;
  final String seriesTitle;
  final String key;
  final String no;

  static const String noField = 'no';
  static const String keyField = 'key';
  static const String seriesIdField = 'seriesId';
  static const String seriesTitleField = 'seriesTitle';

  factory Episode.fromDocSnapshot(QueryDocumentSnapshot doc) {
    final data = doc.data();

    return Episode(
      id: doc.id,
      no: data[noField],
      seriesId: data[seriesIdField],
      seriesTitle: data[seriesTitleField],
      key: data[keyField],
    );
  }
}
