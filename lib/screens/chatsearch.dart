import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_assignment/providers/user_provider.dart';
import 'package:chat_app_assignment/screens/chatroom.dart';
import 'package:chat_app_assignment/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatSearch extends StatefulWidget {
  const ChatSearch({super.key});

  @override
  State<ChatSearch> createState() =>
      _ChatSearchState();
}

class _ChatSearchState extends State<ChatSearch> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Form(
            child: TextFormField(
              controller: controller,
              decoration:
              InputDecoration(icon: const Icon(Icons.search_rounded, size: 20, color: primaryColor), labelText: 'Enter username to search', labelStyle: appbarFont),
              onFieldSubmitted: (String _) {},
            ),
          ),
        ),
        body:StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').where('username', isGreaterThanOrEqualTo: controller.text, isNotEqualTo: userProvider.getUser.username).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}', style: appbarFont,),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text('Search User', style: appbarFont,),
              );
            } else if (snapshot.data!.size == 0) {
              return Center(
                child: Text('Search User', style: appbarFont,),
              );
            } else{
            return
              ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              controller: scrollController,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatRoom(
                            text: '',
                            userId: (snapshot.data! as dynamic).docs[index]['uid'],
                            username: (snapshot.data! as dynamic).docs[index]['username'],
                            photoUrl: (snapshot.data! as dynamic).docs[index]['photoUrl'],
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        (snapshot.data! as dynamic).docs[index]['photoUrl'],
                      ),
                      radius: 22,
                    ),
                    title: Text(
                      (snapshot.data! as dynamic).docs[index]['username'], style: appbarFont,
                    ),
                  ),
                );
              },
            );
            }
          },
        ),
      ),
    );
  }
}