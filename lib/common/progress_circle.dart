import 'package:flutter/material.dart';

class ProgressCircle extends StatefulWidget {
  const ProgressCircle({super.key});

  @override
  State<ProgressCircle> createState() => _ProgressCircleState();
}

class _ProgressCircleState extends State<ProgressCircle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: const CircularProgressIndicator(),
    );
  }
}
