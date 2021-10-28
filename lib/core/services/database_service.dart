import 'package:cloud_firestore/cloud_firestore.dart';
import 'sharedpref_service.dart';

class DatabaseService {
  Future addUserInfoToDb(String userId, Map<String, dynamic> userInfo) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfo);
  }

  Future<QuerySnapshot> getUserByUserName(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userName", isEqualTo: username)
        .get();
    // .snapshots();
  }

  Future createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String myUsername = await SharedPreference().getUserName();
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .where("users", arrayContains: myUsername)
        .orderBy("lastMessageTs", descending: true)
        .snapshots();
  }

  Future addMessage(
      {required String chatRoomId,
      required String messageId,
      required Map<String, dynamic> messageInfoMap}) async {
    await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  Future updateLastMessage(
      String chatRoomId, Map<String, dynamic> lastmessageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastmessageInfoMap);
  }
}
