import 'package:chat_app/models/injector.dart';
import 'package:chat_app/data/repositories/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final UserProfile currentUser;

  final _userInformationRepo = UserInformationRepository();
  final _conversationRepo = ConversationsRepository();

  final _usersSubject = ReplaySubject<List<UserProfile>>();
  final _friendsSubject = ReplaySubject<List<UserProfile>>();

  String _searchKeyWhenComeBack = '';

  SearchBloc({
    required this.currentUser,
    required Stream<List<UserProfile>> stream,
  }) : super(SearchInitialState(
          friendsSubject: ReplaySubject(),
          currentUser: currentUser,
        )) {
    stream.listen((friends) => _friendsSubject.sink.add(friends));
    on<SearchingEvent>((event, emit) async {
      _searchKeyWhenComeBack = event.searchName;
      // show all friends
      if (event.searchName.isEmpty) {
        return emit(
          SearchInitialState(
            friendsSubject: _friendsSubject,
            currentUser: currentUser,
          ),
        );
      }
      // get friends by key search
      emit(SearchingState(loading: true, currentUser: currentUser));
      final listUser = await _userInformationRepo.remote.searchUserByName(
        searchName: event.searchName,
      );
      _usersSubject.add(listUser);
      if (state is SearchingState) {
        emit(SearchingState(
          usersSubject: _usersSubject,
          currentUser: currentUser,
        ));
      }
    });
    on<JoinConversationEvent>((event, emit) async {
      if (event.userIDs[0].isEmpty || event.userIDs[0].isEmpty) {
        return emit(SearchInitialState(
          friendsSubject:
              _searchKeyWhenComeBack.isEmpty ? _friendsSubject : _usersSubject,
          currentUser: currentUser,
          error: "Error when get conversation data!",
        ));
      }

      final conversation = await _conversationRepo.remote.getConversationData(
        userIDs: event.userIDs,
      );

      emit(JoinConversationState(
        friend: event.friend,
        conversation: conversation,
        currentUser: currentUser,
      ));
    });
    on<ComeBackSearchScreenEvent>((event, emit) {
      return emit(SearchInitialState(
        friendsSubject:
            _searchKeyWhenComeBack.isEmpty ? _friendsSubject : _usersSubject,
        currentUser: currentUser,
      ));
    });
  }

  @override
  Future<void> close() {
    _usersSubject.drain();
    _usersSubject.close();
    _friendsSubject.drain();
    _friendsSubject.close();
    return super.close();
  }
}
