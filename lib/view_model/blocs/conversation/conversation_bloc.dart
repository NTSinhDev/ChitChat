import 'dart:developer';

import 'package:chat_app/data/repositories/injector.dart';
import 'package:chat_app/models/injector.dart';
import 'package:chat_app/services/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final UserProfile currentUser;

  // Repositories
  final _conversationRepo = ConversationsRepository();
  final _userInformationRepo = UserInformationRepository();

  // Conversations data
  List<ConversationData> _conversations = [];
  final _behaviorConversations = BehaviorSubject<List<ConversationData>>();
  Stream<List<ConversationData>> get conversationsStream {
    return _behaviorConversations.stream;
  }

  // Firebase Cloud Messaging
  final FCMHanlder fcmHanlder;
  final RouterProvider routerProvider;
  ConversationBloc({
    required this.currentUser,
    required this.fcmHanlder,
    required this.routerProvider,
  }) : super(ConversationInitial(userId: currentUser.profile?.id ?? '')) {
    _behaviorConversations.listen((value) => _conversations = value);
    on<ListenConversationsEvent>((event, emit) async {
      log('🚀 Tải dữ liệu cuộc trò chuyện ở local');
      await _conversationRepo.local.openBoxs();
      List<ConversationData> conversationsData = await _conversationRepo.local
          .getConversationsData(currentUser.profile!.id!);
      _behaviorConversations.sink.add(conversationsData);

      log('🚀 Bắt đầu tải dữ liệu các cuộc trò chuyện...');
      _conversationRepo.remote
          .conversationsDataStream(userId: currentUser.profile!.id!)
          .listen((Iterable<Conversation> dataStream) async {
        final conversationList = dataStream.toList();
        for (var i = 0; i < conversationList.length; i++) {
          // Get friend infomation
          final friendId = conversationList[i].listUser.length == 1
              ? conversationList[i].listUser[0]
              : conversationList[i]
                  .listUser
                  .firstWhere((element) => element != currentUser.profile!.id!);
          final friendProfile = await _userInformationRepo.remote
              .getInformationById(id: friendId);

          // Check is Equals data
          if (friendProfile!.profile == conversationsData[i].friend.profile &&
              conversationList[i] == conversationsData[i].conversation) {
          } else {
            final conversationData = ConversationData(
              conversation: conversationList[i],
              friend: friendProfile,
            );
            conversationsData[i] = conversationData;
            _behaviorConversations.sink.add(conversationsData);
          }
        }

        if (conversationsData != _conversations) {
          _saveToLocal(conversations: conversationsData);
        }
      });
    });
    on<ReadConversationEvent>((event, emit) async {
      List<String> newData = event.conversation.readByUsers;
      newData.add(currentUser.profile!.id!);
      final data = {
        ConversationsField.readByUsers: newData,
      };
      await _conversationRepo.remote
          .updateConversation(id: event.conversation.id!, data: data);
    });
    on<HandleNotificationServiceEvent>((event, emit) {
      //* Tạo bộ điều hướng
      final navigator = Navigator.of(event.context);

      log('💯 Bắt đầu nhận thông báo');
      //* bắt đầu xử lý thông báo khi ấn vào thông báo
      //* tại đây lăng nghe xự kiện ấn vào thông báo
      fcmHanlder.notificationService.onNotificationClick.listen(
        (value) async {
          log("start onNotificationClick");

          if (value == null) return;
          //* Có data thì bắt đầu xử lý
          log(value.toString());

          //* khởi tạo các dữ liệu ban đầu
          final namePath = routerProvider.getNamePath();
          final conversationList = await conversationsStream.first;
          final conversationData = conversationList.firstWhere((element) =>
              element.conversation.id ==
              value[ConversationsField.conversationID]);

          //* nếu như namePath có giá trị thì gọi phương thức push của bộ điều hướng
          //* để chuyển đến màn hình Chat
          //*
          if (namePath == null) {
            await navigator.push(
              MaterialPageRoute(
                builder: (context) {
                  return ChatScreen(
                    conversation: conversationData.conversation,
                    currentUser: currentUser,
                    friendInfo: conversationData.friend,
                  );
                },
                settings: RouteSettings(
                  name: "conversation:${conversationData.conversation.id}",
                ),
              ),
            );
          } else {
            if (conversationData.conversation.id == null) return;
            if (namePath == "/") {
              log("check get inside");
              await navigator.push(
                MaterialPageRoute(
                  builder: (context) {
                    return ChatScreen(
                      conversation: conversationData.conversation,
                      currentUser: currentUser,
                      friendInfo: conversationData.friend,
                    );
                  },
                  settings: RouteSettings(
                    name: "conversation:${conversationData.conversation.id}",
                  ),
                ),
              );
            } else {
              await _checkChatPageOrReplace(
                namePath: namePath,
                navigator: navigator,
                conversation: conversationData.conversation,
                friend: conversationData.friend,
              );
            }
          }
        },
      );
    });

    _saveDeviceToken();
  }

  _saveDeviceToken() async {
    final response = await _userInformationRepo.remote.updateDeviceToken(
      deviceToken: fcmHanlder.deviceToken,
      userID: currentUser.profile?.id,
      currentToken: currentUser.profile?.messagingToken ?? '',
    );
    if (response) {
      currentUser.profile!.messagingToken = fcmHanlder.deviceToken;
      _userInformationRepo.local.saveProfile(profile: currentUser.profile);
    }
  }

  Future<void> _checkChatPageOrReplace({
    required String namePath,
    required NavigatorState navigator,
    required Conversation conversation,
    required UserProfile? friend,
  }) async {
    log("check full namePath");
    log(namePath);
    log(namePath.split(":").first);
    if (namePath.split(":").first == "conversation") {
      log("this is conversation page");
      final checkRoute =
          namePath == 'conversation:${conversation.id ?? ""}' ? true : false;
      if (!checkRoute) {
        log("push replace");
        await navigator.pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return ChatScreen(
                conversation: conversation,
                currentUser: currentUser,
                friendInfo: friend ?? UserProfile(urlImage: URLImage()),
              );
            },
            settings: RouteSettings(
              name: "conversation:${conversation.id}",
            ),
          ),
        );
      }
    }
  }

  _saveToLocal({required List<ConversationData> conversations}) async {
    if (conversations.isEmpty) return;

    for (ConversationData element in conversations) {
      await _conversationRepo.local.createConversation(
        conversation: element.conversation,
        friendProfile: element.friend,
      );
    }
    log('Finished 🚀saveToLocal⚡ ConversationsData');
  }

  Future<UserProfile?> getFriendInfomation({required String id}) async =>
      await _userInformationRepo.remote.getInformationById(id: id);

  @override
  Future<void> close() async {
    await _behaviorConversations.drain();
    await _behaviorConversations.close();
    return super.close();
  }
}
