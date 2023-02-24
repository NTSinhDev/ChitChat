import 'package:flutter/material.dart';
import 'package:chat_app/presentation/res/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class RememberMeCheckbox extends StatefulWidget {
  final bool rememberMe;
  final Function(bool?)? onChange;
  const RememberMeCheckbox({
    Key? key,
    required this.rememberMe,
    this.onChange,
  }) : super(key: key);

  @override
  State<RememberMeCheckbox> createState() => _RememberMeCheckboxState();
}

class _RememberMeCheckboxState extends State<RememberMeCheckbox> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.h,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white70),
            child: Checkbox(
              value: widget.rememberMe,
              checkColor: deepPurple,
              activeColor: Colors.white70,
              onChanged: widget.onChange,
            ),
          ),
          Text(
            'Remember me',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
