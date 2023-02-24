import 'package:flutter/material.dart';

class NoInternetText extends StatelessWidget {
  const NoInternetText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Không có internet!",
        style:
            Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.red),
      ),
    );
  }
}
