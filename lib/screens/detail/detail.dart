import 'package:flutter/material.dart';
import 'package:twaddle/constants/colors.dart';
import 'package:twaddle/models/message.dart';

import 'widgets/contact_info.dart';
import 'widgets/detail_app_bar.dart';
import 'widgets/detail_messages.dart';

class DetailPage extends StatelessWidget {
  final Message message;
  DetailPage(this.message);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimary,
        body: Column(
          children: [
            DetailAppBar(),
            ContactInfo(message),
            Expanded(child: DetailMessages())
          ],
        ));
  }
}
