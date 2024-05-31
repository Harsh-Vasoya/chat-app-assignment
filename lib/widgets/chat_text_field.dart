import 'dart:io';
import 'dart:typed_data';
import 'package:chat_app_assignment/providers/user_provider.dart';
import 'package:chat_app_assignment/resources/firestore_methods.dart';
import 'package:chat_app_assignment/responsive/mobile_screen_layout.dart';
import 'package:chat_app_assignment/utils/colors.dart';
import 'package:chat_app_assignment/utils/utils.dart';
import 'package:chat_app_assignment/widgets/text_field_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class ChatTextField extends StatefulWidget {
  final String receiverId;
  const ChatTextField({super.key, required this.receiverId});

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final TextEditingController controller = TextEditingController();
  bool firstTime = false;

  Future<String> _sendText(BuildContext context) async {
    String res = 'Some error occurred';
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final roomid = await userProvider.getUserRoomIdByUid(FirebaseAuth.instance.currentUser!.uid, widget.receiverId);
      if (controller.text.isNotEmpty) {
        if (roomid != 'empty') {}
        else {
          await FireStoreMethods.addchatusers(receiverId: widget.receiverId, senderId: FirebaseAuth.instance.currentUser!.uid);
          setState(() {
            firstTime = true;
          });
        }
        final roomidcreated = await userProvider.getUserRoomIdByUid(FirebaseAuth.instance.currentUser!.uid, widget.receiverId);
        if (roomidcreated != 'empty') {
          await FireStoreMethods.addTextMessage(
            receiverId: widget.receiverId,
            senderId: FirebaseAuth.instance.currentUser!.uid,
            text: controller.text,
            roomId: roomidcreated,
          );
          await FireStoreMethods.updatelastMessage(roomidcreated, controller.text);
        }
        controller.clear();
      } else {
        // ignore: use_build_context_synchronously
        FocusScope.of(context).unfocus();
      }
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> _sendPhotoMedia(BuildContext context, String mediaType, Uint8List file) async {
    String res = 'Some error occurred';
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final roomid = await userProvider.getUserRoomIdByUid(FirebaseAuth.instance.currentUser!.uid, widget.receiverId);
      if (roomid != 'empty') {
      } else {
        await FireStoreMethods.addchatusers(receiverId: widget.receiverId, senderId: FirebaseAuth.instance.currentUser!.uid);
        setState(() {
          firstTime = true;
        });
      }
      final roomidcreated = await userProvider.getUserRoomIdByUid(FirebaseAuth.instance.currentUser!.uid, widget.receiverId);
      if (roomidcreated != 'empty') {
        await FireStoreMethods.addPhotoMessage(
          receiverId: widget.receiverId,
          senderId: FirebaseAuth.instance.currentUser!.uid,
          text: '',
          roomId: roomidcreated,
          file: file
        );
        await FireStoreMethods.updatelastMessage(roomidcreated, 'Media message');
      }
      controller.clear();
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> _sendVideoMedia(BuildContext context, String mediaType, String videoPath) async {
    String res = 'Some error occurred';
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final roomid = await userProvider.getUserRoomIdByUid(FirebaseAuth.instance.currentUser!.uid, widget.receiverId);
      if (roomid != 'empty') {
      } else {
        await FireStoreMethods.addchatusers(receiverId: widget.receiverId, senderId: FirebaseAuth.instance.currentUser!.uid);
        setState(() {
          firstTime = true;
        });
      }
      final roomidcreated = await userProvider.getUserRoomIdByUid(FirebaseAuth.instance.currentUser!.uid, widget.receiverId);
      if (roomidcreated != 'empty') {
        await FireStoreMethods.addVideoMessage(
            receiverId: widget.receiverId,
            senderId: FirebaseAuth.instance.currentUser!.uid,
            text: '',
            roomId: roomidcreated,
            videoPath: videoPath
        );
        await FireStoreMethods.updatelastMessage(roomidcreated, 'Media message');
      }
      controller.clear();
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> _sendDocumentMedia(BuildContext context, String mediaType, File file) async {
    String res = 'Some error occurred';
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final roomid = await userProvider.getUserRoomIdByUid(FirebaseAuth.instance.currentUser!.uid, widget.receiverId);
      if (roomid != 'empty') {
      } else {
        await FireStoreMethods.addchatusers(receiverId: widget.receiverId, senderId: FirebaseAuth.instance.currentUser!.uid);
        setState(() {
          firstTime = true;
        });
      }
      final roomidcreated = await userProvider.getUserRoomIdByUid(FirebaseAuth.instance.currentUser!.uid, widget.receiverId);
      if (roomidcreated != 'empty') {
        await FireStoreMethods.addDocumentMessage(
            receiverId: widget.receiverId,
            senderId: FirebaseAuth.instance.currentUser!.uid,
            text: '',
            roomId: roomidcreated,
            file: file
        );
        await FireStoreMethods.updatelastMessage(roomidcreated, 'Media message');
      }
      controller.clear();
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Uint8List imageData = await pickedFile.readAsBytes();
      // ignore: use_build_context_synchronously
      String res = await _sendPhotoMedia(context, 'image', imageData);
      if (res == 'success') {
        if (firstTime == true) {
          if (context.mounted) {
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const MobileScreenLayout(),
                ),
                    (route) => false);
          }
        }
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Failed to Send Message!');
      }
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      // ignore: use_build_context_synchronously
      String res = await _sendVideoMedia(context, 'video', pickedFile.path);
      if (res == 'success') {
        if (firstTime == true) {
          if (context.mounted) {
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const MobileScreenLayout(),
                ),
                    (route) => false);
          }
        }
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Failed to Send Message!');
      }
    }
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc']);
    if (result != null && result.files.single.path != null) {
      // ignore: use_build_context_synchronously
      String res = await _sendDocumentMedia(context, 'doc', File(result.files.single.path!));
      if (res == 'success') {
        if (firstTime == true) {
          if (context.mounted) {
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const MobileScreenLayout(),
                ),
                    (route) => false);
          }
        }
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Failed to Send Message!');
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Add Message...',
                hintStyle: const TextStyle(fontSize: 12),
                border: inputborder(),
                focusedBorder: inputborder(),
                enabledBorder: inputborder(),
                filled: true,
                contentPadding: const EdgeInsets.all(8),
              ),
            ),
          ),
          const SizedBox(width: 5),
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'Image') {
                _pickImage();
              } else if (value == 'Video') {
                _pickVideo();
              } else if (value == 'Document') {
                _pickDocument();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Image',
                child: Text('Send Image'),
              ),
              const PopupMenuItem<String>(
                value: 'Video',
                child: Text('Send Video'),
              ),
              const PopupMenuItem<String>(
                value: 'Document',
                child: Text('Send Document'),
              ),
            ],
            icon: const Icon(Icons.attach_file),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            backgroundColor: greenColor,
            radius: 20,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () async {
                String res = await _sendText(context);
                if (res == 'success') {
                  if (firstTime == true) {
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const MobileScreenLayout(),
                          ),
                              (route) => false);
                    }
                  }
                } else {
                  // ignore: use_build_context_synchronously
                  showSnackBar(context, 'Failed to Send Message!');
                }
              },
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
    ],
  );
}