import 'dart:io';

import 'package:chat_app_assignment/models/chatuser.dart';
import 'package:chat_app_assignment/models/message.dart';
import 'package:chat_app_assignment/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {

  //Add Text Messages
  static Future<String> addTextMessage({required String text, required String receiverId, required String senderId, required String roomId}) async {
    String res = "Some error occurred";
    try{
      if(text.isNotEmpty){
        String messageId = const Uuid().v1();
        final message = Message(
            text: text,
            sentTime: DateTime.now(),
            receiverId: receiverId,
            senderId: senderId,
            messageId: messageId,
            isMediaPresent: false,
          mediaType: '',
          photoUrl: '',
          videoUrl: '',
          thumbnailUrl: '',
          documentUrl: ''
        );
        await _addMessageToChat(roomId, message, messageId);
        res='success';
      }
      else {
        res = "Please enter text";
      }
    }
    catch(err){
      res= err.toString();
    }
    return res;
  }

  //Add Photo Messages
  static Future<String> addPhotoMessage({required Uint8List file, required String text, required String receiverId, required String senderId, required String roomId}) async {
    String res = "Some error occurred";
    try{
      String messageId = const Uuid().v1();
      String imageId = const Uuid().v1();
      String photoUrl = await StorageMethods().uploadChatImageToStorage('chats', file, imageId, roomId);

      final message = Message(
          text: text,
          sentTime: DateTime.now(),
          receiverId: receiverId,
          senderId: senderId,
          messageId: messageId,
          isMediaPresent: true,
          mediaType: 'image',
          photoUrl: photoUrl,
          videoUrl: '',
          thumbnailUrl: '',
        documentUrl: ''
      );
      await _addMessageToChat(roomId, message, messageId);
      res='success';
    }
    catch(err){
      res= err.toString();
    }
    return res;
  }

  //Add Video Messages
  static Future<String> addVideoMessage({required String videoPath, required String text, required String receiverId, required String senderId, required String roomId}) async {
    String res = "Some error occurred";
    try{
      String messageId = const Uuid().v1();
      String videoId = const Uuid().v1();
      String videoUrl = await StorageMethods().uploadChatVideoToStorage('chats', videoPath, videoId, roomId);
      //String thumbnailUrl = await StorageMethods().uploadChatThumbnailToStorage('chats', videoPath, videoId, roomId);
      String thumbnailUrl = 'https://static.vecteezy.com/system/resources/thumbnails/007/126/491/small/music-play-button-icon-vector.jpg';

      final message = Message(
          text: text,
          sentTime: DateTime.now(),
          receiverId: receiverId,
          senderId: senderId,
          messageId: messageId,
          isMediaPresent: true,
          mediaType: 'video',
          photoUrl: '',
          videoUrl: videoUrl,
          thumbnailUrl: thumbnailUrl,
        documentUrl: '',
      );
      await _addMessageToChat(roomId, message, messageId);
      res='success';
    }
    catch(err){
      res= err.toString();
    }
    return res;
  }

  //Add Document Messages
  static Future<String> addDocumentMessage({required File file, required String text, required String receiverId, required String senderId, required String roomId}) async {
    String res = "Some error occurred";
    try{
      String messageId = const Uuid().v1();
      String documentId = const Uuid().v1();
      String documentUrl = await StorageMethods().uploadFile('chats', file, roomId, documentId);

      final message = Message(
        text: text,
        sentTime: DateTime.now(),
        receiverId: receiverId,
        senderId: senderId,
        messageId: messageId,
        isMediaPresent: true,
        mediaType: 'document',
        photoUrl: '',
        videoUrl: '',
        thumbnailUrl: '',
        documentUrl: documentUrl,
      );
      await _addMessageToChat(roomId, message, messageId);
      res='success';
    }
    catch(err){
      res= err.toString();
    }
    return res;
  }



  static Future<void> _addMessageToChat(String roomid, Message message, String messageId) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(roomid)
        .collection('messages')
        .doc(messageId)
        .set(message.toJson());
  }

  //Add Chat Users
  static Future<String> addchatusers({required String receiverId, required String senderId}) async {
    String res = "Some error occurred";
    try {
      String roomid = const Uuid().v1(); //Creates unique id based on time

      ChatUser chatdetails = ChatUser(
        roomid: roomid,
        senderId: senderId,
        receiverId: receiverId,
        members: [receiverId, senderId],
        lastMessageTime: DateTime.now(),
        lastText: "",
      );

      await _addchatusers(roomid, chatdetails);
      res ='success';
    }
    catch(err){
      res= err.toString();
    }
    return res;
  }
  static Future<void> _addchatusers(String roomid, ChatUser chatdetails) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(roomid)
        .set(chatdetails.toJson());
  }

  //Update the last Text Message
  static Future<void> updatelastMessage(String roomId, String lastText) async {
    DateTime newDate = DateTime.now();
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(roomId)
        .update({'lastMessageTime': newDate});

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(roomId)
        .update({'lastText': lastText});
  }
}
