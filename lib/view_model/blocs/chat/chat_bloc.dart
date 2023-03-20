import 'dart:async';

import 'package:chat_app/utils/enum/enums.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:chat_app/models/injector.dart';
import 'package:chat_app/data/repositories/injector.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final UserProfile currentUser;
  Conversation? conversation;
  final UserInformation friend;

  final _messageRepository = MessagesRepository();
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
    on<SendFilesEvent>(_sendFiles);
  }
  Stream<String?> getFile({required String fileName}) {
    return _messageRepository.rm.getFile(
      conversationID: conversation!.id!,
      senderID: currentUser.profile!.id!,
      fileName: fileName,
    );
  }

  _sendFiles(SendFilesEvent event, Emitter<ChatState> emit) async {
    final hasConversation = await _createNewConversationIfNull(
      message: "đã gửi ${event.files.length} ${event.type.toString()}",
    );
    if (hasConversation["isCreate"] == false) return;
    final isCreated = await _messageRepository.rm.sendMessage(
      senderID: currentUser.profile!.id!,
      conversationID: conversation!.id!,
      images: event.files,
      messageType: event.type,
    );
    if (!isCreated) return;
    if (hasConversation["isUpdate"] == false) {
      final result = await _conversationRepository.updateConversation(
        id: conversation!.id!,
        data: {
          ConversationsField.lastText:
              "đã gửi ${event.files.length} ${event.type.toString()}",
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

  _sendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    final hasConversation = await _createNewConversationIfNull(
      message: event.message,
    );
    if (hasConversation["isCreate"] == false) return;
    final isCreated = await _messageRepository.rm.sendMessage(
      senderID: currentUser.profile!.id!,
      conversationID: conversation!.id!,
      messageContent: event.message,
    );
    if (!isCreated) return;
    if (hasConversation["isUpdate"] == false) {
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

  Future<Map<String, bool>> _createNewConversationIfNull({
    required String message,
  }) async {
    if (conversation != null) return {"isCreate": true, "isUpdate": false};
    final userIDs = [
      currentUser.profile!.id!,
      friend.informations.profile!.id!,
    ];
    conversation = await _conversationRepository.createNewConversation(
      userIDs: userIDs,
      lastMsg: message,
    );
    if (conversation == null) return {"isCreate": false, "isUpdate": false};
    return {"isCreate": true, "isUpdate": true};
  }

  _getMessageList() async {
    if (conversation == null) return;
    // final messageListAtLocal = await _messageRepository.lc.getMessageList(
    //   conversationId: conversation!.id!,
    // );
    // _msgListSink.add(messageListAtLocal);
    _messageRepository.rm
        .getMessageList(conversationId: conversation!.id!)
        .listen((msgList) async {
      _msgListSink.add(msgList);
      // for (var element in msgList) {
      //   await _messageRepository.lc.createMessage(message: element);
      // }
    });
  }
}
