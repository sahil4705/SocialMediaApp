import 'package:flutter/material.dart';

import '../constants/constants.dart';

class StdButton extends StatelessWidget {
  final String btnText;
  final VoidCallback onBtnPressed;

  const StdButton(
      {super.key, required this.btnText, required this.onBtnPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: ElevatedButton(
        onPressed: onBtnPressed,
        style: ElevatedButton.styleFrom(
            maximumSize: const Size(400, 45),
            backgroundColor: appinverse,
            foregroundColor: appcolor,
            fixedSize: const Size(double.maxFinite, 45),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        child: Text(
          btnText,
          style: const TextStyle(fontSize: 20, color: appcolor),
        ),
      ),
    );
  }
}
