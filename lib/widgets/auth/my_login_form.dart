import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:whisper_connect/widgets/auth/form_buttons.dart';
import 'package:whisper_connect/widgets/auth/login_form_text_field.dart';
import 'package:whisper_connect/widgets/auth/user_image_picker.dart';

final formKey = GlobalKey<FormState>();

final firebase = FirebaseAuth.instance;

class MyLoginForm extends StatefulWidget {
  const MyLoginForm(
      {super.key, required this.isLogin, required this.convertIsLogin});
  final bool isLogin;
  final void Function() convertIsLogin;

  @override
  State<MyLoginForm> createState() => _MyLoginFormState();
}

class _MyLoginFormState extends State<MyLoginForm> {
  late bool isLoginActive;

  String inputEmail = '';
  String inputPassword = '';
  File? inputImage;
  bool isAuthenticating = false;

  @override
  void initState() {
    isLoginActive = widget.isLogin;
    super.initState();
  }

  void submit() async {
    // UserCredential userCredentials;
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      formKey.currentState!.save();
    }

    setState(() {
      isAuthenticating = true;
    });

    if (isLoginActive) {
      try {
        final userCredentials = await firebase.signInWithEmailAndPassword(
            email: inputEmail, password: inputPassword);
        print(userCredentials);
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Invalis Credentials'),
          ),
        );

        setState(() {
          isAuthenticating = true;
        });
      }
    } else {
      try {
        final userCredentials = await firebase.createUserWithEmailAndPassword(
            email: inputEmail, password: inputPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(inputImage!);
        final imageUrl = await storageRef.getDownloadURL();

        print('Image name : $storageRef');
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication failed'),
          ),
        );

        setState(() {
          isAuthenticating = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void toogleIsLoginActive() {
      setState(() {
        isLoginActive = !isLoginActive;
      });
      widget.convertIsLogin();
    }

    return Padding(
      padding: const EdgeInsets.only(
        right: 15,
        left: 15,
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            if (!isLoginActive)
              UserImagePicker(
                onPickImage: (imageFile) => inputImage = imageFile,
              ),
            LoginFormTextField(
              title: 'E-mail address',
              onSavingTextField: (value) {
                inputEmail = value;
              },
            ),
            const SizedBox(height: 5),
            LoginFormTextField(
              title: 'Password',
              onSavingTextField: (value) {
                inputPassword = value;
              },
            ),
            const SizedBox(height: 15),
            if (!isAuthenticating)
              FormButtons(
                title: isLoginActive ? 'Login' : 'Signup',
                onClickButton: submit,
              ),
            if (!isAuthenticating) const SizedBox(height: 15),
            if (!isAuthenticating)
              FormButtons(
                title: isLoginActive ? 'Create an account' : 'Login',
                onClickButton: toogleIsLoginActive,
              ),
            if (isAuthenticating)
              SpinKitRotatingCircle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              )
          ],
        ),
      ),
    );
  }
}
