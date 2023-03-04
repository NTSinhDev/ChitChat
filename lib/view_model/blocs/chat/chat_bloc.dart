// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/models_injector.dart';
import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/repositories/chat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_injector.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final UserProfile currentUser;
  final Conversation? conversation;
  final UserInformation friend;

  final _chatRepo = ChatRepositoryImpl();

  ChatBloc({
    required this.currentUser,
    required this.conversation,
    required this.friend,
  }) : super(
          InitChatState(
            currentUser: currentUser,
            friend: friend,
            conversation: conversation,
          ),
        );
}
