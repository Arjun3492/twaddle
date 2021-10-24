import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twaddle/constants/colors.dart';
import 'package:twaddle/core/services/database_service.dart';
import 'package:twaddle/screens/detail/detail.dart';
import 'package:twaddle/utils/helpers.dart';

class RecentMessages extends StatefulWidget {
  final String myUsername, myDisplayName, myEmail, myProfilePic;
  final Stream<QuerySnapshot> chatRoomStream;
  late String chatRoomId;
  RecentMessages({
    Key? key,
    required this.chatRoomStream,
    required this.myUsername,
    required this.myDisplayName,
    required this.myEmail,
    required this.myProfilePic,
  }) : super(key: key);
  @override
  State<RecentMessages> createState() => _RecentMessagesState();
}

class _RecentMessagesState extends State<RecentMessages> {
  DatabaseService db = DatabaseService();

  late Future<QuerySnapshot> searchUserList;
  getChatRoomId(String a, String b) {
    if ((a.codeUnitAt(0) +
            a.codeUnitAt(1) +
            a.codeUnitAt(2) +
            a.codeUnitAt(3)) >
        (b.codeUnitAt(0) +
            b.codeUnitAt(1) +
            b.codeUnitAt(2) +
            b.codeUnitAt(3))) {
      return "$a-_$b";
    } else {
      return "$b-_$a";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          padding: EdgeInsets.fromLTRB(25, 40, 25, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: ValueListenableBuilder<bool>(
              valueListenable: searchable,
              builder: (ctx, sch, child) {
                return (sch == false)
                    ? StreamBuilder<QuerySnapshot>(
                        stream: widget.chatRoomStream,
                        builder: (ctx, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(
                                  child: CircularProgressIndicator(
                                      color: kPrimary));
                            default:
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                return ListView.separated(
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot ds =
                                          snapshot.data!.docs[index];
                                      return UserListTile(
                                          lastMessageTs: ds["lastMessageTs"],
                                          lastMessage: ds["lastMessage"],
                                          chatRoomId: ds.id,
                                          myUsername: widget.myUsername);
                                    },
                                    separatorBuilder: (_, index) =>
                                        SizedBox(height: 30),
                                    itemCount: snapshot.data!.docs.length);
                              }
                          }
                        })
                    : ValueListenableBuilder<bool>(
                        valueListenable: shouldSearch,
                        builder: (ctx, ssch, child) {
                          return (ssch == false)
                              ? const ListTile(
                                  title: Text("Enter username to search for"),
                                )
                              : FutureBuilder(
                                  future: _searchlist(searchController.text),
                                  builder:
                                      (ctx, AsyncSnapshot<Widget> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return snapshot.data!;
                                    } else {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                  });
                        });
              })),
    );
  }

  Future<Widget> _searchlist(String username) async {
    searchUserList = db.getUserByUserName(username);

    return ValueListenableBuilder(
        valueListenable: shouldSearch,
        builder: (ctx, sch, child) {
          return FutureBuilder<QuerySnapshot>(
              future: searchUserList,
              builder: (ctx, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                        child: CircularProgressIndicator(color: kPrimary));
                  default:
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else
                      return ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data!.docs[index];
                            return (snapshot.hasData)
                                ? _searchListTile(
                                    displayName: ds["displayName"],
                                    photoURL: ds["photoURL"],
                                    email: ds["email"],
                                    username: ds["userName"])
                                : Center(
                                    child: CircularProgressIndicator(),
                                  );
                          },
                          separatorBuilder: (_, index) => SizedBox(height: 30),
                          itemCount: snapshot.data!.docs.length);
                }
              });
        });
  }

  _searchListTile(
      {required String displayName,
      required String photoURL,
      required String email,
      required String username}) {
    return GestureDetector(
      onTap: () {
        widget.chatRoomId = getChatRoomId(username, widget.myUsername);
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [username, widget.myUsername]
        };

        db.createChatRoom(widget.chatRoomId, chatRoomInfoMap);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => DetailPage(username, displayName, photoURL)));
      },
      child: Row(
        children: [
          CircleAvatar(radius: 30, backgroundImage: NetworkImage(photoURL)),
          SizedBox(width: 10),
          Flexible(
            child: Column(
              children: [
                Text('${displayName}',
                    style: TextStyle(
                        fontSize: 16,
                        color: kPrimaryDark,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text("${email}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: kPrimaryDark))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class UserListTile extends StatefulWidget {
  final String lastMessage, lastMessageTs, chatRoomId, myUsername;
  const UserListTile({
    Key? key,
    required this.lastMessage,
    required this.lastMessageTs,
    required this.chatRoomId,
    required this.myUsername,
  }) : super(key: key);

  @override
  State<UserListTile> createState() => _UserListTileState();
}

class _UserListTileState extends State<UserListTile> {
  DatabaseService db = DatabaseService();
  late String photoURL, displayName, username;
  getCurrentUserInfo() async {
    username =
        widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
    QuerySnapshot userInfo = await db.getUserByUserName(username);
    displayName = userInfo.docs[0]["displayName"];
    photoURL = userInfo.docs[0]["photoURL"];
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserInfo;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailPage(username, displayName, photoURL)));
      },
      child: Row(
        children: [
          CircleAvatar(radius: 30, backgroundImage: NetworkImage(photoURL)),
          SizedBox(width: 10),
          Flexible(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(displayName,
                        style: TextStyle(
                            fontSize: 16,
                            color: kPrimaryDark,
                            fontWeight: FontWeight.bold)),
                    Text(widget.lastMessageTs,
                        style: TextStyle(color: kGrayLight))
                  ],
                ),
                SizedBox(height: 5),
                Text(widget.lastMessage,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: kPrimaryDark))
              ],
            ),
          )
        ],
      ),
    );
  }
}
