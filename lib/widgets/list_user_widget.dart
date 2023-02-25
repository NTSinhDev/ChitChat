// import 'package:chat_app/data/models/auth_user.dart';
// import 'package:chat_app/data/models/user_presence.dart';
// import 'package:chat_app/features/chat/presentation/bloc/bloc.dart';
// import 'package:chat_app/presentation/widgets/state_avatar_widget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

// class ListUserWidget extends StatelessWidget {
//   final List<dynamic> listUser;
//   final bool isAddFriend;
//   final bool? loadding;
//   final bool? success;

//   const ListUserWidget({
//     super.key,
//     required this.listUser,
//     required this.isAddFriend,
//     this.loadding,
//     this.success,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final maxHeight = MediaQuery.of(context).size.height;

//     return Container(
//       constraints: BoxConstraints(
//         maxHeight: maxHeight,
//       ),
//       child: ListView.builder(
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: listUser.length,
//         itemBuilder: (context, index) {
//           final friend = User.fromJson(listUser[index]['friend']);
//           final presence = UserPresence.fromJson(listUser[index]['presence']);
//           return Padding(
//             padding: EdgeInsets.only(bottom: 10.h),
//             child: ListTile(
//               onTap: () {
//                 final userID = Provider.of<ChatBloc>(context, listen: false)
//                     .currentUser
//                     .sId;
//                 Provider.of<ChatBloc>(context, listen: false).add(
//                   CheckHasRoomEvent(
//                     userID: userID!,
//                     friend: friend,
//                     isOnl: presence.presence!,
//                   ),
//                 );
//               },
//               leading: Container(
//                 padding: EdgeInsets.only(right: 8.w),
//                 child: StateAvatar(
//                   avatar: friend.urlImage ?? '',
//                   isStatus: presence.presence!,
//                   radius: 48.r,
//                 ),
//               ),
//               title: Text(
//                 friend.name ?? 'UNKNOWN',
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               trailing:
//                   isAddFriend ? _stateAcction(context, friend, presence) : null,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _stateAcction(
//       BuildContext context, User friend, UserPresence presense) {
//     if (loadding!) {
//       return SizedBox(
//         height: 12.h,
//         width: 12.w,
//         child: const CircularProgressIndicator(strokeWidth: 2.5),
//       );
//     }
//     if (success!) {
//       return const Icon(
//         Icons.check_circle_outline_rounded,
//         color: Colors.green,
//       );
//     }
//     return InkWell(
//       onTap: () {
//         Provider.of<ChatBloc>(context, listen: false).add(
//           FriendRequestEvent(
//             friend: {'friend': friend.toJson(), 'presence': presense.toJson()},
//           ),
//         );
//       },
//       child: const Icon(
//         CupertinoIcons.person_add_solid,
//       ),
//     );
//   }
// }
