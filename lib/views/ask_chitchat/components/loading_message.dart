import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class LoadingMessage extends StatelessWidget {
  const LoadingMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    return Container(
      margin: EdgeInsets.only(left: 14.w),
      child: MessageWidget(
        isSender: false,
        width: MediaQuery.of(context).size.width / 6,
        child: SpinKitThreeBounce(
          color: theme ? Colors.white : Colors.black,
          size: 14.r,
        ),
      ),
    );
  }
}
