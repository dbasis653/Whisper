import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:whisper_connect/providers/all_chats_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewMessage extends ConsumerStatefulWidget {
  const NewMessage(
      {super.key, required this.receivingUser, required this.charoomId});
  final dynamic receivingUser;
  final String charoomId;

  @override
  ConsumerState<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends ConsumerState<NewMessage> {
  final messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void submitMessage() async {
    final enteredMessage = messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    messageController.clear();
    FocusScope.of(context).unfocus();

    final currentUser = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    FirebaseFirestore.instance
        .collection('chat_room')
        .doc(widget.charoomId)
        .collection('messages')
        .add({
      'userId': currentUser.uid,
      'receiverId': widget.receivingUser.id,
      'receiverUsername': widget.receivingUser['username'],
      'chatroomId': widget.charoomId,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['imageUrl'],
      'message': enteredMessage,
      'createdAt': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              autocorrect: false,
              enableSuggestions: true,
              decoration: InputDecoration(
                label: Text(
                  'Send a message',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                focusColor: Theme.of(context).colorScheme.onPrimary,
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 2),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 2),
                ),
              ),
            ),
          ),
          IconButton(onPressed: submitMessage, icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
