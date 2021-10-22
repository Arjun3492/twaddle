import 'package:flutter/material.dart';
import 'package:twaddle/constants/colors.dart';
import 'package:twaddle/models/message.dart';

class DetailMessages extends StatelessWidget {
  final myId = 0;
  final list = generateMessagesFromUser();
  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var messageList = List.from(list.reversed);
    return Container(
        child: Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.fromLTRB(25, 30, 25, 80),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: ListView.separated(
              reverse: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) =>
                  messageList[index].user!.id == myId
                      ? _buildReceivedText(messageList[index])
                      : _buildSenderText(messageList[index]),
              separatorBuilder: (_, index) => SizedBox(height: 20),
              itemCount: list.length),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 50, 20),
            height: 50,
            width: 300,
            child: Stack(
              children: [
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  // onTap: () {
                  //   _scrollController.animateTo(0,
                  //       duration: Duration(milliseconds: 300),
                  //       curve: Curves.easeOut);
                  // },
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
              ],
            ),
          ),
        ),
        Positioned(
            right: 8,
            bottom: 8,
            child: Container(
              height: 45,
              width: 45,
              margin: EdgeInsets.fromLTRB(10, 0, 0, 15),
              padding: EdgeInsets.all(10),
              decoration:
                  BoxDecoration(color: kPrimary, shape: BoxShape.circle),
              child: Icon(Icons.send_sharp, color: Colors.white, size: 20),
            ))
      ],
    ));
  }

  Widget _buildReceivedText(Message message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(message.lastTime,
            style: TextStyle(color: kGrayLight, fontSize: 12)),
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
              child: Text(message.lastMessage,
                  style: TextStyle(height: 1.5, color: kPrimaryDark))),
        )
      ],
    );
  }

  Widget _buildSenderText(Message message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            message.isContinue
                ? SizedBox(
                    width: 40,
                  )
                : CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(message.user!.iconUrl),
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
                child: Text(message.lastMessage,
                    style: TextStyle(height: 1.5, color: kPrimaryDark)),
              ),
            )
          ],
        ),
        Text(
          message.lastTime,
          style: TextStyle(color: kGrayLight, fontSize: 12),
        )
      ],
    );
  }
}
