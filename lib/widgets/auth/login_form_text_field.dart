import 'package:flutter/material.dart';
// import 'package:whisper/widgets/auth/my_login_form.dart';

// final GlobalKey<FormState> formKey = GlobalKey();

class LoginFormTextField extends StatelessWidget {
  const LoginFormTextField(
      {super.key, required this.title, required this.onSavingTextField});
  final String title;
  final void Function(String value) onSavingTextField;

  @override
  Widget build(BuildContext context) {
    String? emailValidator(String? value) {
      if (value == null || value.trim().isEmpty || !value.contains('@')) {
        return 'Enter a valid E-mail address';
      }
      return null;
    }

    String? passwordValidator(String? value) {
      if (value == null || value.trim().isEmpty || value.trim().length < 6) {
        return 'Enter a valid password';
      }
      return null;
    }

    String? usernameValidator(String? value) {
      if (value == null || value.trim().isEmpty || value.trim().length < 3) {
        return 'Usename should be of atleast three characters';
      }
      return null;
    }

    return TextFormField(
      decoration: InputDecoration(
        label: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 2),
        ),
        focusedBorder:
            const UnderlineInputBorder(borderSide: BorderSide(width: 2)),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      style: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      keyboardType: title == 'E-mail address'
          ? TextInputType.emailAddress
          : TextInputType.text,
      textCapitalization: TextCapitalization.none,
      autocorrect: false,
      obscureText: title == 'Password' ? true : false,
      validator: (value) {
        if (title == 'E-mail address') {
          return emailValidator(value);
        }
        if (title == 'Password') {
          return passwordValidator(value);
        }
        if (title == 'Username') {
          return usernameValidator(value);
        }
        return null;
      },
      onSaved: (newValue) {
        onSavingTextField(newValue!);
      },
    );
  }
}
