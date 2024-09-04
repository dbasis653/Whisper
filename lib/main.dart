import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whisper_connect/screens/chat_screen.dart';
import 'package:whisper_connect/screens/splash_screen.dart';
import 'package:whisper_connect/screens/auth.dart';
import 'package:whisper_connect/screens/all_chats.dart';
import 'package:whisper_connect/screens/all_users.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0097b2),
            primary: const Color(0xFF0097b2)),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            if (snapshot.hasData) {
              return AllUsers();
            }

            return const AuthScreen();
          }),
    );
  }
}
