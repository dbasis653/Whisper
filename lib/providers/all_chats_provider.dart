import 'package:riverpod/riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

class AllChatProviderNotifier extends StateNotifier<List<Map>> {
  AllChatProviderNotifier() : super([]);

  final firebaseFirestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;

  void initiateList() async {
    final firestoreChatroomList =
        await firebaseFirestore.collection('chat_room').get();

    List<Map<String, String>> tempState = [];

    for (var doc in firestoreChatroomList.docs) {
      var firestoreMessageList =
          await doc.reference.collection('messages').get();

      for (var messageDoc in firestoreMessageList.docs) {
        tempState.add(
          {
            'chat_room_id': doc.id, // Use the chat_room document ID
            // 'receiver_id': messageDoc['receiverId'],
            'receiver_username': messageDoc['receiverUsername'],
          },
        );
      }
    }

    state = tempState;
  }

  void addChatRoomsAndReceiverUser(String chatRoomId, String username) {
    final existingUser =
        state.where((chat) => chat['chat_room_id'] == chatRoomId);
    if (existingUser.isEmpty) {
      state = [
        ...state,
        {
          'chat_room_id': chatRoomId,
          // 'receiver_id': receiverUser,
          'receiver_username': username,
        }
      ];
    }
  }
}

final allChatProvider =
    StateNotifierProvider<AllChatProviderNotifier, List<Map>>(
        (ref) => AllChatProviderNotifier());
