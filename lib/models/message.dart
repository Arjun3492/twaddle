import 'package:flutter/material.dart';
import 'package:twaddle/models/user.dart';

class Message {
  User? user;
  String lastMessage;
  String lastTime;
  bool isContinue;
  Message(this.user, this.lastMessage, this.lastTime,
      {this.isContinue = false});
}

List<Message> generateHomePageMessages() {
  return [
    Message(
        user[0], 'Hey there! What\'s up? Is everything going well?', '18:32'),
    Message(
        user[1], 'Hey there! What\'s up? Is everything going well?', '17:32'),
    Message(
        user[2], 'Hey there! What\'s up? Is everything going well?', '14:20'),
    Message(
        user[3], 'Hey there! What\'s up? Is everything going well?', '13:35'),
    Message(
        user[4], 'Hey there! What\'s up? Is everything going well?', '12:11'),
    Message(
        user[5], 'Hey there! What\'s up? Is everything going well?', '12:00'),
    Message(
        user[6], 'Hey there! What\'s up? Is everything going well?', '11:00')
  ];
}

List<Message> generateMessagesFromUser() {
  return [
    Message(
        user[0], 'Hey there! What\'s up? Is everything going well?', '18:32'),
    Message(me, 'Hey there! What\'s up? Is everything going well?', '17:32'),
    Message(
        user[0], 'Hey there! What\'s up? Is everything going well?', '14:20',
        isContinue: true),
    Message(
        user[0], 'Hey there! What\'s up? Is everything going well?', '13:35'),
    Message(me, 'Hey there! What\'s up? Is everything going well?', '12:11'),
    Message(
        user[0], 'Hey there! What\'s up? Is everything going well?', '12:00'),
  ];
}

var user = User.generateUsers();
var me =
    User(0, 'Naman', 'Sinha', 'assets/images/naman.jpg', Color(0xFFFED6C4));
