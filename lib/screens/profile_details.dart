import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_assignment/utils/colors.dart';

class ProfileDetails extends StatefulWidget {
  final String uid;
  const ProfileDetails({super.key, required this.uid});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {

  var userData = {};
  bool isLoading = false;

  void getData() async{
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot<Map<String, dynamic>> userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();

    if(userSnap.exists){
      userData = userSnap.data() as Map<String, dynamic>;
      setState(() {
        isLoading = false;
      });
    }
  }

 @override
 void initState(){
   super.initState();
   getData();
 }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Profile Details", style: appbarFont,),
      ),
      body: SafeArea(
        child: isLoading?
        const Center(child: CircularProgressIndicator(color: primaryColor,),):
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 24,
              ),
              CircleAvatar(
                radius: 64,
                backgroundImage: NetworkImage(userData['photoUrl']),
                backgroundColor: Colors.grey,
              ),
              const SizedBox(
                height: 24,
              ),
              ListTile(
                leading: Text('Username:  ${userData['username']}', style: appbarFont,),
              ),
              ListTile(
                leading: Text('Email:  ${userData['email']}', style: appbarFont,),
              ),
              ListTile(
                leading: Text('Bio:  ${userData['bio']}', style: appbarFont,),
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
