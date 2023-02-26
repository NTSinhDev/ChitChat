// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/models/profile.dart';
import 'package:chat_app/models/url_image.dart';

class UserProfile {
  final Profile? profile;
  final URLImage urlImage;
  UserProfile({
    this.profile,
    required this.urlImage,
  });
}
