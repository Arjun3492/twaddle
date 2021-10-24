import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twaddle/core/services/database_service.dart';
import 'package:twaddle/screens/detail/detail.dart';
import 'package:twaddle/utils/helpers.dart';

class RecentContacts extends StatefulWidget {
  final String myUsername, myDisplayName, myEmail, myProfilePic;
  final Stream<QuerySnapshot> chatRoomStream;
  const RecentContacts({
    Key? key,
    required this.myProfilePic,
    required this.chatRoomStream,
    required this.myUsername,
    required this.myDisplayName,
    required this.myEmail,
  }) : super(key: key);
  @override
  State<RecentContacts> createState() => _RecentContactsState();
}

class _RecentContactsState extends State<RecentContacts> {
  late Stream<QuerySnapshot> chatRoomStream;
  DatabaseService db = DatabaseService();
  // late String photoURL, displayName, username;
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
                        ? StreamBuilder<QuerySnapshot>(
                            stream: chatRoomStream,
                            builder: (ctx, snapshot) {
                              return ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot ds =
                                        snapshot.data!.docs[index];
                                    return UserAvatar(
                                        chatRoomId: ds.id,
                                        myUsername: widget.myUsername);
                                  },
                                  separatorBuilder: (_, index) =>
                                      SizedBox(width: 15),
                                  itemCount: snapshot.data!.docs.length);
                            })
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
      child: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(photoURL),
      ),
    );
  }
}
