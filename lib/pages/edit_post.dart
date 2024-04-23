import 'package:connect_z/common/custom_button.dart';
import 'package:connect_z/constants/constants.dart';
import 'package:connect_z/models/tweet_model.dart';
import 'package:connect_z/pages/feed_page.dart';
import 'package:connect_z/services/db_service.dart';
import 'package:flutter/material.dart';

class EditPost extends StatefulWidget {
  final String currentUserId;
  final TweetModel post;
  const EditPost({super.key, required this.currentUserId, required this.post});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  String? _tweetText;
  bool? _loading;

  TextEditingController postTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    postTextController.text = widget.post.text!;
    _tweetText = widget.post.text!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          systemOverlayStyle: appDefaultSystemOverlayStyle,
          backgroundColor: appDefaultColor,
          centerTitle: true,
          leading: const BackButton(
            color: Colors.white,
          ),
          title: const Text(
            'Edit Post',
            style: TextStyle(color: Colors.white, fontSize: 20),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _loading == true
                  ? Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const CircularProgressIndicator())
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: postTextController,
                maxLength: 280,
                maxLines: 7,
                decoration: const InputDecoration(
                  hintText: 'Write something here...',
                ),
                onChanged: (value) {
                  _tweetText = value;
                },
              ),
              StdButton(
                btnText: 'Save Changes',
                onBtnPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  if (_tweetText != null && _tweetText!.isNotEmpty) {
                    TweetModel tweetModel = TweetModel(
                        id: widget.post.id,
                        text: _tweetText,
                        image: widget.post.image,
                        authorID: widget.post.authorID,
                        likes: widget.post.likes,
                        retweets: widget.post.retweets,
                        timestamp: widget.post.timestamp);
                    DBService.updatePost(tweetModel);
                    setState(() {
                      _loading = false;
                    });
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FeedPage(cureentUserID: widget.currentUserId)),
                        (route) => false);
                  }
                },
              ),
              const SizedBox(
                height: 5,
              ),
              StdButton(
                btnText: 'Delete Post',
                onBtnPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  commentsRef.doc(widget.post.id).delete();
                  tweetsRef
                      .doc(widget.currentUserId)
                      .collection("userTweets")
                      .doc(widget.post.id)
                      .delete();
                  setState(() {
                    _loading = false;
                  });
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FeedPage(cureentUserID: widget.currentUserId)),
                      (route) => false);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              _loading == false
                  ? const CircularProgressIndicator()
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
