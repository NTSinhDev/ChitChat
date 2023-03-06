import 'package:chat_app/models/injector.dart';
import 'package:chat_app/data/repositories/injector.dart';
import 'package:chat_app/view_model/blocs/search/bloc_injector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  List<UserProfile> friendList = [];
  UserProfile currentUser;

  final _userInformationRepo = UserInformationRepositoryImpl();
  final _conversationRepo = ConversationsRepositoryImpl();
  final _usersSubject = ReplaySubject<List<UserProfile>>();
  final _friendsSubject = ReplaySubject<List<UserProfile>>();

  SearchBloc({
    required this.currentUser,
  }) : super(SearchInitialState(
          friendsSubject: ReplaySubject(),
          currentUser: currentUser,
        )) {
    on<SearchingEvent>((event, emit) async {
      if (event.searchName.isNotEmpty) return _searchingByName(event, emit);

      if (friendList.isEmpty) return _getFriendList(event, emit);

      return emit(SearchInitialState(
        friendsSubject: _friendsSubject,
        currentUser: currentUser,
      ));
    });

    on<JoinConversationEvent>((event, emit) async {
      if (event.userIDs[0].isEmpty || event.userIDs[0].isEmpty) {
        return emit(SearchInitialState(
          friendsSubject: event.usersSubject,
          currentUser: currentUser,
          error: "Error when get conversation data!",
        ));
      }

      final conversation = await _conversationRepo.getConversationData(
        userIDs: event.userIDs,
      );

      final friendInformation = UserInformation(informations: event.friend);
      emit(JoinConversationState(
        friend: friendInformation,
        conversation: conversation,
        currentUser: currentUser,
      ));
    });
  }

  _searchingByName(SearchingEvent event, Emitter<SearchState> emit) async {
    emit(SearchingState(loading: true, currentUser: currentUser));
    final listUser = await _userInformationRepo.rmSearchUserByName(
      searchName: event.searchName,
    );
    _usersSubject.add(listUser);
    emit(SearchingState(usersSubject: _usersSubject, currentUser: currentUser));
  }

  _getFriendList(SearchingEvent event, Emitter<SearchState> emit) async {
    emit(
      SearchInitialState(
        friendsSubject: _friendsSubject,
        currentUser: currentUser,
      ),
    );
    friendList = await _userInformationRepo.rmSearchUserByName(
      searchName: event.searchName,
    );
    _friendsSubject.add(friendList);
    emit(
      SearchInitialState(
        friendsSubject: _friendsSubject,
        currentUser: currentUser,
      ),
    );
  }
}
