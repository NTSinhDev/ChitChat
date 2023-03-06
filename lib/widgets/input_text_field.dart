import 'package:chat_app/res/dimens.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/res/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputTextField extends StatefulWidget {
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final String title;
  final IconData icon;
  final String hint;
  final TextInputType type;
  final bool obscure;
  final String keyInput;
  final TextInputAction textInputAction;

  const InputTextField({
    Key? key,
    this.onSubmitted,
    this.onChanged,
    required this.title,
    required this.icon,
    required this.hint,
    required this.type,
    required this.obscure,
    required this.keyInput,
    this.textInputAction = TextInputAction.next,
  }) : super(key: key);

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
        ),
        Spaces.h10,
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: customPurple,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 64.h,
          child: TextField(
            key: Key(widget.keyInput),
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            controller: _controller,
            keyboardType: widget.type,
            textInputAction: TextInputAction.next,
            obscureText: widget.obscure ? true : false,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.h),
              prefixIcon: Icon(widget.icon, color: Colors.white),
              hintText: widget.hint,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white70),
            ),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
