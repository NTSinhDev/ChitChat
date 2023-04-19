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
  List<Message> _messages = [];
  final String serverKey;
  final UserProfile currentUser;
  final UserProfile friend;
  Conversation? conversation;
  // Repositories to query data
  final _messageRepository = MessagesRepository();
  final _conversationRepository = ConversationsRepository();
  // Stream data
  final _behaviorSendStatus = BehaviorSubject<MessageStatus>();
  Stream<MessageStatus> get lstMsgStatusStream => _behaviorSendStatus.stream;
  final _behaviorSeenStatus = BehaviorSubject<MessageStatus>();
  Stream<MessageStatus> get seenStatusStream => _behaviorSeenStatus.stream;
  final BehaviorSubject<List<Message>> _behaviorMessages = BehaviorSubject();
  Stream<List<Message>> get messagesStream => _behaviorMessages.stream;

  ChatBloc({
    required this.currentUser,
    required this.conversation,
    required this.friend,
    required this.serverKey,
  }) : super(InitChatState()) {
    _getMessageList();
    _markMessagesAsSeen();
    on<SendMessageEvent>((event, emit) async {
      // Kiểm tra cuộc hội thoại nếu chưa tồn tại thì tạo mới.
      final message = event.type == MessageType.text
          ? event.message
          : "đã gửi ${event.files.length} tệp";
      final hasConversation = await _createConversationIfNull(message: message);
      // Tạo mới một đối tượng tin nhắn nếu cuộc hội thoại đã có.
      if (hasConversation.isCreate == false) return;
      Message messageModel = await _messageRepository.remote.createMessageModel(
        senderID: currentUser.profile!.id!,
        conversationID: conversation!.id!,
        messageContent: event.message,
        images: event.files,
        messageType: event.type,
        messageStatus: MessageStatus.sending,
      );
      /* 
      - Thêm tin nhắn vào stream.
      - Đặt trạng thái gửi là đang gửi
      - Gửi tin nhắn.
      */
      _messages = _behaviorMessages.value;
      _messages.add(messageModel);
      _behaviorMessages.sink.add(_messages);
      _behaviorSendStatus.sink.add(MessageStatus.sending);
      final isSend = await Future.delayed(
        const Duration(seconds: 2),
        () async {
          log('🚀log⚡ go');
          return await _messageRepository.remote
              .sendMessage(messageModel: messageModel);
        },
      );
      /*
      Nếu gửi thất bại:
        - Thay đổi trang thái gửi là không gửi được
        - Kết thúc tác vụ.
       */
      if (!isSend) {
        int index = _messages.indexOf(messageModel);
        messageModel.messageStatus = MessageStatus.notSend.toString();
        _messages.replaceRange(index, index + 1, [messageModel]);
        return _behaviorMessages.sink.add(_messages);
      }
      /*
      Nếu gửi thành công: 
        - Thay đổi trạng thái gửi là đã gửi.
        - Cập nhật lại thông tin cuộc hội thoại.
      */
      _behaviorSendStatus.sink.add(MessageStatus.sent);
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
      /*
      Gửi thông báo đến thiết bị của bạn thông qua FCM
      */
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
    /**
     * Tải dữ liệu ngoại tuyến.
     * Sau đó add vào BehaviorSubject
     * */
    final offlineMessages = await _messageRepository.local.getMessageList(
      conversationId: conversation!.id!,
    );
    _behaviorMessages.sink.add(offlineMessages);
    /**
     * Cập nhật _behaviorMessages từ firebase
     * Các trường hợp cập nhật: tải dữ liệu khi tham gia phòng, tải dữ liệu khi 
     * có người nhắn và tải dữ liệu khi tin nhắn được gửi thành công...
     */
    _messageRepository.remote
        .getMessageList(conversationId: conversation!.id!)
        .listen((messages) async {
      final datas = messages.toList();
      if (datas != offlineMessages) _behaviorMessages.sink.add(datas);
    });
  }

  _markMessagesAsSeen() async {
    _behaviorMessages.listen((messages) async {
      for (var i = 0; i < messages.length; i++) {
        if (messages[i].senderId != currentUser.profile!.id! &&
            messages[i].messageStatus != MessageStatus.viewed.toString()) {
          await _messageRepository.remote.markSeen(message: messages[i]);
        }
      }
    });
  }

  Future<void> _saveData() async {
    final messagesData = _behaviorMessages.value;
    for (Message m in messagesData) {
      await _messageRepository.local.createMessage(message: m);
    }
    log('✔🟢 Đã lưu tin nhắn xong');
  }

  @override
  Future<void> close() async {
    await _saveData().then((v) async {
      await _behaviorMessages.drain();
      await _behaviorMessages.close();
    });
    return super.close();
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
