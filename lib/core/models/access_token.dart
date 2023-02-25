class AccessToken {
  String? sId;
  String? accessToken;
  String? userID;
  String? createdAt;
  String? updatedAt;
  int? iV;

  AccessToken(
      {this.sId,
      this.accessToken,
      this.userID,
      this.createdAt,
      this.updatedAt,
      this.iV});

  AccessToken.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    accessToken = json['accessToken'];
    userID = json['userID'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['accessToken'] = accessToken;
    data['userID'] = userID;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}