import 'package:connect_z/constants/constants.dart';
import 'package:connect_z/models/user_model.dart';
import 'package:connect_z/pages/chatroom_screen.dart';
import 'package:connect_z/services/chat_service.dart';
import 'package:flutter/material.dart';

class ChatSpot extends StatefulWidget {
  const ChatSpot({super.key});

  @override
  State<ChatSpot> createState() => _ChatSpotState();
}

class _ChatSpotState extends State<ChatSpot> {
  Widget buildChatRoom() {
    return FutureBuilder(
        future: ChatService.getChatList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<UserModel> users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                ChatRoom(userModel: users[index]))));
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(users[index].profilePicture!),
                  ),
                  title: Text(users[index].name!),
                );
              },
            );
          } else {
            return const Center(
                child: Text(
              "Fetching Data....",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: appDefaultColor),
            ));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Spot'),
        centerTitle: true,
      ),
      body: buildChatRoom(),
    );
  }
}
