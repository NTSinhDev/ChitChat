import 'dart:async';
import 'dart:developer';

import 'package:chat_app/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:chat_app/data/repositories/injector.dart';
import 'package:chat_app/models/injector.dart';
import 'package:chat_app/services/injector.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/view_model/injector.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  // Original data
  final String serverKey;
  final UserProfile currentUser;
  final UserProfile friend;
  Conversation? conversation;
  // Repositories to query data
  final _messageRepository = MessagesRepository();
  final _conversationRepository = ConversationsRepository();

  final _behaviorLstMsgStatus = BehaviorSubject<MessageStatus>();
  Stream<MessageStatus> get lstMsgStatusStream => _behaviorLstMsgStatus.stream;

  final _behaviorSeenStatus = BehaviorSubject<MessageStatus>();
  Stream<MessageStatus> get seenStatusStream => _behaviorSeenStatus.stream;

  final _replayMessages = ReplaySubject<Iterable<Message>>();
  Stream<Iterable<Message>> get messagesStream => _replayMessages.stream;
  ChatBloc({
    required this.currentUser,
    required this.conversation,
    required this.friend,
    required this.serverKey,
  }) : super(InitChatState()) {
    _getMessageList();
    on<SendMessageEvent>((event, emit) async {
      _behaviorLstMsgStatus.sink.add(MessageStatus.sending);
      final message = event.type == MessageType.text
          ? event.message
          : "đã gửi ${event.files.length} tệp";
      final hasConversation = await _createConversationIfNull(message: message);
      if (hasConversation.isCreate == false) return;

      final isSend = await _messageRepository.remote.sendMessage(
        senderID: currentUser.profile!.id!,
        conversationID: conversation!.id!,
        messageContent: event.message,
        images: event.files,
        messageType: event.type,
      );
      if (!isSend) {
        return _behaviorLstMsgStatus.sink.add(MessageStatus.notSend);
      }
      _behaviorLstMsgStatus.sink.add(MessageStatus.sent);
      if (hasConversation.isUpdate == false) {
        final result = await _conversationRepository.remote.updateConversation(
          id: conversation!.id!,
          data: {
            ConversationsField.lastText: message,
            ConversationsField.listUser: _listUser(),
            ConversationsField.readByUsers: _readByUsers(),
            ConversationsField.stampTimeLastText:
                DateTime.now().millisecondsSinceEpoch,
          },
        );
        if (!result) return;
      }
      if (friend.profile != null && friend.profile!.messagingToken != null) {
        await FCMHanlder.sendMessage(
          conversationID: conversation?.id ?? '',
          userProfile: currentUser.profile!,
          friendProfile: friend.profile!,
          message: message,
          apiKey: serverKey,
        );
      }
    });
  }

  List<String> _listUser() {
    if (conversation!.listUser.length == 1) {
      return conversation!.listUser;
    }
    return [currentUser.profile!.id!, friend.profile!.id!];
  }

  List<String> _readByUsers() {
    final a = conversation!.readByUsers
        .where((id) => id == currentUser.profile!.id!)
        .toList();
    if (a.isEmpty) {
      conversation!.readByUsers.add(currentUser.profile!.id!);
    }
    return conversation!.readByUsers;
  }

  Stream<String?> getFile({required String fileName}) {
    return _messageRepository.remote.getFile(
      conversationID: conversation!.id!,
      senderID: currentUser.profile!.id!,
      fileName: fileName,
    );
  }

  Future<_CheckConversation> _createConversationIfNull({
    required String message,
  }) async {
    final check = _CheckConversation(isCreate: true, isUpdate: false);
    if (conversation != null) return check;

    final userIDs = [currentUser.profile!.id!, friend.profile!.id!];
    conversation = await _conversationRepository.remote.createNewConversation(
      userIDs: userIDs,
      lastMsg: message,
    );
    if (conversation == null) {
      check.updateIsCreate(false);
      return check;
    }
    check.updateIsUpdate(true);
    return check;
  }

  _getMessageList() async {
    if (conversation == null) return;

    bool isCheckedDifferentLocalData = false;
    log('🚀 Tải dữ liệu tin nhắn ngoại tuyến');
    final messageListAtLocal = await _messageRepository.local.getMessageList(
      conversationId: conversation!.id!,
    );
    _replayMessages.sink.add(messageListAtLocal);
    log('🚀 Bắt đầu tải dữ liệu tin nhắn trực tuyến...');
    _messageRepository.remote
        .getMessageList(conversationId: conversation!.id!)
        .listen((msgList) async {
      if (!isCheckedDifferentLocalData &&
          messageListAtLocal == msgList.toList()) {
      } else {
        _replayMessages.sink.add(msgList);
        log('🚀 Cập nhật danh sách tin nhắn');
      }
    });
  }

  Future<void> _saveData() async {
    final Iterable<Message> datas = await _replayMessages.first;
    for (Message m in datas) {
      await _messageRepository.local.createMessage(message: m);
    }
  }

  @override
  Future<void> close() async {
    await _saveData().then((v) async {
      await _replayMessages.drain();
      await _replayMessages.close();
    });
    return super.close();
  }
}

class _CheckConversation {
  bool isCreate;
  bool isUpdate;
  _CheckConversation({
    required this.isCreate,
    required this.isUpdate,
  });
  updateIsCreate(bool newValue) => isCreate = newValue;
  updateIsUpdate(bool newValue) => isUpdate = newValue;
}
