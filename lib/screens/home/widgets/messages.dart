import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twaddle/constants/colors.dart';
import 'package:twaddle/core/services/database_service.dart';
import 'package:twaddle/models/message.dart';
import 'package:twaddle/screens/detail/detail.dart';
import 'package:twaddle/utils/helpers.dart';

class RecentMessages extends StatefulWidget {
  @override
  State<RecentMessages> createState() => _RecentMessagesState();
}

class _RecentMessagesState extends State<RecentMessages> {
  DatabaseService db = DatabaseService();
  late Future<QuerySnapshot> searchUserList;
  final messagesList = generateHomePageMessages();

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
                    ? _buildMessages()
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
                // FutureBuilder(
                //     future: _searchlist(searchController.text),
                //     builder: (ctx, AsyncSnapshot<Widget> snapshot) {
                //       if (snapshot.hasData) {
                //         return snapshot.data!;
                //       } else
                //         return CircularProgressIndicator();
                //     });
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
                                    email: ds["email"])
                                : Center(
                                    child: CircularProgressIndicator(),
                                  );
                          },
                          separatorBuilder: (_, index) => SizedBox(height: 30),
                          itemCount: snapshot.data!.docs.length);
                }
              });
          //  (sch == false)
          //     ? const ListTile(
          //         title: Text("Enter username to search for"),
          //       )
          //     : StreamBuilder<QuerySnapshot>(
          //         stream: searchUserList,
          //         builder: (ctx, snapshot) {
          //           return ListView.separated(
          //               padding: EdgeInsets.zero,
          //               itemBuilder: (context, index) {
          //                 DocumentSnapshot ds = snapshot.data!.docs[index];
          //                 return (snapshot.hasData)
          //                     ? _searchListTile(
          //                         displayName: ds["displayName"],
          //                         photoURL: ds["photoURL"])
          //                     : Center(
          //                         child: CircularProgressIndicator(),
          //                       );
          //               },
          //               separatorBuilder: (_, index) => SizedBox(height: 30),
          //               itemCount: snapshot.data!.docs.length);
          //         });
        });
  }

  _searchListTile(
      {required String displayName,
      required String photoURL,
      required String email}) {
    return GestureDetector(
      onTap: () {},
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

  _buildMessages() {
    return ListView.separated(
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) => _buildMessage(context, index),
        separatorBuilder: (_, index) => SizedBox(height: 30),
        itemCount: messagesList.length);
  }

  Widget _buildMessage(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailPage(messagesList[index])));
      },
      child: Row(
        children: [
          CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(messagesList[index].user!.iconUrl)),
          SizedBox(width: 10),
          Flexible(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '${messagesList[index].user!.firstName} ${messagesList[index].user!.lastName}',
                        style: TextStyle(
                            fontSize: 16,
                            color: kPrimaryDark,
                            fontWeight: FontWeight.bold)),
                    Text(messagesList[index].lastTime,
                        style: TextStyle(color: kGrayLight))
                  ],
                ),
                SizedBox(height: 5),
                Text(messagesList[index].lastMessage,
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
