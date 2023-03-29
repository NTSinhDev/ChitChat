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
  Iterable<Conversation> conversations = [];
  final _behaviorConversations = BehaviorSubject<Iterable<Conversation>>();
  Stream<Iterable<Conversation>> get conversationsStream {
    return _behaviorConversations.stream;
  }

  // Firebase Cloud Messaging
  final FCMHanlder fcmHanlder;
  final RouterProvider routerProvider;
  ConversationBloc({
    required this.currentUser,
    required this.fcmHanlder,
    required this.routerProvider,
  }) : super(ConversationInitial(
          conversationsStream: BehaviorSubject<Iterable<Conversation>>().stream,
          userId: currentUser.profile?.id ?? '',
        )) {
    _updateConversationsData();

    on<ListenConversationsEvent>((event, emit) async {
      // local data
      await _conversationRepo.local.openConversationsBox();
      final dataSavedAtLocal = await _conversationRepo.local.getConversations();
      _behaviorConversations.sink.add(dataSavedAtLocal);

      _conversationRepo.remote
          .conversationsDataStream(userId: currentUser.profile!.id!)
          .listen((convers) async {
        _behaviorConversations.sink.add(convers ?? []);
        conversations = convers ?? [];
        await _saveToLocal(conversations: convers);
      });

      emit(ConversationInitial(
        conversationsStream: _behaviorConversations.stream,
        userId: currentUser.profile!.id!,
      ));
    });

    on<HandleNotificationServiceEvent>((event, emit) {
      //* Tạo bộ điều hướng
      final navigator = Navigator.of(event.context);

      log("start onnoti");
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
          final Conversation checkConversation = conversationList.firstWhere(
            (element) => element.id == value["conversationId"],
          );
          final friend = await getFriendInfomation(
              id: checkConversation.listUser
                  .where((element) => element != currentUser.profile?.id)
                  .first);

          //* nếu như namePath có giá trị thì gọi phương thức push của bộ điều hướng
          //* để chuyển đến màn hình Chat
          //*
          if (namePath == null) {
            await navigator.push(
              MaterialPageRoute(
                builder: (context) {
                  return ChatScreen(
                    conversation: checkConversation,
                    currentUser: currentUser,
                    friendInfo: friend ?? UserProfile(urlImage: URLImage()),
                  );
                },
                settings: RouteSettings(
                  name: "conversation:${checkConversation.id}",
                ),
              ),
            );
          } else {
            if (checkConversation.id == null) return;
            if (namePath == "/") {
              log("check get inside");
              await navigator.push(
                MaterialPageRoute(
                  builder: (context) {
                    return ChatScreen(
                      conversation: checkConversation,
                      currentUser: currentUser,
                      friendInfo: friend ?? UserProfile(urlImage: URLImage()),
                    );
                  },
                  settings: RouteSettings(
                    name: "conversation:${checkConversation.id}",
                  ),
                ),
              );
            } else {
              await _checkChatPageOrReplace(
                namePath: namePath,
                navigator: navigator,
                conversation: checkConversation,
                friend: friend,
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

  Future _saveToLocal({required Iterable<Conversation>? conversations}) async {
    if (conversations == null) return;

    for (var element in conversations) {
      await _conversationRepo.local.createConversation(
        conversation: element,
      );
    }
  }

  _updateConversationsData() {
    _behaviorConversations.listen((value) => conversations = value);
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
