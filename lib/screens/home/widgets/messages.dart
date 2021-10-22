import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twaddle/constants/colors.dart';
import 'package:twaddle/models/message.dart';
import 'package:twaddle/screens/detail/detail.dart';

class RecentMessages extends StatelessWidget {
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
        child: _buildMessages(),
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
