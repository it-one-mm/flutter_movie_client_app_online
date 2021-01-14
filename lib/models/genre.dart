import 'package:cloud_firestore/cloud_firestore.dart';

class Genre {
  Genre({
    this.id,
    this.name,
  });

  final String id;
  final String name;

  static const String nameField = 'name';

  factory Genre.fromDocSnapshot(QueryDocumentSnapshot docSnapshot) {
    final data = docSnapshot.data();
    return Genre(
      id: docSnapshot.id,
      name: data[nameField],
    );
  }
}
