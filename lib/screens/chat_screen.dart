import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whisper_connect/widgets/chat/chat_messages.dart';
import 'package:whisper_connect/widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen(
      {super.key, required this.receivingUser, required this.currentUser});
  final dynamic receivingUser;
  final dynamic currentUser;

  @override
  Widget build(BuildContext context) {
    final ids = [currentUser.uid, receivingUser.id];
    ids.sort();
    final chatroomId = ids.join('_');
    // print('CurrentUser id: ${currentUser.uid}');
    // print('receivingUser id: ${receivingUser.id}');

    return Scaffold(
      backgroundColor: const Color(0xFF0097b2),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(receivingUser['username']),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout_sharp))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessages(
              charoomId: chatroomId,
              receivingUser: receivingUser,
            ),
          ),
          NewMessage(
            charoomId: chatroomId,
            receivingUser: receivingUser,
          ),
        ],
      ),
    );
  }
}
