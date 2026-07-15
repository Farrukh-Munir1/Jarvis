import 'package:isar/isar.dart';

part 'conversation.g.dart';

@Collection()
class Conversation {
  Id id = Isar.autoIncrement;

  late String title;

  late DateTime createdAt;

  @Index()
  String? userId;

  late List<String> messagesJson; // Each message stored as compact JSON string

  Conversation();

  Conversation.create({required this.title, this.userId}) {
    createdAt = DateTime.now();
    messagesJson = [];
  }
}
