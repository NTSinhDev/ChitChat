import 'dart:developer';

import 'package:chat_app/data/datasources/remote_datasources/injector.dart';
import 'package:chat_app/data/datasources/remote_datasources/storage_remote_datasource.dart';
import 'package:chat_app/res/colors.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/utils/enums.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/setting/components/user_avatar.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'components/input_avatar.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final controller = TextEditingController();
  String avatar = '';

  @override
  Widget build(BuildContext context) {
    final isDarkmode = context.watch<ThemeProvider>().isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputAvatar(
                callback: (path) {
                  setState(() {
                    avatar = path;
                  });
                },
              ),
              Spaces.h20,
              const Text('Tên'),
              Spaces.h8,
              Container(
                padding: EdgeInsets.all(14.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ResColors.appColor(isDarkmode: isDarkmode),
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  style: Theme.of(context).textTheme.bodyMedium,
                  controller: controller,
                  decoration: InputDecoration.collapsed(
                    hintText: "\tCho tôi cái tên",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey),
                  ),
                ),
              ),
              const Spacer(),
              LargeRoundButton(
                textButton: "Oke",
                onTap: () async {
                  if (avatar.isEmpty || controller.text.isEmpty) return;
                  // Create new document profile
                  final id = await ProfileRemoteDataSourceImpl()
                      .createNewProfile(controller.text);
                      log('🚀id ne⚡ $id');

                  // Upload to avatar to FireStorage
                  await StorageRemoteDatasourceImpl().uploadFile(
                    path: avatar,
                    type: FileUploadType.path,
                    folderName: StorageKey.pPROFILE,
                    fileName: id,
                  );

                  // log('🚀Đây là dữ liệu⚡\n $avatar \n ${controller.text}');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
