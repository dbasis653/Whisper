import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages(
      {super.key, required this.receivingUser, required this.charoomId});
  final dynamic receivingUser;
  final String charoomId;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat_room')
          .doc(charoomId)
          .collection('messages')
          .orderBy(
            'createdAt',
            descending: false,
          )
          .snapshots(),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No message'),
          );
        }

        if (chatSnapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        final loadedMessages = chatSnapshot.data!.docs;

        return ListView.builder(
            padding:
                const EdgeInsets.only(bottom: 30, left: 15, right: 15, top: 15),
            itemCount: loadedMessages.length,
            itemBuilder: (context, index) {
              bool isCurrentUser = currentUser!.uid ==
                  chatSnapshot.data!.docs[index]['receiverId'];

              Alignment alignment =
                  isCurrentUser ? Alignment.centerLeft : Alignment.centerRight;
              return Container(
                alignment: alignment,
                child: Text(
                  loadedMessages[index].data()['message'],
                ),
              );
            });
      },
    );
  }
}
