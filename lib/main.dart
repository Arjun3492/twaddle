import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twaddle/constants/colors.dart';
import 'package:twaddle/screens/home/home.dart';
import 'core/auth/screens/signin_screen.dart';
import 'core/auth/services/auth_service.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  AuthService auth = AuthService();
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return MaterialApp(
        debugShowCheckedModeBanner: false, title: 'Twaddle', home: Home());
  }
}
