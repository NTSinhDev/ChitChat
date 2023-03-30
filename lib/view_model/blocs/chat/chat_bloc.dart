import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:chat_app/data/repositories/injector.dart';
import 'package:chat_app/models/injector.dart';
import 'package:chat_app/services/injector.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/view_model/injector.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final UserProfile currentUser;
  Conversation? conversation;
  final UserProfile friend;
  final _messageRepository = MessagesRepository();
  final _conversationRepository = ConversationsRepository();

  // Message
  // final _stateMsgSubject = BehaviorSubject<String>();
  // StreamSink<String> get _stateMsgSink => _stateMsgSubject.sink;
  // Stream<String> get stateMsgStream => _stateMsgSubject.stream;

  // Conversation
  final ReplaySubject<Iterable<Message>> _msgListSubject = ReplaySubject();
  Stream<Iterable<Message>> get msgListStream => _msgListSubject.stream;
  StreamSink<Iterable<Message>> get _msgListSink => _msgListSubject.sink;

  ChatBloc({
    required this.currentUser,
    required this.conversation,
    required this.friend,
  }) : super(InitChatState(
            currentUser: currentUser,
            friend: friend,
            conversation: conversation)) {
    _getMessageList();
    on<SendMessageEvent>(_sendMessage);
    on<SendFilesEvent>(_sendFiles);
  }

  Stream<String?> getFile({required String fileName}) {
    return _messageRepository.remote.getFile(
      conversationID: conversation!.id!,
      senderID: currentUser.profile!.id!,
      fileName: fileName,
    );
  }

  _sendFiles(SendFilesEvent event, Emitter<ChatState> emit) async {
    final hasConversation = await _createNewConversationIfNull(
      message: "đã gửi ${event.files.length} file",
    );
    if (hasConversation.isCreate == false) return;
    final isCreated = await _messageRepository.remote.sendMessage(
      senderID: currentUser.profile!.id!,
      conversationID: conversation!.id!,
      images: event.files,
      messageType: event.type,
    );
    if (!isCreated) return;
    if (hasConversation.isUpdate == false) {
      final result = await _conversationRepository.remote.updateConversation(
        id: conversation!.id!,
        data: {
          ConversationsField.lastText: "đã gửi ${event.files.length} file",
          ConversationsField.listUser: [
            currentUser.profile!.id!,
            conversation!.listUser.firstWhere(
              (element) => element != currentUser.profile!.id!,
            ),
          ],
          ConversationsField.stampTimeLastText:
              DateTime.now().millisecondsSinceEpoch,
        },
      );
      if (!result) return;
    }
    _getMessageList();
    // _stateMsgSink.add('');
    emit(InitChatState(
      currentUser: currentUser,
      friend: friend,
      conversation: conversation,
    ));
  }

  _sendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    final hasConversation = await _createNewConversationIfNull(
      message: event.message,
    );
    if (hasConversation.isCreate == false) return;
    final isCreated = await _messageRepository.remote.sendMessage(
      senderID: currentUser.profile!.id!,
      conversationID: conversation!.id!,
      messageContent: event.message,
    );
    if (!isCreated) return;
    if (hasConversation.isUpdate == false) {
      final result = await _conversationRepository.remote.updateConversation(
        id: conversation!.id!,
        data: {
          ConversationsField.lastText: event.message,
          ConversationsField.listUser: [
            currentUser.profile!.id!,
            conversation!.listUser.firstWhere(
              (element) => element != currentUser.profile!.id!,
            ),
          ],
          ConversationsField.stampTimeLastText:
              DateTime.now().millisecondsSinceEpoch,
        },
      );
      if (!result) return;
    }
    _getMessageList();

    if (friend.profile != null && friend.profile!.messagingToken != null) {
      await FCMHanlder.sendMessage(
        conversationID: conversation?.id ?? '',
        userProfile: currentUser.profile!,
        friendProfile: friend.profile!,
        message: event.message,
      );
    }

    emit(InitChatState(
      currentUser: currentUser,
      friend: friend,
      conversation: conversation,
    ));
  }

  Future<_CheckConversation> _createNewConversationIfNull({
    required String message,
  }) async {
    final checkConversation = _CheckConversation(
      isCreate: true,
      isUpdate: false,
    );
    if (conversation != null) return checkConversation;

    final userIDs = [
      currentUser.profile!.id!,
      friend.profile!.id!,
    ];
    conversation = await _conversationRepository.remote.createNewConversation(
      userIDs: userIDs,
      lastMsg: message,
    );
    if (conversation == null) {
      checkConversation.updateIsCreate(false);
      return checkConversation;
    }
    checkConversation.updateIsUpdate(true);
    return checkConversation;
  }

  _getMessageList() async {
    if (conversation == null) return;
    final messageListAtLocal = await _messageRepository.local.getMessageList(
      conversationId: conversation!.id!,
    );
    _msgListSink.add(messageListAtLocal);
    _messageRepository.remote
        .getMessageList(conversationId: conversation!.id!)
        .listen((msgList) async {
      _msgListSink.add(msgList);
      for (var element in msgList) {
        await _messageRepository.local.createMessage(message: element);
      }
    });
  }
}

class _CheckConversation {
  bool isCreate;
  bool isUpdate;
  _CheckConversation({
    required this.isCreate,
    required this.isUpdate,
  });

  updateIsCreate(bool newValue) {
    isCreate = newValue;
  }

  updateIsUpdate(bool newValue) {
    isUpdate = newValue;
  }
}
