import 'package:chat_app/res/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/views/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class EmptyConversation extends StatelessWidget {
  const EmptyConversation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/add_friend.json',
              fit: BoxFit.fitWidth,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              child: SizedBox(
                width: 110.w,
                child: Row(
                  children: [
                    const Icon(Icons.add),
                    Spaces.w8,
                    Text(context.languagesExtension.add_friend),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
