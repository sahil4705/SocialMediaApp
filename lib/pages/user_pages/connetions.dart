import 'package:connect_z/common/progress_circle.dart';
import 'package:connect_z/constants/constants.dart';
import 'package:connect_z/main.dart';
import 'package:connect_z/models/user_model.dart';
import 'package:connect_z/pages/User_Pages/profile_page.dart';
import 'package:connect_z/services/db_service.dart';
import 'package:flutter/material.dart';

class ConnectionsPage extends StatefulWidget {
  final String page;
  final String userID;
  const ConnectionsPage({super.key, required this.page, required this.userID});

  @override
  State<ConnectionsPage> createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  List<UserModel> _connectionsList = [];
  var _loading = true;

  void setConnectionsList() async {
    List<UserModel> userFollowers =
        await DBService.getConnection(widget.userID, widget.page);

    if (mounted) {
      setState(() {
        _connectionsList = userFollowers;
        _loading = false;
      });
    }
  }

  buildTiles(UserModel user) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => ProfilePage(
                      currentUserID: userID,
                      visitedUserID: user.id,
                    ))));
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.profilePicture!),
      ),
      title: Text(user.name!),
    );
  }

  List<Widget> getConnectionsList() {
    List<Widget> list = [];
    for (var users in _connectionsList) {
      list.add(buildTiles(users));
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    setConnectionsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: appDefaultSystemOverlayStyle,
        title: Text(widget.page),
        centerTitle: true,
      ),
      body: RefreshIndicator(
          onRefresh: () {
            return Future(() => setConnectionsList());
          },
          child: _loading
              ? const Center(child: ProgressCircle())
              : ListView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: _connectionsList.isEmpty
                      ? const [
                          Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Center(
                              child: Text(
                                'No Data Found',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          )
                        ]
                      : getConnectionsList(),
                )),
    );
  }
}
