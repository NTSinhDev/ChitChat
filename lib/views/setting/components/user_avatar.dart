import 'dart:developer';
import 'package:chat_app/core/enum/enums.dart';
import 'package:chat_app/core/helpers/loading/loading_screen.dart';
import 'package:chat_app/core/helpers/notify/flash_message.dart';
import 'package:chat_app/core/res/colors.dart';
import 'package:chat_app/view_model/blocs/setting/setting_bloc.dart';
import 'package:chat_app/widgets/state_avatar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar({
    super.key,
  });

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  @override
  Widget build(BuildContext context) {
    final userProfile =
        Provider.of<SettingBloc>(context, listen: false).userProfile;
    return Center(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(12.h),
            child: StateAvatar(
              urlImage: userProfile.urlImage,
              isStatus: false,
              radius: 120.r,
            ),
          ),
          _updateAvatarWidget(),
        ],
      ),
    );
  }

  Widget _updateAvatarWidget() {
    return Positioned(
      bottom: 4.h,
      right: 4.w,
      child: Container(
        width: 52.w,
        height: 52.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: InkWell(
          onTap: () => _changeAvatar(context),
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
    );
  }

  _changeAvatar(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bcontext) {
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
                  AppLocalizations.of(bcontext)!.change_avatar,
                  style: Theme.of(bcontext)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.black),
                ),
                SizedBox(height: 8.h),
                ListTile(
                  onTap: () => _pickImage(
                    source: ImageSource.camera,
                    context: context,
                  ),
                  leading: const Icon(
                    CupertinoIcons.camera_fill,
                    color: Colors.black,
                  ),
                  title: Text(
                    AppLocalizations.of(bcontext)!.take_a_photo,
                    style: Theme.of(bcontext)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.black),
                  ),
                ),
                ListTile(
                  onTap: () => _pickImage(
                    source: ImageSource.gallery,
                    context: context,
                  ),
                  leading: const Icon(
                    CupertinoIcons.photo,
                    color: Colors.black,
                  ),
                  title: Text(
                    AppLocalizations.of(bcontext)!.select_photo_gallery,
                    style: Theme.of(bcontext)
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

  Future _pickImage({
    required ImageSource source,
    required BuildContext context,
  }) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (!mounted) return;

      if (image == null) {
        return FlashMessage(
          context: context,
          message: AppLocalizations.of(context)!.could_not_update_avatar,
          type: FlashMessageType.error,
        );
      }

      final settingBloc = context.read<SettingBloc>();
      settingBloc.add(UpdateAvatarEvent(path: image.path));

      if (!mounted) return;
      Navigator.pop(context);
    } on PlatformException catch (e) {
      log('Pick image failed: $e');
    }
  }
}
