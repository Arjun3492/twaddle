import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:twaddle/constants/colors.dart';
import 'package:twaddle/core/services/database_service.dart';
import 'package:twaddle/core/services/sharedpref_service.dart';
import 'package:twaddle/utils/helpers.dart';

class DetailMessages extends StatefulWidget {
  final String userName, displayName, photoURL;

  const DetailMessages(
      {Key? key,
      required this.userName,
      required this.displayName,
      required this.photoURL})
      : super(key: key);

  @override
  State<DetailMessages> createState() => _DetailMessagesState();
}

class _DetailMessagesState extends State<DetailMessages> {
  DatabaseService ds = DatabaseService();
  late Stream<QuerySnapshot> messageStream;
  late String myUsername, myDisplayName, myEmail, myProfilePic, chatRoomId;

  Future doThisOnInit() async {
    await getCurrentUserInfo();
    await getAndSetMessages();
    return true;
  }

  getCurrentUserInfo() async {
    myUsername = await SharedPreference().getUserName();
    myDisplayName = await SharedPreference().getUserDisplayName();
    myEmail = await SharedPreference().getUserEmail();
    myProfilePic = await SharedPreference().getUserProfilePic();
    chatRoomId = getChatRoomId(myUsername, widget.userName);
  }

  getChatRoomId(String a, String b) {
    if ((a.codeUnitAt(0) +
            a.codeUnitAt(1) +
            a.codeUnitAt(2) +
            a.codeUnitAt(3)) >
        (b.codeUnitAt(0) +
            b.codeUnitAt(1) +
            b.codeUnitAt(2) +
            b.codeUnitAt(3))) {
      return "$a-$b";
    } else {
      return "$b-$a";
    }
  }

  getAndSetMessages() async {
    messageStream = await ds.getChatRoomMessages(chatRoomId);
  }

  addMessage() {
    if (messageController.text != "") {
      String message = messageController.text;
      DateTime lastMessageTs = DateTime.now();
      Map<String, dynamic> messageInfoMap = {
        "message": messageController.text,
        "sendBy": myUsername,
        "ts": lastMessageTs,
        "photoURL": myProfilePic
      };

      String messageId = randomAlphaNumeric(12);
      ds
          .addMessage(
              chatRoomId: chatRoomId,
              messageId: messageId,
              messageInfoMap: messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageTs": lastMessageTs,
          "lastMessageSendBy": myUsername,
        };

        ds.updateLastMessage(chatRoomId, lastMessageInfoMap);
        messageController.text = "";
        messageId = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.fromLTRB(25, 30, 25, 80),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: FutureBuilder(
                future: doThisOnInit(),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: messageStream,
                      builder: (ctx, snapshots) {
                        switch (snapshots.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child:
                                    CircularProgressIndicator(color: kPrimary));
                          default:
                            if (snapshots.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshots.error}'));
                            } else {
                              return ListView.separated(
                                  reverse: true,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot ds =
                                        snapshots.data!.docs[index];
                                    return (ds["sendBy"] == widget.userName)
                                        ? _buildReceivedText(
                                            ds["message"],
                                            (DateFormat('HH:mm')
                                                    .format(ds["ts"].toDate()))
                                                .toString(),
                                            ds["photoURL"])
                                        : _buildSenderText(
                                            ds["message"],
                                            (DateFormat('HH:mm')
                                                    .format(ds["ts"].toDate()))
                                                .toString());
                                  },
                                  separatorBuilder: (_, index) =>
                                      SizedBox(height: 20),
                                  itemCount: snapshots.data!.docs.length);
                            }
                        }
                      },
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return Container();
                  }
                })),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 50, 20),
            height: 50,
            width: 300,
            child: TextField(
              controller: messageController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  fillColor: kGrayLight.withOpacity(0.2),
                  filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Type Your Message....',
                  hintStyle: TextStyle(
                      color: kPrimaryDark.withOpacity(0.3), fontSize: 15)),
            ),
          ),
        ),
        Positioned(
            right: 8,
            bottom: 8,
            child: GestureDetector(
              onTap: () {
                addMessage();
              },
              child: Container(
                height: 45,
                width: 45,
                margin: EdgeInsets.fromLTRB(10, 0, 0, 15),
                padding: EdgeInsets.all(10),
                decoration:
                    BoxDecoration(color: kPrimary, shape: BoxShape.circle),
                child: Icon(Icons.send_sharp, color: Colors.white, size: 20),
              ),
            ))
      ],
    );
  }

  Widget _buildSenderText(final String message, ts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(ts, style: TextStyle(color: kGrayLight, fontSize: 12)),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: kPrimaryLight,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15))),
          child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 180),
              child: Text(message,
                  style: TextStyle(height: 1.5, color: kPrimaryDark))),
        )
      ],
    );
  }

  Widget _buildReceivedText(final String message, ts, imgUrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.photoURL),
            ),
            SizedBox(width: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: kGrayLight.withOpacity(0.2),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 180),
                child: Text(message,
                    style: TextStyle(height: 1.5, color: kPrimaryDark)),
              ),
            )
          ],
        ),
        Text(
          ts,
          style: TextStyle(color: kGrayLight, fontSize: 12),
        )
      ],
    );
  }
}
