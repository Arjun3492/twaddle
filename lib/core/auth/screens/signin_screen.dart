import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twaddle/constants/colors.dart';
import 'package:twaddle/core/auth/screens/widgets/google_signin_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  child: SvgPicture.asset("assets/sign_in_logo.svg"),
                  width: 300,
                  height: 450),
              // const SizedBox(height: 24),
              const Text("Get Started with Twaddle",
                  style: TextStyle(
                      fontSize: 22,
                      color: kPrimary,
                      fontWeight: FontWeight.bold)),
              // const SizedBox(
              //   height: 48,
              // ),
              const GoogleSignInButton()
            ],
          ),
        ),
      ),
    );
  }
}
