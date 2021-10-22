import 'package:flutter/material.dart';
import 'package:twaddle/models/user.dart';

class RecentContacts extends StatelessWidget {
  final contactList = User.generateUsers();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 25),
      padding: EdgeInsets.only(left: 25),
      height: 50,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search, size: 30, color: Colors.white),
          ),
          Expanded(
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(contactList[index].iconUrl),
                    ),
                separatorBuilder: (_, index) => SizedBox(width: 15),
                itemCount: contactList.length),
          ),
        ],
      ),
    );
  }
}
