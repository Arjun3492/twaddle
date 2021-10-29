import 'package:flutter/material.dart';
import 'package:twaddle/utils/helpers.dart';

class ContactInfo extends StatelessWidget {
  final String displayName;
  late String fName, lName;
  ContactInfo({
    Key? key,
    required this.displayName,
  }) : super(key: key) {
    fName = displayName.split(" ")[0];
    lName = displayName.split(" ")[1];
    messageSearch.value = false;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableBuilder(
                valueListenable: messageSearch,
                builder: (context, currentState, child) {
                  return (messageSearch.value)
                      ? Expanded(
                          child: TextFormField(
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    //filter message search
                                  },
                                  child: Icon(Icons.search,
                                      color: Colors.white, size: 30)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              hintText: "Search Messages...",
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.3))),
                        ))
                      : Text(
                          '$fName\n$lName',
                          // '${widget.message.user!.firstName}\n${widget.message.user!.lastName}',
                          style: TextStyle(
                              height: 1.2,
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        );
                }),

            Container(
              child: GestureDetector(
                  onTap: () {
                    messageSearch.value = !messageSearch.value;
                  },
                  child: ValueListenableBuilder<bool>(
                      valueListenable: messageSearch,
                      builder: (context, currentState, child) {
                        return (currentState)
                            ? Icon(Icons.cancel, size: 30, color: Colors.white)
                            : Icon(Icons.search, size: 30, color: Colors.white);
                      })),
            ),

            // Row(
            //   children: [
            //     _buildCallButton(Icons.phone),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     _buildCallButton(Icons.video_camera_back),
            //   ],
            // )
          ],
        ));
  }

  Widget _buildCallButton(IconData iconDate) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Colors.white.withOpacity(0.3)),
      child: Icon(
        iconDate,
        color: Colors.white,
        size: 25,
      ),
    );
  }
}
