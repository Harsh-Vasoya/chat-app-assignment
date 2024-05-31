import 'package:chat_app_assignment/utils/colors.dart';
import 'package:chat_app_assignment/widgets/chatbubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ChatMessages extends StatefulWidget {
  final String receiverid;
  final String roomid;
  const ChatMessages({super.key, required this.receiverid, required this.roomid});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
final ScrollController _scrollController = ScrollController();

void scrollToLastMessage() {
  _scrollController.animateTo(
    _scrollController.position.maxScrollExtent,
    duration: const Duration(milliseconds: 100),
    curve: Curves.easeInOut,
  );
}

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('chats').doc(widget.roomid).collection('messages').orderBy('sentTime', descending: false).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: primaryColor));
            }
            else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}', style: appbarFont,),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text('Say Hello!'),
              );
            } else if (snapshot.data!.size == 0) {
              return  const Center(
                child: Text('Say Hello!'),
              );
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                scrollToLastMessage();
              });
              return ListView.builder(
                itemCount: (snapshot.data! as dynamic).docs.length,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  final isMe = widget.receiverid == (snapshot.data! as dynamic).docs[index]['senderId'];
                  return ChatBubble(
                    isMe: isMe,
                    message: (snapshot.data! as dynamic).docs[index],
                  );
                },
              );
            }
          },
      ),
    );
  }
}
