import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String senderid;
  final String receiverId;
  final String message;
  final Timestamp timeStamp;

  ChatModel({
    required this.senderid,
    required this.receiverId,
    required this.message,
    required this.timeStamp,
  });
}
