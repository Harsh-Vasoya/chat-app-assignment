import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:chat_app_assignment/resources/auth_methods.dart';
import 'package:chat_app_assignment/models/user.dart' as usr;

class UserProvider with ChangeNotifier {
  usr.User? _user;
  final AuthMethods _authMethods = AuthMethods();

  usr.User get getUser => _user!;

  Future<void> refreshUser() async {
    usr.User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

  //Get User by Uid
  Future<DocumentSnapshot?> getUserByUid(String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return snapshot.exists ? snapshot : null;
    } catch (error) {
      return null;
    }
  }

  //Return UserRoomId
  Future<String> getUserRoomIdByUid(String senderId, String receiverId) async {
    try {
      final snapshot1 = await FirebaseFirestore.instance.collection('chats').where('senderId', isEqualTo: senderId).where('receiverId', isEqualTo: receiverId).get();
      if (snapshot1.docs.isNotEmpty) {
        QueryDocumentSnapshot<Map<String, dynamic>> document = snapshot1.docs.first;
        return document.id;
      } else {
        final snapshot2 = await FirebaseFirestore.instance.collection('chats').where('senderId', isEqualTo: receiverId).where('receiverId', isEqualTo: senderId).get();
        if (snapshot2.docs.isNotEmpty) {
          QueryDocumentSnapshot<Map<String, dynamic>> document = snapshot2.docs.first;
          return document.id;
        }else{
          return "empty";
        }
      }
    } catch (error) {
      return error.toString();
    }
  }
}