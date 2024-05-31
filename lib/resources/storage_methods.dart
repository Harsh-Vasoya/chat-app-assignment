import 'dart:io';
import 'dart:typed_data';

//import 'package:video_compress/video_compress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';



class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;


  Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPhoto) async {
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
    if(isPhoto) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadTask = ref.putData(
      file
    );

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

/*
  //Get thumbnail from video
  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }*/

  //Adding image to firebase storage for chats
  Future<String> uploadChatImageToStorage(String childName, Uint8List file, String imageId, String chatId) async {

    Reference ref = _storage.ref().child(childName).child(chatId).child(_auth.currentUser!.uid).child(imageId);
    UploadTask uploadTask = ref.putData(file
    );

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  //Adding video to firebase storage for chat
  Future<String> uploadChatVideoToStorage(String childName, String videoPath, String videoId, String chatId) async {
    Reference ref = FirebaseStorage.instance.ref().child(childName).child(chatId).child(_auth.currentUser!.uid).child('videos').child(videoId);
    final File videoFile = File(videoPath);
    UploadTask uploadTask = ref.putFile(videoFile);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

/*
  //Adding video thumbnail to firebase storage for club
  Future<String> uploadChatThumbnailToStorage(String childName, String videoPath, String thumbnailId, String chatId) async {
    Reference ref = FirebaseStorage.instance.ref().child(childName).child(chatId).child(_auth.currentUser!.uid).child('thumbnails').child(thumbnailId);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }*/

  Future<String> uploadFile(String childName, File file, String chatId, String docId) async {
    final fileRef = FirebaseStorage.instance.ref().child(childName).child(chatId).child(_auth.currentUser!.uid).child('documents').child(docId);
    // Upload the file to Firebase Storage
    final uploadTask = fileRef.putFile(file);
    await uploadTask;

    // Get the download URL of the uploaded file
    final downloadUrl = await fileRef.getDownloadURL();
    return downloadUrl;
  }
}