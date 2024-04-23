import 'package:connect_z/constants/constants.dart';
import 'package:connect_z/models/notification_model.dart';
import 'package:connect_z/models/user_model.dart';
import 'package:connect_z/services/db_service.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  final currentUserID;
  const NotificationPage({super.key, required this.currentUserID});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationModel> _notifications = [];
  bool _loading = false;

  notifTile(NotificationModel notificationModel, UserModel user) {
    return ListTile(
      leading: CircleAvatar(
          radius: 20,
          backgroundImage: user.profilePicture!.isEmpty
              ? appDefaultProfilePicture
              : NetworkImage(user.profilePicture!)),
      title: notificationModel.follow == true
          ? Text('${user.name} follows you.')
          : Text('${user.name} liked your photo.'),
    );
  }

  buildTile(NotificationModel notificationModel, UserModel user) {
    return Container(
      child: notifTile(notificationModel, user),
    );
  }

  showNotification(String currentUserID) {
    List<Widget> notificationsList = [];
    for (NotificationModel model in _notifications) {
      notificationsList.add(FutureBuilder(
          future: usersRef.doc(model.fromUserID).get(),
          builder: (BuildContext context, AsyncSnapshot snaphsot) {
            if (snaphsot.hasData) {
              UserModel userModel = UserModel.fromDoc(snaphsot.data);
              return buildTile(model, userModel);
            } else {
              return const SizedBox.shrink();
            }
          }));
    }
    return notificationsList;
  }

  setupNofifications() async {
    setState(() {
      _loading = true;
    });

    List<NotificationModel> notifications =
        await DBService.getNotification(widget.currentUserID);
    if (mounted) {
      setState(() {
        _notifications = notifications;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupNofifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: appDefaultSystemOverlayStyle,
        backgroundColor: appcolor,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            Text(
              '\tNotifications',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
          onRefresh: () => setupNofifications(),
          child: ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              _loading
                  ? const LinearProgressIndicator()
                  : const SizedBox.shrink(),
              Column(
                children: [
                  Column(
                    children: _notifications.isEmpty && _loading == false
                        ? [
                            Container(
                              margin: const EdgeInsets.all(25),
                              child: const Text(
                                'No Notifications Here',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: appDefaultColor,
                                    fontSize: 20),
                              ),
                            )
                          ]
                        : showNotification(widget.currentUserID),
                  )
                ],
              )
            ],
          )),
    );
  }
}
