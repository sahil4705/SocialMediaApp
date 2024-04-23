import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_z/constants/constants.dart';
import 'package:connect_z/main.dart';
import 'package:connect_z/models/user_model.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  static Future<void> sendMessage(String receiverid, String message) async {
    //get current user info
    String currentUserID = userID;
    Timestamp timestamp = Timestamp.now();

    //construct chat room id from current user id and receiver id (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverid];

    ids.sort();

    String chatroomid = ids.join("_");

    await firestore.collection("chatspots").doc(chatroomid).set({
      'user1': currentUserID,
      'user2': receiverid,
    });

    //add new message to database
    await firestore
        .collection("chatspots")
        .doc(chatroomid)
        .collection('messages')
        .add({
      'senderid': currentUserID,
      'receiverid': receiverid,
      'message': message,
      'timestamp': timestamp
    });
  }

  static Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];

    ids.sort();

    String chatroomid = ids.join("_");

    return firestore
        .collection("chatspots")
        .doc(chatroomid)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  static Future<List<UserModel>> getChatList() async {
    QuerySnapshot snapshot = await firestore.collection('chatspots').get();

    String otheruserId = "";

    List<UserModel> usersList = [];

    for (var element in snapshot.docs) {
      if (element.id.contains(userID)) {
        otheruserId = element.id.replaceAll(userID, "");
        otheruserId = otheruserId.replaceAll("_", "");
        DocumentSnapshot doc = await usersRef.doc(otheruserId).get();
        usersList.add(UserModel.fromDoc(doc));
      }
    }

    return usersList;
  }
}
