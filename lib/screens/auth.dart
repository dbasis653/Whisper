import 'package:flutter/material.dart';

// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:whisper_connect/widgets/auth/my_login_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  void convertIsLoginToFalse() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0097b2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            if (isLogin) Image.asset('assets/images/connect.png'),
            if (!isLogin)
              SizedBox(
                height: 300,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/connect.png',
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 10),
            MyLoginForm(
              isLogin: isLogin,
              convertIsLogin: convertIsLoginToFalse,
            ),
          ],
        ),
      ),
    );
  }
}
