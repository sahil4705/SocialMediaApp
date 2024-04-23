import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_z/constants/constants.dart';
import 'package:connect_z/main.dart';
import 'package:connect_z/models/user_model.dart';
import 'package:connect_z/pages/User_Pages/profile_page.dart';
import 'package:connect_z/services/messagebox.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

String postid = "";

class Comments extends StatefulWidget {
  final String PostID;
  final String CommenterID;
  const Comments({super.key, required this.PostID, required this.CommenterID});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController commentsController = TextEditingController();
  @override
  void initState() {
    super.initState();
    postid = widget.PostID;
  }

  buildComments() {
    return StreamBuilder(
        stream: commentsRef
            .doc(widget.PostID)
            .collection('post_comments')
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            List<CommentWidget> commentsList = [];

            snapshot.data.docs.forEach((doc) {
              commentsList.add(CommentWidget.fromDoc(doc));
            });

            return ListView(
              children: commentsList,
            );
          } else {
            return const Placeholder();
          }
        });
  }

  addComments() async {
    DocumentSnapshot documentSnapshot =
        await usersRef.doc(widget.CommenterID).get();

    UserModel user = UserModel.fromDoc(documentSnapshot);

    commentsRef.doc(widget.PostID).collection('post_comments').add({
      "userid": widget.CommenterID,
      "timestamp": Timestamp.now(),
      "comment": commentsController.text,
      "picture": user.profilePicture,
      "username": user.name,
    });
    commentsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appDefaultColor,
        title: const Text('Comments'),
        centerTitle: true,
      ),
      body: Column(children: <Widget>[
        Expanded(child: buildComments()),
        Container(
          margin: const EdgeInsets.only(bottom: 7),
          child: ListTile(
            title: TextFormField(
              controller: commentsController,
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                  border: OutlineInputBorder()),
            ),
            trailing: OutlinedButton(
                onPressed: () async {
                  await addComments();
                },
                child: const Text('Post')),
          ),
        ),
      ]),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final String commentId;
  final Timestamp timeStamp;
  final String comment;
  final String username;
  final String userid;
  final String profilePicture;

  const CommentWidget(
      {super.key,
      required this.commentId,
      required this.timeStamp,
      required this.comment,
      required this.username,
      required this.profilePicture,
      required this.userid});

  factory CommentWidget.fromDoc(DocumentSnapshot doc) {
    return CommentWidget(
      commentId: doc.id,
      username: doc['username'],
      timeStamp: doc['timestamp'],
      comment: doc['comment'],
      profilePicture: doc['picture'],
      userid: doc['userid'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            currentUserID: userID,
                            visitedUserID: userid,
                          )));
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(profilePicture),
            ),
          ),
          title: Text(comment),
          subtitle: Text(
            timeago.format(timeStamp.toDate()),
            style: const TextStyle(fontSize: 12),
          ),
          trailing: userid == userID
              ? IconButton(
                  onPressed: () async {
                    await messageConfirm(
                        context,
                        "Are you sure you wants to delete this comment?",
                        commentId,
                        postid);
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 20,
                  ),
                  color: appDefaultColor,
                )
              : const SizedBox.shrink(),
        ),
        const Divider()
      ],
    );
  }
}
