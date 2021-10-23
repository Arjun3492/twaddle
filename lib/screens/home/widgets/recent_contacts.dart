import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:twaddle/models/user.dart';

class RecentContacts extends StatefulWidget {
  @override
  State<RecentContacts> createState() => _RecentContactsState();
}

class _RecentContactsState extends State<RecentContacts> {
  TextEditingController _searchController = TextEditingController();
  final ValueNotifier<bool> _searchable = ValueNotifier<bool>(false);
  final contactList = User.generateUsers();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
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
                  if (_searchable.value == false) {
                    _searchable.value = true;
                  } else if (_searchable.value == true) {
                    _searchable.value = false;
                  }
                },
                child: ValueListenableBuilder<bool>(
                    valueListenable: _searchable,
                    builder: (context, currentState, child) {
                      return (currentState == false)
                          ? Icon(Icons.search, size: 30, color: Colors.white)
                          : Icon(Icons.cancel, size: 30, color: Colors.white);
                    })),
          ),
          Expanded(
              child: ValueListenableBuilder<bool>(
                  valueListenable: _searchable,
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
                            controller: _searchController,
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                    child:
                                        Icon(Icons.search, color: Colors.white),
                                    onTap: () {
                                      // if (_formKey.currentState!.validate()) {
                                      //   print(_searchController.text);
                                      //   //remove this
                                      // }
                                    }),
                                border: InputBorder.none,
                                hintText: "Search...",
                                hintStyle: TextStyle(color: Colors.white)),
                          );
                  })
            
              ),
        ],
      ),
    );
  }
}
