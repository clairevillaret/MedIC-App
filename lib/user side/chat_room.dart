import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  late final Map<String, dynamic> userMap;
  late final String chatRoomId;

  //ChatRoom({this.chatRoomId, this.userMap});

  final messageController = TextEditingController();
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFFba181b),
          leading: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.arrow_back),
            iconSize: 25.0,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text("Message",
            style: TextStyle(
              fontSize: 20.0,
              letterSpacing: 2.0,
            ),
          )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.25,
              width: size.width,
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height / 17,
                      width: size.width / 1.3,
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: "Send message",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.send),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}


