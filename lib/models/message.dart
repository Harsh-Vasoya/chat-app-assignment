import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final String messageId;
  final DateTime sentTime;
  final bool isMediaPresent;
  final String mediaType;
  final String photoUrl;
  final String videoUrl;
  final String thumbnailUrl;
  final String documentUrl;

  const Message({
    required this.senderId,
    required this.receiverId,
    required this.sentTime,
    required this.messageId,
    required this.text,
    required this.isMediaPresent,
    required this.mediaType,
    required this.photoUrl,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.documentUrl,
  });

  static Message fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

      return Message(
        receiverId: snapshot["receiverId"],
        senderId: snapshot["senderId"],
        text: snapshot["text"],
        messageId: snapshot["messageId"],
        sentTime: snapshot["sentTime"],
        isMediaPresent: snapshot["isMediaPresent"],
        mediaType: snapshot["mediaType"],
        photoUrl: snapshot["photoUrl"],
        videoUrl: snapshot["videoUrl"],
        thumbnailUrl: snapshot["thumbnailUrl"],
        documentUrl: snapshot["documentUrl"],
      );
}

  Map<String, dynamic> toJson() => {
    "receiverId" : receiverId,
    "senderId" : senderId,
    "text" : text,
    "messageId" : messageId,
    "sentTime" : sentTime,
    "isMediaPresent": isMediaPresent,
    "mediaType": mediaType,
    "photoUrl": photoUrl,
    "videoUrl": videoUrl,
    "thumbnailUrl": thumbnailUrl,
    "documentUrl": documentUrl
  };
}