import 'dart:developer';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/setting/components/setting_bottom_sheet.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar({
    super.key,
  });

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  final radius = 160.r;
  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<AuthenticationBloc>().userProfile!;
    final isDarkmode = context.watch<ThemeProvider>().isDarkMode;
    return Center(
      child: BlocConsumer<SettingBloc, SettingState>(
        listener: updateAvatarListen,
        builder: (context, state) {
          if (state is UpdatedAvatarState) {
            if (state.loading) {
              return SizedBox(
                width: radius,
                height: radius,
                child: CircleAvatar(
                  backgroundColor: isDarkmode
                      ? AppColors.darkGrey(isDarkmode: false)
                      : AppColors.lightGrey(isDarkmode: true),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              );
            }
          }
          return StateAvatar(
            urlImage: userProfile.urlImage,
            userId: '',
            radius: radius,
            isBorder: true,
            boxShadow: const BoxShadow(
              color: Colors.black,
              offset: Offset(2, 6),
              blurRadius: 8,
            ),
          );
        },
      ),
    );
  }

  Widget updateAvatarWidget(BuildContext context) {
    final actionRadius = (5 / 16) * radius;
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        width: actionRadius,
        height: actionRadius,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(actionRadius),
        ),
        child: InkWell(
          onTap: () => changeAvatar(context),
          child: Container(
            margin: EdgeInsets.all(6.h),
            width: actionRadius - 6,
            height: actionRadius - 6,
            decoration: BoxDecoration(
              color: AppColors.lightGrey(isDarkmode: false),
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

  changeAvatar(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bcontext) {
        return SettingBtmSheet(
          btmSheetTitle: bcontext.languagesExtension.change_avatar,
          btmSheetItems: [
            SettingBottomSheetItem(
              ontap: () => pickImage(
                source: ImageSource.camera,
                context: context,
              ),
              leading: const Icon(
                CupertinoIcons.camera_fill,
                color: Colors.black,
              ),
              title: bcontext.languagesExtension.take_a_photo,
            ),
            SettingBottomSheetItem(
              ontap: () => pickImage(
                source: ImageSource.gallery,
                context: context,
              ),
              leading: const Icon(
                CupertinoIcons.photo,
                color: Colors.black,
              ),
              title: bcontext.languagesExtension.select_photo_gallery,
            )
          ],
        );
      },
    );
  }

  Future pickImage({
    required ImageSource source,
    required BuildContext context,
  }) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (!mounted) return;

      if (image == null) {
        return FlashMessageWidget(
          context: context,
          message: context.languagesExtension.could_not_update_avatar,
          type: FlashMessageType.error,
        );
      }
      Navigator.pop(context);

      final settingBloc = context.read<SettingBloc>();
      settingBloc.add(UpdateAvatarEvent(path: image.path));
    } on PlatformException catch (e) {
      log('Pick image failed: $e');
    }
  }

  updateAvatarListen(BuildContext context, SettingState state) {
    if (state is UpdatedAvatarState) {
      if (state.error != null && state.error!) {
        FlashMessageWidget(
          context: context,
          message: context.languagesExtension.could_not_update_avatar,
          type: FlashMessageType.error,
        );
      }

      if (!state.loading) {
        final authBloc = context.read<AuthenticationBloc>();
        authBloc.add(UpdateAuthInfoEvent(userProfile: state.userProfile));
      }
    }
  }
}
