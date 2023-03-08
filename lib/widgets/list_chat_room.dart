// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:chat_app/res/dimens.dart';
// import 'package:chat_app/models/url_image.dart';
// import 'package:chat_app/view_model/providers/app_state_provider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

// import 'package:chat_app/res/colors.dart';
// import 'package:chat_app/widgets/state_avatar_widget.dart';

// class ListChatRoom extends StatefulWidget {
//   final List<dynamic> listUsers;
//   final bool isGroup;
//   final bool? isCall;
//   const ListChatRoom({
//     Key? key,
//     required this.listUsers,
//     required this.isGroup,
//     this.isCall,
//   }) : super(key: key);

//   @override
//   State<ListChatRoom> createState() => _ListChatRoomState();
// }

// class _ListChatRoomState extends State<ListChatRoom> {
//   @override
//   Widget build(BuildContext context) {
//     AppStateProvider appState = context.watch<AppStateProvider>();
//     final maxHeight = MediaQuery.of(context).size.height;
//     return Container(
//       constraints: BoxConstraints(
//         maxHeight: maxHeight,
//       ),
//       child: ListView.builder(
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: widget.listUsers.length,
//         itemBuilder: (BuildContext context, int index) {
//           return _itemChat(context, index, appState);
//         },
//       ),
//     );
//   }

//   Widget _itemChat(BuildContext context, int index, AppStateProvider appState) {
//     // State text style which show notify that is not view
//     final styleNotView = index < 2
//         ? Theme.of(context)
//             .textTheme
//             .headlineSmall!
//             .copyWith(color: lightBlue, fontWeight: FontWeight.w400)
//         : Theme.of(context).textTheme.headlineSmall;

//     return ListTile(
//       onTap: () {},
//       visualDensity: const VisualDensity(vertical: 0.7),
//       leading: StateAvatar(
//         urlImage: URLImage(), //* avatar
//         isStatus: widget.listUsers[index][0].state, //* state
//         radius: 60.r,
//       ),
//       title: Container(
//         margin: EdgeInsets.fromLTRB(
//           0,
//           10.h,
//           0,
//           8.h,
//         ),
//         child: Text(
//           widget.listUsers[index][0].username, //* Name
//           style: Theme.of(context).textTheme.titleLarge,
//         ),
//       ),
//       subtitle: Container(
//         margin: EdgeInsets.only(bottom: 4.h),
//         child: Row(
//           children: [
//             SizedBox(
//               width: 152.w,
//               child: Text(
//                 widget.listUsers[index][1], //* Content
//                 overflow: TextOverflow.ellipsis,
//                 style: styleNotView,
//               ),
//             ),
//             Spaces.w4,
//             Text('|', style: styleNotView),
//             Spaces.w4,
//             Text(widget.listUsers[index][2], style: styleNotView),
//           ],
//         ),
//       ),
//       trailing: widget.isCall != null
//           ? Container(
//               margin: EdgeInsets.fromLTRB(
//                 0,
//                 10.h,
//                 0,
//                 8.h,
//               ),
//               constraints: BoxConstraints(
//                 maxWidth: 40.h,
//                 maxHeight: 40.h,
//               ),
//               decoration: BoxDecoration(
//                 color:
//                     appState.darkMode ? Colors.grey[800] : lightGreyLightMode,
//                 borderRadius: BorderRadius.circular(40.r),
//               ),
//               child: Center(
//                   child: Icon(
//                 CupertinoIcons.phone_solid,
//                 size: 20.r,
//               )),
//             )
//           : null,
//     );
//   }
// }
