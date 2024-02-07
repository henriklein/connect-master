class MemoriesModel {
  List<Data> _data;

  List<Data> get data => _data;

  MemoriesModel({
      List<Data> data}){
    _data = data;
}

  MemoriesModel.fromJson(dynamic json) {
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
  int _eventId;
  String _name;
  String _description;
  Creator _creator;
  String _address;
  String _type;
  List<String> _media;

  int get eventId => _eventId;
  String get name => _name;
  String get description => _description;
  Creator get creator => _creator;
  String get address => _address;
  String get type => _type;
  List<String> get media => _media;

  Data({
      int eventId, 
      String name, 
      String description, 
      Creator creator, 
      String address, 
      String type,
      List<String> media}){
    _eventId = eventId;
    _name = name;
    _description = description;
    _creator = creator;
    _address = address;
    _media = media;
    _type = type;
}

  Data.fromJson(dynamic json) {
    _eventId = json["event_id"];
    _name = json["name"];
    _description = json["description"];
    _creator = json["creator"] != null ? Creator.fromJson(json["creator"]) : null;
    _address = json["address"];
    _type = json["type"];
    _media = json["media"] != null ? json["media"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["event_id"] = _eventId;
    map["name"] = _name;
    map["type"] = _type;
    map["description"] = _description;
    if (_creator != null) {
      map["creator"] = _creator.toJson();
    }
    map["address"] = _address;
    map["media"] = _media;
    return map;
  }

}

class Creator {
  int _id;
  String _name;
  String _profileImage;

  int get id => _id;
  String get name => _name;
  String get profileImage => _profileImage;

  Creator({
      int id, 
      String name, 
      String profileImage}){
    _id = id;
    _name = name;
    _profileImage = profileImage;
}

  Creator.fromJson(dynamic json) {
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