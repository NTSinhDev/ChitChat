import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WarningMessage extends StatelessWidget {
  final bool isDataValid;
  final String message;

  const WarningMessage({
    super.key,
    required this.isDataValid,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 6, 0, 0),
      child: Visibility(
        visible: isDataValid,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              width: 24,
              child: Lottie.asset(
                'assets/animations/failed.json',
                fit: BoxFit.fitWidth,
              ),
            ),
            Text(
              message,
              style: TextStyle(
                color: Colors.red.shade300,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
