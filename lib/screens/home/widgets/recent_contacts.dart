import 'package:flutter/material.dart';
import 'package:twaddle/models/user.dart';
import 'package:twaddle/utils/helpers.dart';

class RecentContacts extends StatefulWidget {
  @override
  State<RecentContacts> createState() => _RecentContactsState();
}

class _RecentContactsState extends State<RecentContacts> {
  final contactList = User.generateUsers();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

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
            child: GestureDetector(
                onTap: () {
                  if (searchable.value == false) {
                    searchable.value = true;
                  } else if (searchable.value == true) {
                    if (shouldSearch.value == true) {
                      searchable.value = false;
                    }
                    searchable.value = false;
                  }
                },
                child: ValueListenableBuilder<bool>(
                    valueListenable: searchable,
                    builder: (context, currentState, child) {
                      return (currentState == false)
                          ? Icon(Icons.search, size: 30, color: Colors.white)
                          : Icon(Icons.cancel, size: 30, color: Colors.white);
                    })),
          ),
          Expanded(
              child: ValueListenableBuilder<bool>(
                  valueListenable: searchable,
                  builder: (context, currentState, child) {
                    return (currentState == false)
                        ? ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      AssetImage(contactList[index].iconUrl),
                                ),
                            separatorBuilder: (_, index) => SizedBox(width: 15),
                            itemCount: contactList.length)
                        : TextFormField(
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            controller: searchController,
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                    child: Icon(Icons.search,
                                        color: Colors.white, size: 30),
                                    onTap: () {
                                      if (shouldSearch.value == false) {
                                        shouldSearch.value = true;
                                      }
                                    }),
                                border: InputBorder.none,
                                hintText: "Search...",
                                hintStyle: TextStyle(color: Colors.white)),
                          );
                  })),
        ],
      ),
    );
  }
}
