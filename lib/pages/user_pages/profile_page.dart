import 'package:connect_z/common/progress_circle.dart';
import 'package:connect_z/common/post_container.dart';
import 'package:connect_z/constants/constants.dart';
import 'package:connect_z/main.dart';
import 'package:connect_z/models/tweet_model.dart';
import 'package:connect_z/models/user_model.dart';
import 'package:connect_z/pages/chatroom_screen.dart';
import 'package:connect_z/pages/user_pages/connetions.dart';
import 'package:connect_z/services/auth_service.dart';
import 'package:connect_z/services/db_service.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'editprofile_page.dart';

class ProfilePage extends StatefulWidget {
  final String? currentUserID;
  final String? visitedUserID;
  const ProfilePage({super.key, this.currentUserID, this.visitedUserID});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _followersCount = 0;
  int _followingCount = 0;
  int profileSegmentedValue = 0;
  bool isFollowing = false;
  List<TweetModel> _allTweets = [];
  List<TweetModel> _mediaTweets = [];

  Map<int, Widget> profileTabs = <int, Widget>{
    0: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          'Posts',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        )),
    1: const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Media',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  };

  Widget buildProfileWidgets(UserModel author) {
    switch (profileSegmentedValue) {
      case 0:
        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _allTweets.length,
            itemBuilder: (context, index) {
              return PostContainer(
                author: author,
                tweet: _allTweets[index],
                currentUserId: widget.currentUserID,
              );
            });
      case 1:
        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _mediaTweets.length,
            itemBuilder: (context, index) {
              return PostContainer(
                  author: author,
                  tweet: _mediaTweets[index],
                  currentUserId: widget.currentUserID);
            });
      default:
        return const Center(
          child: Text(
            'Something Went Wrong!',
            style: TextStyle(fontSize: 25),
          ),
        );
    }
  }

  getFollowersCount() async {
    int followersCount =
        await DBService.getFollowersCount(widget.visitedUserID);
    if (mounted) {
      setState(() {
        _followersCount = followersCount;
      });
    }
  }

  getFollowingCount() async {
    int followingCount =
        await DBService.getFollowingCount(widget.visitedUserID);
    if (mounted) {
      setState(() {
        _followingCount = followingCount;
      });
    }
  }

  followOrUnfollow() {
    if (isFollowing) {
      unfollowUser();
    } else {
      followUser();
    }
  }

  unfollowUser() {
    DBService.unfollowUser(widget.currentUserID!, widget.visitedUserID!);
    if (mounted) {
      setState(() {
        isFollowing = false;
        _followersCount--;
      });
    }
  }

  followUser() {
    DBService.followUser(widget.currentUserID!, widget.visitedUserID!);
    setState(() {
      isFollowing = true;
      _followersCount++;
    });
  }

  setupIsFollowing() async {
    bool isFollowingThisUser = await DBService.isFollowingUser(
        widget.currentUserID!, widget.visitedUserID!);
    if (mounted) {
      setState(() {
        isFollowing = isFollowingThisUser;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFollowersCount();
    getFollowingCount();
    setupIsFollowing();
    getAllTweets();
  }

  getAllTweets() async {
    List<TweetModel> userTweets =
        await DBService.getUserTweets(widget.visitedUserID!);

    if (mounted) {
      setState(() {
        _allTweets = userTweets;
        _mediaTweets =
            _allTweets.where((element) => element.image!.isNotEmpty).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: usersRef.doc(widget.visitedUserID).get(),
        builder: ((BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: ProgressCircle(),
            );
          }
          UserModel currentUserModel = UserModel.fromDoc(snapshot.data!);

          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: appDefaultSystemOverlayStyle,
              backgroundColor: appcolor,
              title: widget.currentUserID == widget.visitedUserID
                  ? Text(
                      '\tWelcome @ ${currentUserModel.name}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                    )
                  : Text('\tUser @ ${currentUserModel.name}'),
              actions: [
                widget.currentUserID == widget.visitedUserID
                    ? Container(
                        margin: const EdgeInsets.only(right: 15, top: 2),
                        child: IconButton(
                            onPressed: () {
                              showModalBottomSheet<void>(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                        height: 150,
                                        margin: const EdgeInsets.all(20),
                                        child: ListView(
                                          children: [
                                            ListTile(
                                              onTap: () async {
                                                bool isLoggedOut =
                                                    await AuthService.signOut();
                                                if (isLoggedOut) {
                                                  //ignore: use_build_context_synchronously
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return const ConnectZ();
                                                  }));
                                                }
                                              },
                                              leading: const Icon(
                                                Icons.logout,
                                                color: appDefaultColor,
                                              ),
                                              title: const Row(
                                                children: [
                                                  Text(
                                                    'Logout',
                                                    style: TextStyle(
                                                        color: appDefaultColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ));
                                  });
                            },
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
                              size: 20,
                            )),
                      )
                    : const SizedBox.shrink()
              ],
            ),
            body: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                GestureDetector(
                  onTap: () async {
                    showImageViewer(context,
                        Image.network(currentUserModel.coverImage!).image);
                  },
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                        color: tcolor,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(currentUserModel.coverImage!))),
                    child: const SizedBox.shrink(),
                  ),
                ),
                Container(
                  transform: Matrix4.translationValues(0.0, -40, 0.0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              showImageViewer(
                                  context,
                                  Image.network(
                                          currentUserModel.profilePicture!)
                                      .image);
                            },
                            child: CircleAvatar(
                                radius: 45,
                                backgroundImage: NetworkImage(
                                    currentUserModel.profilePicture!)),
                          ),
                          widget.currentUserID == widget.visitedUserID
                              ? GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfilePage(
                                                    user: currentUserModel)));
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 35,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: const Center(
                                        child: Text(
                                      'Edit',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: followOrUnfollow,
                                  child: Container(
                                    width: 100,
                                    height: 35,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color:
                                          isFollowing ? Colors.white : tcolor,
                                      border: Border.all(color: tcolor),
                                    ),
                                    child: Center(
                                        child: Text(
                                      isFollowing ? 'Following' : 'Follow',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: isFollowing
                                              ? tcolor
                                              : Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                )
                        ],
                      ),
                      const SizedBox(height: 10),
                      ReadMoreText(
                        currentUserModel.name!,
                        trimLines: 5,
                        trimMode: TrimMode.Line,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        currentUserModel.bio!,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => ConnectionsPage(
                                            page: "Following",
                                            userID: widget.visitedUserID!,
                                          ))));
                            },
                            child: Text(
                              '$_followingCount Following',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => ConnectionsPage(
                                            page: "Followers",
                                            userID: widget.visitedUserID!,
                                          ))));
                            },
                            child: Text(
                              '$_followersCount Followers',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 2,
                              ),
                            ),
                          )
                        ],
                      ),
                      widget.currentUserID != widget.visitedUserID
                          ? Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatRoom(
                                                userModel: currentUserModel)));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      minimumSize:
                                          const Size(double.maxFinite, 40),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  child: const Text('Message')),
                            )
                          : const SizedBox(
                              height: 20,
                            ),
                      //ignore: sized_box_for_whitespace
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width,
                        child: CupertinoSlidingSegmentedControl(
                          groupValue: profileSegmentedValue,
                          thumbColor: tcolor,
                          backgroundColor: Colors.white,
                          children: profileTabs,
                          onValueChanged: (index) {
                            setState(() {
                              profileSegmentedValue = index!;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                buildProfileWidgets(currentUserModel)
              ],
            ),
          );
        }));
  }
}
