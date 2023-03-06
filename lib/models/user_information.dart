import 'package:chat_app/models/injector.dart';

class UserInformation {
  final UserProfile informations;
  final UserPresence? state;
  UserInformation({
    required this.informations,
    this.state,
  });
}
