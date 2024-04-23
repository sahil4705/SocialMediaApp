import 'package:connect_z/constants/constants.dart';
import 'package:connect_z/models/notification_model.dart';
import 'package:connect_z/models/user_model.dart';
import 'package:flutter/material.dart';

class NotificationContainer extends StatefulWidget {
  final UserModel user;
  final NotificationModel notification;
  const NotificationContainer(
      {super.key, required this.user, required this.notification});

  @override
  State<NotificationContainer> createState() => _NotificationContainerState();
}

class _NotificationContainerState extends State<NotificationContainer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: widget.user.profilePicture!.isEmpty
                ? appDefaultProfilePicture
                : NetworkImage(widget.user.profilePicture!.toString()),
          ),
          title: widget.notification.follow == true
              ? Text('${widget.user.name}follows you.')
              : Text('${widget.user.name}liked your photo.'),
        ),
        const Divider(
          color: appDefaultColor,
        )
      ],
    );
  }
}
