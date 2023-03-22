import 'package:chat_app/data/repositories/injector.dart';
import 'package:chat_app/models/injector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final UserProfile currentUser;

  final _conversationRepo = ConversationsRepository();
  final _userInformation = UserInformationRepository();

  final _conversationsSubject = BehaviorSubject<Iterable<Conversation>>();
  Stream<Iterable<Conversation>> get conversationsStream =>
      _conversationsSubject.stream;
  Iterable<Conversation> conversations = [];
  ConversationBloc({required this.currentUser})
      : super(ConversationInitial(
          conversationsStream: BehaviorSubject<Iterable<Conversation>>().stream,
          userId: '',
        )) {
    _updateConversationsData();
    on<ListenConversationsEvent>((event, emit) async {
      // local data
      await _conversationRepo.local.openConversationsBox();
      final dataSavedAtLocal = await _conversationRepo.local.getConversations();
      _conversationsSubject.sink.add(dataSavedAtLocal);

      _conversationRepo.remote
          .conversationsDataStream(userId: currentUser.profile!.id!)
          .listen((convers) async {
        _conversationsSubject.sink.add(convers ?? []);
        conversations = convers ?? [];
        await _handleConversationsBox(conversations: convers);
      });

      emit(ConversationInitial(
        conversationsStream: _conversationsSubject.stream,
        userId: currentUser.profile!.id!,
      ));
    });
  }

  Future<UserProfile?> getFriendInfomation({required String id}) async =>
      await _userInformation.remote.getInformationById(id: id);

  Future<void> _handleConversationsBox({
    required Iterable<Conversation>? conversations,
  }) async {
    if (conversations == null) return;

    for (var element in conversations) {
      await _conversationRepo.local.createConversation(
        conversation: element,
      );
    }
  }

  _updateConversationsData() {
    _conversationsSubject.listen((value) => conversations = value);
  }

  @override
  Future<void> close() async {
    await _conversationsSubject.drain();
    await _conversationsSubject.close();
    return super.close();
  }
}
