import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twaddle/constants/colors.dart';
import 'package:twaddle/core/auth/screens/signin_screen.dart';
import 'package:twaddle/core/auth/services/auth_service.dart';
import 'package:twaddle/core/services/database_service.dart';
import 'package:twaddle/core/services/sharedpref_service.dart';
import 'package:twaddle/screens/home/widgets/messages.dart';
import 'package:twaddle/screens/home/widgets/recent_contacts.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      body: FutureBuilder(
          future: auth.getCurrentUser(),
          builder: (cnt, snapshot) {
            if (snapshot.hasData) {
              return HomePage();
            } else {
              return const SignInPage();
            }
          }),
    );
  }
}

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService auth = AuthService();

  DatabaseService db = DatabaseService();

  late String myUsername = "",
      myDisplayName = "",
      myEmail = "",
      myProfilePic = "",
      chatRoomId;

  late Stream<QuerySnapshot> chatRoomStream;

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

  getCurrentUserInfo() async {
    myUsername = await SharedPreference().getUserName();
    myDisplayName = await SharedPreference().getUserDisplayName();
    myEmail = await SharedPreference().getUserEmail();
    myProfilePic = await SharedPreference().getUserProfilePic();
  }

  getChatRooms() async {
    chatRoomStream = await db.getChatRooms();
  }

  @override
  void initState() {
    getCurrentUserInfo;
    getChatRooms;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Twaddle',
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                    onTap: () {
                      auth.signOut(context);
                    },
                    child: const Icon(Icons.logout, color: Colors.white)),
              ),
            ],
          ),
          RecentContacts(
            myEmail: myEmail,
            myProfilePic: myProfilePic,
            myDisplayName: myDisplayName,
            myUsername: myUsername,
            chatRoomStream: chatRoomStream,
          ),
          RecentMessages(
            myEmail: myEmail,
            myProfilePic: myProfilePic,
            myDisplayName: myDisplayName,
            myUsername: myUsername,
            chatRoomStream: chatRoomStream,
          )
        ],
      ),
    );
  }
}
