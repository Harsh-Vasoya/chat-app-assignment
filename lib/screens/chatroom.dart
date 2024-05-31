import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_assignment/providers/user_provider.dart';
import 'package:chat_app_assignment/screens/profile_details.dart';
import 'package:chat_app_assignment/utils/colors.dart';
import 'package:chat_app_assignment/utils/utils.dart';
import 'package:chat_app_assignment/widgets/chat_text_field.dart';
import 'package:chat_app_assignment/widgets/chatmessages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatRoom extends StatefulWidget {
  final String text;
  final String photoUrl;
  final String userId;
  final String username;
  const ChatRoom({super.key, required this.photoUrl,required this.userId, required this.username, required this.text,});


  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  bool isLoading = false;
  var userData = {};
  String roomid = '';

  getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final id = await userProvider.getUserRoomIdByUid(FirebaseAuth.instance.currentUser!.uid, widget.userId);
      setState(() {
        roomid = id;
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, 'Some error Occurred',);
    }
  }


  @override
  void initState() {
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
      return isLoading?
      const Center(
        child: CircularProgressIndicator(color: primaryColor),
      ): SafeArea(
        child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              foregroundColor: primaryColor,
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileDetails(uid: widget.userId))),
                    child: CircleAvatar(
                      backgroundImage:
                      CachedNetworkImageProvider(widget.photoUrl),
                      radius: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      Text(
                        widget.username,
                        style: appbarFont,
                      ),
                    ],
                  ),
                ],
              )
          ),
          body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ChatMessages(receiverid: widget.userId, roomid: roomid),
                  ChatTextField(receiverId: widget.userId),
                ],
              ),
            ),
          ),
      );
    }
  }