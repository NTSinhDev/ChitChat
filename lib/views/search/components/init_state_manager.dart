import 'dart:developer';

import 'package:chat_app/models/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/view_model/injector.dart';

class InitializeStateManager extends StatelessWidget {
  final Stream<List<UserProfile>> stream;
  final Widget Function(SearchBloc) response;
  const InitializeStateManager({
    Key? key,
    required this.response,
    required this.stream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthenticationBloc>().userProfile!;
    return BlocProvider<SearchBloc>(
      create: (_) => SearchBloc(
        currentUser: currentUser,
        stream: stream,
      )..add(SearchingEvent(searchName: '')),
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          final SearchBloc searchBloc = context.read<SearchBloc>();
          return response(searchBloc);
        },
      ),
    );
  }
}
