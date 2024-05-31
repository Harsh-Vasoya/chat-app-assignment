import 'package:chat_app_assignment/resources/auth_methods.dart';
import 'package:chat_app_assignment/screens/chatsearch.dart';
import 'package:chat_app_assignment/screens/login_screen.dart';
import 'package:chat_app_assignment/utils/colors.dart';
import 'package:chat_app_assignment/widgets/chat_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key,});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}


class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final ScrollController scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text('Chats', style: pageTitleFont),
          actions: [
            IconButton(
              onPressed: () =>
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) =>
                      const ChatSearch())),
              icon: const Icon(Icons.search_rounded,
                  color: primaryColor, size: 24),
            ),
            IconButton(
              onPressed: () async {
                await AuthMethods().signOut();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false);
                }
              },
              icon: const Icon(Icons.exit_to_app_rounded,
                  color: primaryColor, size: 24),
            )
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('chats').where('members', arrayContains: FirebaseAuth.instance.currentUser!.uid).orderBy('lastMessageTime', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}', style: appbarFont,),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text('Search users and start chatting.', style: appbarFont,),
              );
            } else if (snapshot.data!.size == 0) {
              return Center(
                child: Text('Search users and start chatting.', style: appbarFont,),
              );
            } else{
              return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    DocumentSnapshot user = snapshot.data!.docs[index];
                    String uid = "";
                    if(user["senderId"] == FirebaseAuth.instance.currentUser!.uid){
                      uid = user["receiverId"];
                    }else{
                      uid = user["senderId"];
                    }
                    return ChatCard(snap: snapshot.data!.docs[index], uid: uid);
                  }
              );
            }
          },
        ),
      ),
    );
  }
}