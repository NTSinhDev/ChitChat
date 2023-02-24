import 'dart:developer';
import 'package:chat_app/presentation/res/colors.dart';
import 'package:chat_app/presentation/services/app_state_provider/app_state_provider.dart';
import 'package:chat_app/presentation/widgets/state_avatar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserAvatar extends StatefulWidget {
  final String avatar;
  final String userID;
  final bool theme;
  const UserAvatar({
    super.key,
    required this.avatar,
    required this.userID,
    required this.theme,
  });

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(12.h),
            child: StateAvatar(
              avatar: widget.avatar,
              isStatus: false,
              radius: 120.r,
            ),
          ),
          Positioned(
            bottom: 4.h,
            right: 4.w,
            child: Container(
              width: 52.w,
              height: 52.h,
              decoration: BoxDecoration(
                color: widget.theme ? darkColor : lightColor,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: InkWell(
                onTap: _changeAvatar,
                child: Container(
                  margin: EdgeInsets.all(6.h),
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: lightGreyLightMode,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(
                      30.r,
                    ),
                  ),
                  child: Icon(
                    CupertinoIcons.camera_fill,
                    size: 20.h,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _changeAvatar() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 180.h,
          padding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 20.w,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.h),
              topRight: Radius.circular(12.h),
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.change_avatar,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.black),
                ),
                SizedBox(height: 8.h),
                ListTile(
                  onTap: () => _pickImage(ImageSource.camera),
                  leading: const Icon(
                    CupertinoIcons.camera_fill,
                    color: Colors.black,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.take_a_photo,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.black),
                  ),
                ),
                ListTile(
                  onTap: () => _pickImage(ImageSource.gallery),
                  leading: const Icon(
                    CupertinoIcons.photo,
                    color: Colors.black,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.select_photo_gallery,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      if (!mounted) return;
      final urlImage = await Provider.of<AppStateProvider>(
        context,
        listen: false,
      ).uploadAvatar(
        image.path,
        widget.userID,
      );
      if (urlImage == null) return;
      if (!mounted) return;
      Navigator.pop(context);
    } on PlatformException catch (e) {
      log('Pick image failed: $e');
    }
  }
}
