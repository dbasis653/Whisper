import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
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

        // final userMessageData = FirebaseFirestore.instance.collection('chat');
        final loadedMessages = chatSnapshot.data!.docs;

        return ListView.builder(
          padding:
              const EdgeInsets.only(bottom: 30, left: 15, right: 15, top: 15),
          // reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (context, index) => Text(
            loadedMessages[index].data()['message'],
          ),
        );
      },
    );
  }
}
