import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
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

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'message': enteredMessage,
      'userId': user.uid,
      'createdAt': Timestamp.now(),
      'username': userData.data()!['username'],
      'userImage': userData.data()!['imageUrl'],
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
