class Profile {
  String? id;
  final String email;
  String fullName;
  String? messagingToken;

  Profile({
    this.id,
    required this.email,
    required this.fullName,
    this.messagingToken,
  });
}
