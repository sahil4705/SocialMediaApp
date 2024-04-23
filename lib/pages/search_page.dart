import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_z/constants/constants.dart';
import 'package:connect_z/models/user_model.dart';
import 'package:connect_z/pages/user_pages/profile_page.dart';
import 'package:connect_z/services/db_service.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final String currentUserId;
  const SearchPage({super.key, required this.currentUserId});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<QuerySnapshot>? _users;

  final TextEditingController _searchController = TextEditingController();

  clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback(((_) => _searchController.clear()));
    setState(() {
      _users = null;
    });
  }

  buildUserTile(UserModel user) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: user.profilePicture!.isEmpty
            ? const NetworkImage(
                'https://media.istockphoto.com/id/470100848/vector/male-profile-icon-white-on-the-blue-background.jpg?s=612x612&w=0&k=20&c=2Z3As7KdHqSKB6UDBpSIbMkwOgYQtbhSWrF1ZHX505E=')
            : NetworkImage(user.profilePicture!),
      ),
      title: Text(user.name!),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfilePage(
                  currentUserID: widget.currentUserId,
                  visitedUserID: user.id,
                )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: appDefaultSystemOverlayStyle,
          backgroundColor: appDefaultColor,
          centerTitle: true,
          elevation: 0.5,
          title: TextField(
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white60,
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              hintText: '\tSearch Users....',
              hintStyle: const TextStyle(
                  color: Colors.white60, fontWeight: FontWeight.bold),
              border: InputBorder.none,
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onPressed: clearSearch,
              ),
              filled: true,
            ),
            onChanged: (input) {
              if (input.isNotEmpty) {
                setState(() {
                  _users = DBService.searchUser(input);
                });
              }
            },
          ),
        ),
        body: _users == null
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      size: 200,
                    ),
                    Text(
                      'Search Users...',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              )
            : FutureBuilder(
                future: _users,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No Users Found!'),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      UserModel user =
                          UserModel.fromDoc(snapshot.data!.docs[index]);
                      return buildUserTile(user);
                    },
                  );
                },
              ));
  }
}
