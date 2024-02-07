class TogetherModel {
  List<Data> _data;

  List<Data> get data => _data;

  TogetherModel({
      List<Data> data}){
    _data = data;
}

  TogetherModel.fromJson(dynamic json) {
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
  String _category;
  String _title;
  String _day;
  String _duration;
  Creator _creator;
  int _invitedUsersCount;
  String _description;
  String _eventDate;
  String _startTime;
  String _endTime;
  String _status;
  String _address;
  String _latitude;
  String _longitude;
  String _createdAt;
  String _type;

  int get id => _id;
  String get category => _category;
  String get title => _title;
  String get day => _day;
  String get duration => _duration;
  Creator get creator => _creator;
  int get invitedUsersCount => _invitedUsersCount;
  String get description => _description;
  String get eventDate => _eventDate;
  String get startTime => _startTime;
  String get endTime => _endTime;
  String get status => _status;
  String get address => _address;
  String get latitude => _latitude;
  String get longitude => _longitude;
  String get createdAt => _createdAt;
  String get type => _type;

  Data({
      int id, 
      String category, 
      String title, 
      String day, 
      String duration, 
      Creator creator, 
      int invitedUsersCount, 
      String description, 
      String eventDate, 
      String startTime, 
      String endTime, 
      String status, 
      String address, 
      String latitude, 
      String longitude, 
      String type,
      String createdAt}){
    _id = id;
    _category = category;
    _title = title;
    _day = day;
    _duration = duration;
    _creator = creator;
    _invitedUsersCount = invitedUsersCount;
    _description = description;
    _eventDate = eventDate;
    _startTime = startTime;
    _endTime = endTime;
    _status = status;
    _address = address;
    _latitude = latitude;
    _longitude = longitude;
    _createdAt = createdAt;
    _type = type;
}

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _category = json["category"];
    _title = json["title"];
    _day = json["day"];
    _duration = json["duration"];
    _creator = json["creator"] != null ? Creator.fromJson(json["creator"]) : null;
    _invitedUsersCount = json["invited_users_count"];
    _description = json["description"];
    _eventDate = json["event_date"];
    _startTime = json["start_time"];
    _endTime = json["end_time"];
    _status = json["status"];
    _address = json["address"];
    _latitude = json["latitude"];
    _longitude = json["longitude"];
    _createdAt = json["created_at"];
    _type = json["type"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["category"] = _category;
    map["title"] = _title;
    map["day"] = _day;
    map["duration"] = _duration;
    if (_creator != null) {
      map["creator"] = _creator.toJson();
    }
    map["invited_users_count"] = _invitedUsersCount;
    map["description"] = _description;
    map["event_date"] = _eventDate;
    map["start_time"] = _startTime;
    map["end_time"] = _endTime;
    map["status"] = _status;
    map["address"] = _address;
    map["latitude"] = _latitude;
    map["longitude"] = _longitude;
    map["created_at"] = _createdAt;
    map["type"] = _type;
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