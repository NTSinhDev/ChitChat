import 'dart:async';

import 'package:chat_app/core/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:chat_app/core/enum/enums.dart';

import 'package:chat_app/models/models_injector.dart';
import 'package:chat_app/repositories/injector.dart';

import 'bloc_injector.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final UserProfile currentUser;
  Conversation? conversation;
  final UserInformation friend;

  final _messageRepository = MessagesRepositoryImpl();
  final _conversationRepository = ConversationsRepositoryImpl();

  // Message
  final _stateMsgSubject = BehaviorSubject<String>();
  StreamSink<String> get _stateMsgSink => _stateMsgSubject.sink;
  Stream<String> get stateMsgStream => _stateMsgSubject.stream;

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
  }

  _getMessageList() async {
    if (conversation == null) return;
    final messageListAtLocal = await _messageRepository.lcGetMessageList(
      conversationId: conversation!.id!,
    );
    _msgListSink.add(messageListAtLocal);
    _messageRepository
        .rmGetMessageList(conversationId: conversation!.id!)
        .listen((msgList) async {
      _msgListSink.add(msgList);
      for (var element in msgList) {
        await _messageRepository.lcCreateMessage(message: element);
      }
    });
  }

  _sendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    bool isUpdatedConversation = false;
    // tạo conversation mới nếu chưa có
    if (conversation == null) {
      final userIDs = [
        currentUser.profile!.id!,
        friend.informations.profile!.id!,
      ];
      conversation = await _conversationRepository.createNewConversation(
        userIDs: userIDs,
        lastMsg: event.message,
      );
      isUpdatedConversation = true;
      //TODO: kiem tra conversation tra ve: null ? emit error state : go on!
    }

    final isCreated = await _messageRepository.rmCreateMessage(
      senderID: currentUser.profile!.id!,
      conversationID: conversation!.id!,
      message: event.message,
    );

    if (!isCreated) return;

    if (!isUpdatedConversation) {
      final result = await _conversationRepository.updateConversation(
        id: conversation!.id!,
        data: {
          ConversationsField.lastText: event.message,
          ConversationsField.stampTimeLastText:
              DateTime.now().millisecondsSinceEpoch,
        },
      );
      if (!result) return;
    }

    _stateMsgSink.add('');

    emit(InitChatState(
      currentUser: currentUser,
      friend: friend,
      conversation: conversation,
    ));
  }
}
