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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService auth = AuthService();
  DatabaseService db = DatabaseService();
  late String myUsername, myDisplayName, myEmail, myProfilePic, chatRoomId;
  late Stream<QuerySnapshot> chatRoomStream;

  Future<bool> getChatRoomsAndCurrentUserInfo() async {
    myUsername = await SharedPreference().getUserName();
    myDisplayName = await SharedPreference().getUserDisplayName();
    myEmail = await SharedPreference().getUserEmail();
    myProfilePic = await SharedPreference().getUserProfilePic();
    chatRoomStream = await db.getChatRooms();
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    getChatRoomsAndCurrentUserInfo().whenComplete(() {
      setState(() {});
    });
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
          // FutureBuilder(
          //   future: getChatRoomsAndCurrentUserInfo(),
          //   builder: (ctx, snapshot) {
          //     return (snapshot.hasData)
          //         ?
          RecentContacts(
            myUsername: myUsername,
            myEmail: myEmail,
            myDisplayName: myDisplayName,
            myProfilePic: myProfilePic,
            chatRoomStream: chatRoomStream,
          ),
          RecentMessages(
            myUsername: myUsername,
            myEmail: myEmail,
            myDisplayName: myDisplayName,
            myProfilePic: myProfilePic,
            chatRoomStream: chatRoomStream,
          )
          //         : Container();
          //   },
          // ),
        ],
      ),
    );
  }
}
