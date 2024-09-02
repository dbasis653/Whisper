import 'package:flutter/material.dart';

class FormButtons extends StatelessWidget {
  const FormButtons({super.key, required this.title, this.onClickButton});
  final String title;
  final void Function()? onClickButton;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(8),
        backgroundColor: const WidgetStatePropertyAll(
          Color(0xFF0097b2),
        ),
        shadowColor: WidgetStatePropertyAll(
          Colors.blue.shade900,
        ),
      ),
      onPressed: onClickButton,
      child: Text(
        title,
        style:
            TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
    );
  }
}
