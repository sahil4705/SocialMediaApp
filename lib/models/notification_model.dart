import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String id;
  String fromUserID;
  Timestamp timestamp;
  bool follow;

  NotificationModel(
      {required this.id,
      required this.fromUserID,
      required this.timestamp,
      required this.follow});

  factory NotificationModel.fromDoc(DocumentSnapshot snapshot) {
    return NotificationModel(
      id: snapshot.id,
      fromUserID: snapshot['fromUserID'],
      timestamp: snapshot['timestamp'],
      follow: snapshot['follow'],
    );
  }
}
