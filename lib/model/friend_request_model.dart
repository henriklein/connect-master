class FriendRequestModel {
  List<RequestData> _data;

  List<RequestData> get data => _data;

  FriendRequestModel({
      List<RequestData> data}){
    _data = data;
}

  FriendRequestModel.fromJson(dynamic json) {
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(RequestData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_data != null) {
      map["data"] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class RequestData {
  int _id;
  User _user;
  String _status;
  String _createdAt;

  int get id => _id;
  User get user => _user;
  String get status => _status;
  String get createdAt => _createdAt;

  RequestData({
      int id, 
      User user, 
      String status, 
      String createdAt}){
    _id = id;
    _user = user;
    _status = status;
    _createdAt = createdAt;
}

  RequestData.fromJson(dynamic json) {
    _id = json["id"];
    _user = json["user"] != null ? User.fromJson(json["user"]) : null;
    _status = json["status"];
    _createdAt = json["created_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    if (_user != null) {
      map["user"] = _user.toJson();
    }
    map["status"] = _status;
    map["created_at"] = _createdAt;
    return map;
  }

}

class User {
  int _id;
  String _name;
  String _profileImage;

  int get id => _id;
  String get name => _name;
  String get profileImage => _profileImage;

  User({
      int id, 
      String name, 
      String profileImage}){
    _id = id;
    _name = name;
    _profileImage = profileImage;
}

  User.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _profileImage = json["profile_image"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["profile_image"] = _profileImage;
    return map;
  }

}