import 'package:flutter/material.dart';
import 'package:twaddle/constants/colors.dart';
import 'package:twaddle/core/services/database_service.dart';
import 'widgets/contact_info.dart';
import 'widgets/detail_app_bar.dart';
import 'widgets/detail_messages.dart';

class DetailPage extends StatelessWidget {
  final DatabaseService ds = DatabaseService();
  final String userName, displayName, photoURL;
  DetailPage(this.userName, this.displayName, this.photoURL, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimary,
        body: Column(
          children: [
            DetailAppBar(),
            ContactInfo(displayName: displayName),
            Expanded(
                child: DetailMessages(
              displayName: displayName,
              userName: userName,
              photoURL: photoURL,
            ))
          ],
        ));
  }
}
