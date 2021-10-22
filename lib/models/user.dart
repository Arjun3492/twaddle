import 'package:flutter/widgets.dart';

class User {
  num id;
  String firstName;
  String lastName;
  String iconUrl;
  Color bgColor;

  var lastMessage;
  User(this.id, this.firstName, this.lastName, this.iconUrl, this.bgColor);

  static List<User> generateUsers() {
    return [
      User(1, 'Arjun', 'Kohli', 'assets/images/arjun.jpg', Color(0xFFFDBEC8)),
      User(2, 'Naman', 'Sinha', 'assets/images/naman.jpg', Color(0xFFFED6C4)),
      User(3, 'Kundan', 'Kumar', 'assets/images/kundan.jpg', Color(0xFFA8E4F2)),
      User(
          4, 'Vikesh', 'Pandit', 'assets/images/vikesh.jpg', Color(0xFFFFE5A7)),
      User(5, 'Aman', 'Sharma', 'assets/images/aman.jpg', Color(0xFFC3C1E6)),
      User(6, 'Anniruddha', 'Singh', 'assets/images/aniruddha.jpg',
          Color(0xFFFD95A2)),
      User(7, 'Ashutosh', 'Pathak', 'assets/images/ashutosh.jpg',
          Color(0xFFFDBEC9)),
    ];
  }
}
