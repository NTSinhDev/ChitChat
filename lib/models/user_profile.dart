import 'package:chat_app/models/profile.dart';
import 'package:chat_app/models/url_image.dart';

class UserProfile {
  final Profile? profile;
  final URLImage urlImage;
  UserProfile({this.profile, required this.urlImage});

  @override
  String toString() => 'UserProfile(profile: $profile, urlImage: $urlImage)';

  @override
  bool operator ==(covariant UserProfile other) {
    if (identical(this, other)) return true;

    return other.profile == profile && other.urlImage == urlImage;
  }

  @override
  int get hashCode => profile.hashCode ^ urlImage.hashCode;
}
