// import 'package:chat_app/data/models/message.dart';
// import 'package:chat_app/features/chat/presentation/bloc/bloc.dart';
// import 'package:chat_app/features/chat/presentation/pages/chat/components/cluster_messages.dart';
// import 'package:chat_app/features/chat/presentation/pages/chat/components/cluster_messages_time.dart';
// import 'package:chat_app/features/chat/presentation/pages/chat/components/empty_message.dart';
// import 'package:chat_app/presentation/services/app_state_provider/app_state_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class MessageView extends StatefulWidget {
//   const MessageView({
//     super.key,
//   });

//   @override
//   State<MessageView> createState() => _MessageViewState();
// }

// class _MessageViewState extends State<MessageView> {
//   @override
//   Widget build(BuildContext context) {
//     AppStateProvider appState = context.watch<AppStateProvider>();
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: SingleChildScrollView(
//           reverse: true,
//           padding: EdgeInsets.symmetric(
//             vertical: 10.h,
//             horizontal: 20.w,
//           ),
//           physics: const BouncingScrollPhysics(),
//           child: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
//             if (state is HasSourceChatState) {
//               if (state.sourceChat == null) {
//                 return EmptyMessage(
//                   friend: state.friend,
//                 );
//               }
//               return ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: state.sourceChat!.length,
//                 itemBuilder: (context, index) {
//                   int indexShowTime = 0;
//                   bool isLastClusterTime = _checkIsLastCluster(
//                     index,
//                     state.sourceChat!.length - 1,
//                   );
//                   List<dynamic> sourceChatItem = state.sourceChat![index];
//                   return Column(
//                     children: sourceChatItem.map((clusterMessage) {
//                       final isSender = _checkIsSender(
//                         clusterMessage,
//                         state.currentUser.sId,
//                       );
//                       bool isLastClusterMessage = false;
//                       if (isLastClusterTime) {
//                         isLastClusterMessage = _checkIsLastCluster(
//                           indexShowTime,
//                           sourceChatItem.length - 1,
//                         );
//                       }
//                       indexShowTime++;
//                       return Column(
//                         children: [
//                           if (indexShowTime == 1) ...[
//                             CluterMessagesTime(
//                               theme: appState.darkMode,
//                               time: state.listTime![index],
//                             ),
//                           ],
//                           ClusterMessages(
//                             avatarFriend: state.friend.urlImage!,
//                             theme: appState.darkMode,
//                             isSender: isSender,
//                             messages: clusterMessage,
//                             isLastCluster: isLastClusterMessage,
//                           ),
//                         ],
//                       );
//                     }).toList(),
//                   );
//                 },
//               );
//             }
//             return const Text('Error 500');
//           }),
//         ),
//       ),
//     );
//   }

//   bool _checkIsSender(clusterMessage, id) {
//     return Message.fromJson(clusterMessage[0]).idSender == id ? true : false;
//   }

//   bool _checkIsLastCluster(index, check) {
//     return index == check ? true : false;
//   }
// }
