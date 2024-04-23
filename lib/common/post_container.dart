import 'package:connect_z/constants/constants.dart';
import 'package:connect_z/models/tweet_model.dart';
import 'package:connect_z/models/user_model.dart';
import 'package:connect_z/pages/User_Pages/profile_page.dart';
import 'package:connect_z/pages/comments.dart';
import 'package:connect_z/pages/edit_post.dart';
import 'package:connect_z/services/db_service.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostContainer extends StatefulWidget {
  final TweetModel tweet;
  final UserModel author;
  final String? currentUserId;
  const PostContainer(
      {super.key,
      required this.tweet,
      required this.author,
      required this.currentUserId});

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  int _likes = 0;
  bool liked = false;
  int _comment = 0;

  getTweetLikes() async {
    bool isLiked =
        await DBService.likeStatus(widget.currentUserId!, widget.tweet);
    if (mounted) {
      setState(() {
        liked = isLiked;
      });
    }
  }

  void getCommentCount() async {
    final document = await commentsRef
        .doc(widget.tweet.id)
        .collection("post_comments")
        .get();

    if (mounted) {
      setState(() {
        _comment = document.docs.length;
      });
    }
  }

  likeIt() async {
    if (liked) {
      DBService.unlikeTweet(widget.currentUserId!, widget.tweet);
      setState(() {
        liked = false;
        _likes = _likes - 1;
      });
    } else {
      await DBService.likeTweet(widget.currentUserId!, widget.tweet);
      setState(() {
        liked = true;
        _likes = _likes + 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _likes = widget.tweet.likes!;
    getTweetLikes();
    getCommentCount();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            currentUserID: widget.currentUserId,
                            visitedUserID: widget.tweet.authorID,
                          )));
            },
            contentPadding: const EdgeInsets.all(0),
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: widget.author.profilePicture!.isEmpty
                  ? const NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/myfirebase-db-75c27.appspot.com/o/default_photos%2Fprofile_photo.png?alt=media&token=386e8f3a-b5c4-4f82-80b7-6eb04cdd42be&_gl=1*rvl4l7*_ga*MTk3Mzk1MjgyLjE2OTY5NDgwMTQ.*_ga_CW55HF8NVT*MTY5NzI3MDQwMi41LjEuMTY5NzI3MTA0MC4zMC4wLjA.')
                  : NetworkImage(widget.author.profilePicture!),
            ),
            title: Text(
              widget.author.name!,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: widget.currentUserId == widget.author.id
                ? IconButton(
                    onPressed: () {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                content: GestureDetector(
                                  child: SizedBox(
                                    height: 55,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => EditPost(
                                                      currentUserId:
                                                          widget.currentUserId!,
                                                      post: widget.tweet,
                                                    )));
                                      },
                                      leading: const Icon(
                                        Icons.edit,
                                        color: appDefaultColor,
                                      ),
                                      title: const Row(
                                        children: [
                                          Text(
                                            'Edit/Delete Post',
                                            style: TextStyle(
                                                color: appDefaultColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                    },
                    icon: const Icon(Icons.more_vert),
                    color: appDefaultColor,
                    iconSize: 20,
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(
            height: 15,
          ),
          ReadMoreText(
            widget.tweet.text!,
            trimLines: 4,
            colorClickableText: appDefaultColor,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Show more',
            trimExpandedText: 'Show less',
            style: const TextStyle(fontSize: 15),
          ),
          widget.tweet.image!.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () async {
                        showImageViewer(
                            context, Image.network(widget.tweet.image!).image);
                      },
                      child: Container(
                        height: 250,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(widget.tweet.image!))),
                      ),
                    ),
                  ],
                ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: liked
                              ? const Icon(Icons.favorite)
                              : const Icon(Icons.favorite_border),
                          color: liked ? appDefaultColor : appDefaultColor,
                          onPressed: likeIt),
                      Text('$_likes\t\tLikes')
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          icon: const Icon(Icons.comment),
                          color: appDefaultColor,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Comments(
                                          PostID: widget.tweet.id.toString(),
                                          CommenterID:
                                              widget.currentUserId.toString(),
                                        )));
                          }),
                      Text('$_comment\tComments'),
                      const SizedBox(
                        width: 25,
                      ),
                      Text(
                        timeago.format(widget.tweet.timestamp!.toDate()),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          const Divider()
        ],
      ),
    );
  }
}
