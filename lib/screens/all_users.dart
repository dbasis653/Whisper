import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:whisper_connect/screens/chat_screen.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic loadedUsers;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AllUsers(),
                ),
              );
            },
            icon: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, userSnapshot) {
          final currentUser = FirebaseAuth.instance.currentUser;

          if (userSnapshot.connectionState == ConnectionState.waiting) {
            Center(
              child: SpinKitRotatingCircle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            );
          }

          if (userSnapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Check if the snapshot has data
          if (!userSnapshot.hasData || userSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No users found.'),
            );
          }

          loadedUsers = userSnapshot.data!.docs
              .where((m) => m.id != currentUser!.uid)
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            itemCount: loadedUsers.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    receivingUser: loadedUsers[index],
                    currentUser: currentUser,
                  ),
                ),
              ),
              child: Card(
                color: Theme.of(context)
                    .colorScheme
                    .onSecondaryContainer
                    .withOpacity(0.8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    
                    title: Text(
                      loadedUsers[index].data()['username'],
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.surfaceContainer),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
