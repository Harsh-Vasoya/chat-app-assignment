import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_assignment/screens/chatroom.dart';
import 'package:chat_app_assignment/screens/profile_details.dart';
import 'package:chat_app_assignment/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatCard extends StatefulWidget {
  final DocumentSnapshot snap;
  final String uid;
  const ChatCard({super.key, required this.snap, required this.uid});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(widget.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(),
          );
        } else if (snapshot.hasError){
          return Center(
            child: Text('Error: ${snapshot.error}', style: appbarFont,),
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: Text('User Not Found', style: appbarFont,),
          );
        } else
        {
          return ListTile(
            leading: GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileDetails(uid: widget.uid))),
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(snapshot.data!['photoUrl']),
                radius: 22,
              ),
            ),
            title: GestureDetector(
              onTap: () =>
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatRoom(
                            text: '',
                            userId: widget.uid,
                            photoUrl: snapshot.data!['photoUrl'],
                            username: snapshot.data!['username'],
                          ),
                    ),
                  ),
              child: Text(
                snapshot.data!['username'],
                style: appbarFont,
              ),
            ),
            subtitle: Text(
              widget.snap['lastText'],
              style: subtitleFont,
            ),
            trailing: GestureDetector(
              onTap: () =>
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatRoom(
                            text: '',
                            userId: widget.uid,
                            photoUrl: snapshot.data!['photoUrl'],
                            username: snapshot.data!['username'],
                          ),
                    ),
                  ),
              child: Text(
                DateFormat.yMMMd().format(
                  widget.snap['lastMessageTime'].toDate(),
                ),
                style: const TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w400,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
