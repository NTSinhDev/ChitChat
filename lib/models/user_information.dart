import 'package:chat_app/models/injector.dart';

class UserInformation {
  final UserProfile informations;
  final UserPresence? presence;
  UserInformation({
    required this.informations,
    this.presence,
  });
}
