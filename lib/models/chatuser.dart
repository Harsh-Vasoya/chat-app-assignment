import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  final String senderId;
  final String receiverId;
  final String roomid;
  final List members;
  final DateTime lastMessageTime;
  final String lastText;

  const ChatUser(
      {
        required this.senderId,
        required this.receiverId,
        required this.roomid,
        required this.members,
        required this.lastMessageTime,
        required this.lastText,
      });

  static ChatUser fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ChatUser(
      roomid: snapshot["roomid"],
      senderId: snapshot["senderId"],
      receiverId: snapshot["receiverId"],
      members: snapshot["members"],
      lastMessageTime: snapshot["lastMessageTime"],
      lastText: snapshot["lastText"],
    );
  }

  Map<String, dynamic> toJson() => {
    "roomid": roomid,
    "senderId": senderId,
    "receiverId": receiverId,
    "members": members,
    "lastMessageTime": lastMessageTime,
    "lastText": lastText,
  };
}

class ApproachChatUser {
  final String senderId;
  final String receiverId;
  final String roomid;
  final List members;
  final DateTime lastMessageTime;
  final String lastText;
  final String clubId;

  const ApproachChatUser(
      {
        required this.senderId,
        required this.receiverId,
        required this.roomid,
        required this.members,
        required this.lastMessageTime,
        required this.lastText,
        required this.clubId,
      });

  static ApproachChatUser fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ApproachChatUser(
      roomid: snapshot["roomid"],
      senderId: snapshot["senderId"],
      receiverId: snapshot["receiverId"],
      members: snapshot["members"],
      lastMessageTime: snapshot["lastMessageTime"],
      lastText: snapshot["lastText"],
      clubId: snapshot['clubId'],
    );
  }

  Map<String, dynamic> toJson() => {
    "roomid": roomid,
    "senderId": senderId,
    "receiverId": receiverId,
    "members": members,
    "lastMessageTime": lastMessageTime,
    "lastText": lastText,
    "clubId": clubId,
  };
}
