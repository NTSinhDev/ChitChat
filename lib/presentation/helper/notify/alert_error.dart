import 'package:flutter/material.dart';

class AlertError extends StatelessWidget {
  final String title;
  final String content;
  final String nameBtn;
  const AlertError(
      {super.key,
      required this.title,
      required this.content,
      required this.nameBtn});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      // actions: [
      //   TextButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     child: Text(nameBtn),
      //   ),
      // ],
    );
  }
}
