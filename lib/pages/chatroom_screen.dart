import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_z/main.dart';
import 'package:connect_z/models/user_model.dart';
import 'package:connect_z/services/chat_service.dart';
import 'package:connect_z/services/messagebox.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final UserModel userModel;
  const ChatRoom({super.key, required this.userModel});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController chatMessage = TextEditingController();

  void _sendMessage() async {
    if (chatMessage.text.isNotEmpty) {
      await ChatService.sendMessage(widget.userModel.id!, chatMessage.text);
    }
    chatMessage.clear();
  }

  Widget buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    var alignment = (data['senderid'] == userID
        ? Alignment.centerRight
        : Alignment.centerLeft);

    return Container(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: (data['senderid'] == userID)
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisAlignment: (data['senderid'] == userID)
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              data["senderid"] == userID
                  ? GestureDetector(
                      onLongPress: () {
                        deleteChatConfirm(
                            context,
                            (data["receiverid"] + "_" + data["senderid"]),
                            doc.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: (data['senderid'] == userID)
                              ? Colors.blue
                              : Colors.green,
                        ),
                        child: Text(
                          data['message'],
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: (data['senderid'] == userID)
                            ? Colors.blue
                            : Colors.green,
                      ),
                      child: Text(
                        data['message'],
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
            ],
          ),
        ));
  }

  Widget buildMessageList() {
    return StreamBuilder(
        stream: ChatService.getMessages(widget.userModel.id!, userID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error : ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading');
          }

          return ListView(
            children:
                snapshot.data!.docs.map((e) => buildMessageItem(e)).toList(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.userModel.profilePicture!),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                widget.userModel.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 20),
              )
            ]),
      ),
      body: Column(children: [
        Expanded(child: buildMessageList()),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 7),
            child: ListTile(
              style: ListTileStyle.list,
              title: TextFormField(
                controller: chatMessage,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    border: OutlineInputBorder()),
              ),
              trailing: OutlinedButton(
                  onPressed: _sendMessage,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Icon(Icons.send),
                  )),
            )),
      ]),
    );
  }
}
