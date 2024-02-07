class FriendsModel {
  List<Data> _data;

  List<Data> get data => _data;


  set data(List<Data> value) {
    _data = value;
  }

  FriendsModel({
      List<Data> data}){
    _data = data;
}

  FriendsModel.fromJson(dynamic json) {
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Data.fromJson(v));
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

class Data {
  int _id;
  String _name;
  String _profileImage;
  String _chatId;
  String _message;
  String _chatType;
  String _timeAgo;
  int _unreadCount;
  bool _ring;

  int get id => _id;
  String get name => _name;
  String get profileImage => _profileImage;
  String get chatId => _chatId;
  String get message => _message;
  String get chatType => _chatType;
  String get timeAgo => _timeAgo;
  int get unreadCount => _unreadCount;
  bool get ring => _ring;

  Data({
      int id, 
      String name, 
      String profileImage, 
      String chatId, 
      String message, 
      int unreadCount, 
      String chatType,
      String timeAgo,
      bool ring}){
    _id = id;
    _name = name;
    _profileImage = profileImage;
    _chatId = chatId;
    _message = message;
    _unreadCount = unreadCount;
    _ring = ring;
    _chatType = chatType;
    _timeAgo = timeAgo;
}

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _profileImage = json["profile_image"];
    _chatId = json["chat_id"];
    _message = json["message"];
    _unreadCount = json["unread_count"];
    _ring = json["ring"];
    _chatType = json["chat_type"];
    _timeAgo = json["time_ago"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["profile_image"] = _profileImage;
    map["chat_id"] = _chatId;
    map["message"] = _message;
    map["unread_count"] = _unreadCount;
    map["ring"] = _ring;
    map["chat_type"] = _chatType;
    map["time_ago"] = _timeAgo;
    return map;
  }

}