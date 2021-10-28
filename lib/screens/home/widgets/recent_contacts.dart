import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twaddle/core/services/database_service.dart';
import 'package:twaddle/core/services/sharedpref_service.dart';
import 'package:twaddle/screens/detail/detail.dart';
import 'package:twaddle/utils/helpers.dart';

// ignore: must_be_immutable
class RecentContacts extends StatefulWidget {
  final DatabaseService db = DatabaseService();
  final String myUsername, myDisplayName, myEmail, myProfilePic;
  final Stream<QuerySnapshot> chatRoomStream;
  RecentContacts({
    Key? key,
    required this.myUsername,
    required this.myDisplayName,
    required this.myEmail,
    required this.myProfilePic,
    required this.chatRoomStream,
  }) : super(key: key);

  // getChatRoomId(String a, String b) {
  //   if ((a.codeUnitAt(0) +
  //           a.codeUnitAt(1) +
  //           a.codeUnitAt(2) +
  //           a.codeUnitAt(3)) >
  //       (b.codeUnitAt(0) +
  //           b.codeUnitAt(1) +
  //           b.codeUnitAt(2) +
  //           b.codeUnitAt(3))) {
  //     return "$a-$b";
  //   } else {
  //     return "$b-$a";
  //   }
  // }

  // Future getChatRoomsAndCurrentUserInfo() async {
  //   chatRoomStream = await db.getChatRooms();
  //   myUsername = await SharedPreference().getUserName();
  //   myDisplayName = await SharedPreference().getUserDisplayName();
  //   myEmail = await SharedPreference().getUserEmail();
  //   myProfilePic = await SharedPreference().getUserProfilePic();
  //   return true;
  // }

  @override
  State<RecentContacts> createState() => _RecentContactsState();
}

class _RecentContactsState extends State<RecentContacts> {
  DatabaseService db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 25),
      padding: EdgeInsets.only(left: 25),
      height: 50,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: GestureDetector(
                onTap: () {
                  if (searchable.value == false) {
                    searchable.value = true;
                  } else if (searchable.value == true) {
                    if (shouldSearch.value == true) {
                      shouldSearch.value = false;
                    }
                    searchController.text = "";
                    searchable.value = false;
                  }
                },
                child: ValueListenableBuilder<bool>(
                    valueListenable: searchable,
                    builder: (context, currentState, child) {
                      return (currentState == false)
                          ? Icon(Icons.search, size: 30, color: Colors.white)
                          : Icon(Icons.cancel, size: 30, color: Colors.white);
                    })),
          ),
          Expanded(
              child: ValueListenableBuilder<bool>(
                  valueListenable: searchable,
                  builder: (context, currentState, child) {
                    return (currentState == false)
                        ?
                        // FutureBuilder(
                        //     future: widget.getChatRoomsAndCurrentUserInfo(),
                        //     builder: (ctx, snapshot) {
                        //       if (snapshot.hasData) {
                        //         return
                        StreamBuilder<QuerySnapshot>(
                            stream: widget.chatRoomStream,
                            builder: (ctx, snapshots) {
                              return (snapshots.hasData)
                                  ? ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot ds =
                                            snapshots.data!.docs[index];
                                        return UserAvatar(
                                            chatRoomId: ds.id,
                                            myUsername: widget.myUsername);
                                      },
                                      separatorBuilder: (_, index) =>
                                          SizedBox(width: 15),
                                      itemCount: snapshots.data!.docs.length)
                                  : Container(
                                      child: Text("hi"),
                                    );
                            })
                        //   } else if (snapshot.connectionState ==
                        //       ConnectionState.waiting) {
                        //     return CircularProgressIndicator();
                        //   } else {
                        //     return Container();
                        //   }
                        // })
                        : TextFormField(
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            controller: searchController,
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                    child: Icon(Icons.search,
                                        color: Colors.white, size: 30),
                                    onTap: () {
                                      if (shouldSearch.value == false) {
                                        shouldSearch.value = true;
                                      }
                                    }),
                                border: InputBorder.none,
                                hintText: "Search...",
                                hintStyle: TextStyle(color: Colors.white)),
                          );
                  })),
        ],
      ),
    );
  }
}

class UserAvatar extends StatefulWidget {
  final String chatRoomId, myUsername;

  UserAvatar({Key? key, required this.chatRoomId, required this.myUsername})
      : super(key: key);

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  DatabaseService db = DatabaseService();

  late String photoURL, displayName, username;

  getCurrentUserInfo() async {
    username =
        widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
    QuerySnapshot userInfo = await db.getUserByUserName(username);
    photoURL = userInfo.docs[0]["photoURL"];
    displayName = userInfo.docs[0]["displayName"];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailPage(username, displayName, photoURL)));
      },
      child: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(photoURL),
      ),
    );
  }
}
