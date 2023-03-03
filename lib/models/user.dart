// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/core/models/user_presence.dart';
import 'package:chat_app/models/user_profile.dart';

class UserInformation {
  final UserProfile informations;
  final UserPresence? state;
  UserInformation({
    required this.informations,
    this.state,
  });
}
