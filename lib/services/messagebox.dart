import 'package:connect_z/constants/constants.dart';
import 'package:flutter/material.dart';

Future<void> messageAlert(BuildContext context, String message) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connect Z'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            )
          ],
        );
      });
}

Future<void> messageConfirm(
    BuildContext context, String message, String cid, String pid) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                commentsRef
                    .doc(pid)
                    .collection("post_comments")
                    .doc(cid)
                    .delete();
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            )
          ],
        );
      });
}

Future<void> deleteChatConfirm(
    BuildContext context, String roomid, String docID) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Are You Sure You Wants To Delete This Message?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                firestore
                    .collection("chatspots")
                    .doc(roomid)
                    .collection('messages')
                    .doc(docID)
                    .delete();
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            )
          ],
        );
      });
}
