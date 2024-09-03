import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String inputUsername = '';
  File? inputImage;
  bool isAuthenticating = false;

  @override
  void initState() {
    isLoginActive = widget.isLogin;
    super.initState();
  }

  void submit() async {
    print('Submit starts here...');
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
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Invalis Credentials'),
          ),
        );

        setState(() {
          isAuthenticating = false;
        });
      }
    } else {
      try {
        if (inputImage == null) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No Profile Picture Selected')));

          // setState(() {
          //   isAuthenticating = false;
          // });
          // return;
        }

        final userCredentials = await firebase.createUserWithEmailAndPassword(
            email: inputEmail, password: inputPassword);

        if (inputImage == null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredentials.user!.uid)
              .set({
            'email': inputEmail,
            'password': inputPassword,
            'imageUrl': '',
            // 'imageUrl': inputImage != null ? imageUrl : null,
            'username': inputUsername,
          });
        }

        if (inputImage != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child('${userCredentials.user!.uid}.jpg');

          await storageRef.putFile(inputImage!);
          final imageUrl = await storageRef.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredentials.user!.uid)
              .set({
            'email': inputEmail,
            'password': inputPassword,
            'imageUrl': imageUrl,
            // 'imageUrl': inputImage != null ? imageUrl : null,
            'username': inputUsername,
          });
        }

        print('Files saved in database...');
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication failed'),
          ),
        );

        setState(() {
          isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void toogleIsLoginActive() {
      setState(() {
        isLoginActive = !isLoginActive;
        formKey.currentState!.reset();
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
                // onPickImage: (imageFile) =>  inputImage = imageFile,
                onPickImage: (image) {
                  inputImage = image;
                  print('Image is picked...');
                },
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
            if (!isLoginActive) const SizedBox(height: 15),
            if (!isLoginActive)
              LoginFormTextField(
                  title: 'Username',
                  onSavingTextField: (value) {
                    inputUsername = value;
                  }),
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
