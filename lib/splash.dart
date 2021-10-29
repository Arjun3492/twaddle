import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twaddle/constants/colors.dart';
import 'package:twaddle/screens/home/home.dart';

// class Splash extends StatelessWidget {
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(
        // ignore: non_constant_identifier_names
        context,
        MaterialPageRoute(builder: (Context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                child: SvgPicture.asset("assets/splash_logo.svg"),
                width: 250,
                height: 450),
            Column(
              children: [
                const Text('Twaddle',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: kPrimary)),
                const SizedBox(height: 16),
                Title(
                    color: kGrayLight,
                    child: const Text(
                      '❝ MOST PEOPLE ARE NICE AND JUST WANT TO HAVE A CHAT ❞',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54),
                    )),
                const SizedBox(height: 64),
              ],
            )
          ],
        ),
      ),
    );
  }
}
