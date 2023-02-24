// import 'package:chat_app/presentation/res/colors.dart';
// import 'package:chat_app/presentation/widgets/state_avatar_widget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class PersonalInformation extends StatelessWidget {
//   final String avatar;
//   final String name;
//   const PersonalInformation({
//     super.key,
//     required this.avatar,
//     required this.name,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: Colors.black,
//         backgroundColor: const Color(0xfafafafa),
//         elevation: 0,
//         title: Text(
//           "Cá nhân",
//           style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                 fontSize: 20.h,
//               ),
//         ),
//         // centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             _avatarWidget(),
//             Text(
//               name,
//               maxLines: 4,
//               style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                     fontSize: 20.h,
//                   ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _avatarWidget() {
//     return Center(
//       child: Stack(
//         children: [
//           Container(
//             padding: EdgeInsets.all(12.h),
//             child: StateAvatar(
//               avatar: avatar,
//               isStatus: false,
//               radius: 120.r,
//             ),
//           ),
//           Positioned(
//             bottom: 4.h,
//             right: 4.h,
//             child: Container(
//               width: Dimensions.height48 + Dimensions.height4,
//               height: Dimensions.height48 + Dimensions.height4,
//               decoration: BoxDecoration(
//                 color: const Color(0xfafafafa),
//                 borderRadius: BorderRadius.circular(Dimensions.double30),
//               ),
//               child: InkWell(
//                 onTap: () {},
//                 child: Container(
//                   margin: EdgeInsets.all(Dimensions.height6),
//                   width: Dimensions.height44,
//                   height: Dimensions.height44,
//                   decoration: BoxDecoration(
//                     color: lightGreyLightMode,
//                     borderRadius: BorderRadius.circular(
//                       Dimensions.double30,
//                     ),
//                   ),
//                   child: Icon(
//                     CupertinoIcons.camera_fill,
//                     size: Dimensions.double40 / 2,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
