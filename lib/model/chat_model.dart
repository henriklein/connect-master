class ChatModel {
  List<Chats> _chats;
  List<Users> _users;


  List<Chats> get chats => _chats;
  List<Users> get users => _users;


  set chats(List<Chats> value) {
    _chats = value;
  }



  ChatModel({
      List<Chats> chats, 
      List<Users> users,

  }){
    _chats = chats;
    _users = users;

}

  ChatModel.fromJson(Map<String,dynamic> json) {
    if (json["chats"] != null) {
      _chats = [];
      json["chats"].forEach((v) {
        _chats.add(Chats.fromJson(v));
      });
    }
    if (json["users"] != null) {
      _users = [];
      json["users"].forEach((v) {
        _users.add(Users.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_chats != null) {
      map["chats"] = _chats.map((v) => v.toJson()).toList();
    }
    if (_users != null) {
      map["users"] = _users.map((v) => v.toJson()).toList();
    }

    return map;
  }

  set users(List<Users> value) {
    _users = value;
  }


}

class Users {
  String _name;
  String _image;
  int _id;
  bool _isOnline = false;

  String get name => _name;
  String get image => _image;
  int get id => _id;
  bool get isOnline => _isOnline;


  set isOnline(bool value) {
    _isOnline = value;
  }

  Users({
      String name, 
      String image,
      bool isOnline,
      int id}){
    _name = name;
    _image = image;
    _id = id;
    _isOnline = _isOnline;
}

  Users.fromJson(Map<String,dynamic> json) {
    _name = json["name"];
    _id = json["id"];
    _image = json["image"];
    _isOnline = json["online"] ?? false;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["id"] = _id;
    map["image"] = _image;
    map["online"]  = _isOnline;
    return map;
  }

}

class Chats {
  String _text;
  String _sender;
  String _senderId;
  String _time;
  String _imageName;
  String _imageUrl;
  String _videoUrl;


  String get text => _text;
  String get sender => _sender;
  String get senderId => _senderId;
  String get time => _time;
  String get imageName => _imageName;
  String get imageUrl => _imageUrl;
  String get videoUrl => _videoUrl;


  set imageUrl(String value) {
    _imageUrl = value;
  }


  set videoUrl(String value) {
    _videoUrl = value;
  }

  Chats({
      String text, 
      String sender, 
      String time,
      String imageName,
      String imageUrl,
      String videoUrl,
      String senderId}){
    _text = text;
    _sender = sender;
    _time = time;
    _senderId = senderId;
    _imageName = imageName;
    _imageUrl = imageUrl;
    _videoUrl = videoUrl;
}

  Chats.fromJson(Map<String,dynamic> json) {
    _text = json["text"];
    _sender = json["sender"];
    _senderId = json["sender_id"];
    _time = json["time"];
    _imageName = json["image_name"];
    _imageUrl = json["image_url"];
    _videoUrl = json["video_url"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["text"] = _text;
    map["sender"] = _sender;
    map["sender_id"] = _senderId;
    map["time"] = _time;
    map["image_name"] = _imageName;
    map["image_url"] = _imageUrl;
    map["video_url"] = _videoUrl;
    return map;
  }

}