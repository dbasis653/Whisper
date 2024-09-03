import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});
  final void Function(File image) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? selectedImageFile;
  void clickImage() async {
    final clickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 100);

    if (clickedImage != null) {
      setState(() {
        selectedImageFile = File(clickedImage.path);
        widget.onPickImage(selectedImageFile!);
      });
    }
    // else {
    //   setState(() {
    //     selectedImageFile = File('assets/images/user_default_dp.jpg');
    //     widget.onPickImage(selectedImageFile!);
    //   });
    // }
  }

  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 100);

    if (pickedImage != null) {
      setState(() {
        selectedImageFile = File(pickedImage.path);
        widget.onPickImage(selectedImageFile!);
      });
    }
    // else {
    //   setState(() {
    //     selectedImageFile ??= File('assets/images/default_dp.jpg');
    //     widget.onPickImage(selectedImageFile!);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              selectedImageFile != null ? FileImage(selectedImageFile!) : null,
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            const Spacer(),
            IconButton(
              onPressed: clickImage,
              icon: FaIcon(
                FontAwesomeIcons.camera,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 40,
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            IconButton(
              onPressed: pickImage,
              icon: FaIcon(
                FontAwesomeIcons.image,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 40,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
