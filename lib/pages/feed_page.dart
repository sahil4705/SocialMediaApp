import 'package:connect_z/constants/constants.dart';
import 'package:connect_z/pages/create_post.dart';
import 'package:connect_z/pages/home_page.dart';
import 'package:connect_z/pages/notification_page.dart';
import 'package:connect_z/pages/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'user_pages/profile_page.dart';

class FeedPage extends StatefulWidget {
  final String? cureentUserID;
  const FeedPage({super.key, this.cureentUserID});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  int optionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        HomePage(currentUserId: widget.cureentUserID!),
        SearchPage(currentUserId: widget.cureentUserID.toString()),
        const Placeholder(),
        NotificationPage(
          currentUserID: widget.cureentUserID.toString(),
        ),
        ProfilePage(
          currentUserID: widget.cureentUserID,
          visitedUserID: widget.cureentUserID,
        )
      ].elementAt(optionIndex),
      bottomNavigationBar: CupertinoTabBar(
          inactiveColor: Colors.black,
          onTap: (index) {
            setState(() {
              optionIndex = index;
            });
          },
          activeColor: appDefaultColor,
          currentIndex: optionIndex,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home)),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person_search_rounded)),
            BottomNavigationBarItem(
                icon: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateTweet(
                                  currentUserId: widget.cureentUserID!)));
                    },
                    icon: const Icon(Icons.add_box))),
            const BottomNavigationBarItem(icon: Icon(Icons.notifications)),
            const BottomNavigationBarItem(icon: Icon(Icons.person)),
          ]),
    );
  }
}
