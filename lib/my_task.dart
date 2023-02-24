import 'package:chat_app/presentation/res/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MytaskScreen extends StatefulWidget {
  const MytaskScreen({super.key});

  @override
  State<MytaskScreen> createState() => _MytaskScreenState();
}

class _MytaskScreenState extends State<MytaskScreen> {
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _backgroundArea(context),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    ); // to re-show bars

    super.dispose();
  }

  Widget _backgroundArea(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: boxBGAuth,
    );
  }

  Widget _myTaskArea(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            'Nhiệm vụ của bạn',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Column(
          children: const [],
        )
      ],
    );
  }
}
