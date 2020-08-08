import 'package:dart_notes_backend/dart_notes_backend.dart';

import 'user.dart';

class Note extends ManagedObject<_Note> implements _Note {
  @override
  void willUpdate() {
    updatedAt = DateTime.now().toUtc();
  }

  @override
  void willInsert() {
    createdAt = DateTime.now().toUtc();
    updatedAt = DateTime.now().toUtc();
  }
}

@Table(name: "notes")
class _Note {
  @primaryKey
  int id;

  String title;
  String content;

  @Column(indexed: true)
  DateTime createdAt;

  @Column(indexed: true)
  DateTime updatedAt;

  @Relate(#notes, onDelete: DeleteRule.cascade, isRequired: true)
  User owner;
}
