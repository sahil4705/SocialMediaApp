import 'package:connect_z/common/post_container.dart';
import 'package:connect_z/constants/constants.dart';
import 'package:connect_z/models/tweet_model.dart';
import 'package:connect_z/models/user_model.dart';
import 'package:connect_z/pages/chatspot_screen.dart';
import 'package:connect_z/services/chat_service.dart';
import 'package:connect_z/services/db_service.dart';
import 'package:connect_z/services/messagebox.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String currentUserId;
  const HomePage({super.key, required this.currentUserId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _followingPosts = [];
  bool _loading = false;

  buildTweet(TweetModel tweet, UserModel author) {
    return PostContainer(
        tweet: tweet, author: author, currentUserId: widget.currentUserId);
  }

  showFollowingTweets(String currentUserId) {
    List<Widget> followingPostsList = [];
    for (TweetModel tweet in _followingPosts) {
      followingPostsList.add(FutureBuilder(
          future: usersRef.doc(tweet.authorID).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              UserModel author = UserModel.fromDoc(snapshot.data);
              return buildTweet(tweet, author);
            } else {
              return const SizedBox.shrink();
            }
          }));
    }
    return followingPostsList;
  }

  setupFollowingPosts() async {
    setState(() {
      _loading = true;
    });

    List followingPosts = await DBService.getHomeTweets(widget.currentUserId);

    if (mounted) {
      setState(() {
        _followingPosts = followingPosts;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupFollowingPosts();
    ChatService.getChatList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: appDefaultSystemOverlayStyle,
        backgroundColor: appcolor,
        leading: GestureDetector(
          onTap: () {
            messageAlert(context, "Connect Z - Social Media App");
          },
          child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Image.asset(
                "assets/images/ConnectZ_Icon.png",
                width: double.maxFinite,
                height: double.maxFinite,
              )),
        ),
        title: const Text(
          '\tConnect Z',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChatSpot()));
                },
                icon: const Icon(Icons.chat)),
          )
        ],
      ),
      body: RefreshIndicator(
          child: ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              _loading
                  ? const LinearProgressIndicator()
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 5,
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: _followingPosts.isEmpty && _loading == false
                        ? const [
                            SizedBox(
                              height: 5,
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    'There is no new posts here.',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: appDefaultColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                          ]
                        : showFollowingTweets(widget.currentUserId),
                  )
                ],
              )
            ],
          ),
          onRefresh: () => setupFollowingPosts()),
    );
  }
}
