import 'dart:developer';
import 'dart:math';

import 'package:chat_app/repositories/injector.dart';
import 'package:chat_app/view_model/blocs/search/search_event.dart';
import 'package:chat_app/view_model/blocs/search/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:chat_app/models/user_profile.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  List<UserProfile> friendList = [];
  UserProfile currentUser;

  final _userInformationRepo = UserInformationRepositoryImpl();
  final _usersSubject = ReplaySubject<List<UserProfile>>();
  final _friendsSubject = ReplaySubject<List<UserProfile>>();

  SearchBloc({
    required this.currentUser,
  }) : super(SearchInitialState(
          friendsSubject: ReplaySubject(),
          currentUser: currentUser,
        )) {
    on<SearchingEvent>((event, emit) async {
      if (event.searchName.isNotEmpty) {
        emit(SearchingState(
          loading: true,
          currentUser: currentUser,
        ));
        final listUser = await _userInformationRepo.rmSearchUserByName(
          searchName: event.searchName,
        );
        _usersSubject.add(listUser);
        emit(SearchingState(
          usersSubject: _usersSubject,
          currentUser: currentUser,
        ));
      } else if (friendList.isEmpty) {
        emit(SearchInitialState(
          friendsSubject: _friendsSubject,
          currentUser: currentUser,
        ));
        friendList = await _userInformationRepo.rmSearchUserByName(
          searchName: event.searchName,
        );
        _friendsSubject.add(friendList);
        emit(SearchInitialState(
          friendsSubject: _friendsSubject,
          currentUser: currentUser,
        ));
      } else {
        emit(SearchInitialState(
          friendsSubject: _friendsSubject,
          currentUser: currentUser,
        ));
      }
    });
  }
}
