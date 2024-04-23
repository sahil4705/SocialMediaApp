import 'package:flutter/material.dart';

import '../constants/constants.dart';

class TextBox extends StatelessWidget {
  //final VoidCallback validate;
  final TextEditingController textEditingController;
  final String hintText;
  final IconData icondata;
  final bool? isPassword;
  final VoidCallback? validate;
  const TextBox({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.icondata,
    this.isPassword,
    this.validate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
            filled: true,
            fillColor: appinverse,
            hintText: hintText,
            prefixIcon: Icon(icondata),
            enabledBorder: textboxborder,
            focusedBorder: textboxborder,
            border: textboxborder),
        obscureText: isPassword != null ? isPassword! : false,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}
