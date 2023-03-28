// ignore: file_names
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<FontWeight> _fontWeightAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _fontWeightAnimation = FontWeightTween(
      begin: FontWeight.normal,
      end: FontWeight.bold,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AnimatedBuilder(
            animation: _fontWeightAnimation,
            builder: (context, child) {
              return Text(
                'Hello, World!',
                style: TextStyle(
                  fontWeight: _fontWeightAnimation.value,
                  fontSize: 24.0,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
