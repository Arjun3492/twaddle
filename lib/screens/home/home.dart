import 'package:flutter/material.dart';
import 'package:twaddle/core/auth/screens/signin_screen.dart';
import 'package:twaddle/core/auth/services/auth_service.dart';
import 'package:twaddle/screens/home/widgets/messages.dart';
import 'package:twaddle/screens/home/widgets/recent_contacts.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  AuthService auth = AuthService();

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: auth.getCurrentUser(),
        builder: (cnt, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return const SignInPage();
          }
        });
  }
}

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  AuthService auth = AuthService();
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
          RecentContacts(),
          RecentMessages()
        ],
      ),
    );
  }
}
