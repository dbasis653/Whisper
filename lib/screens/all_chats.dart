import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:whisper_connect/providers/all_chats_provider.dart';

import 'package:whisper_connect/screens/all_users.dart';

class AllChats extends ConsumerStatefulWidget {
  const AllChats({super.key});

  @override
  ConsumerState<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends ConsumerState<AllChats> {
  @override
  void initState() {
    super.initState();
    getUsername();
  }

  final firebaseFirestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  String username = '';
  List allChatrooms = [];

  void getUsername() async {
    final currentUserDoc =
        await firebaseFirestore.collection('users').doc(currentUser!.uid).get();

    setState(() {
      username = currentUserDoc['username'];
    });
  }

  List<Map> receiverUsernameList = [];

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> allChatsStream =
        FirebaseFirestore.instance.collection('chat_room').snapshots();

    return StreamBuilder(
      stream: allChatsStream,
      builder: (context, allChatSnapshot) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          appBar: AppBar(
            backgroundColor: const Color(0xFF0097b2),
            title: Text(username),
            actions: [
              IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AllUsers(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: ListView.builder(
              // itemCount: allChatroomList.length,
              itemCount: receiverUsernameList.length,
              itemBuilder: (context, index) => Card(
                    child: Text(
                      receiverUsernameList[index]['receiver_username']
                          .toString(),
                    ),
                  )),
        );
      },
    );
  }
}
