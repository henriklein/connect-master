class EventDetailsModel {
  Data _data;

  Data get data => _data;

  EventDetailsModel({
      Data data}){
    _data = data;
}

  EventDetailsModel.fromJson(dynamic json) {
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_data != null) {
      map["data"] = _data.toJson();
    }
    return map;
  }

}

class Data {
  int _id;
  int _categoryId;
  String _category;
  String _subCategory;
  String _title;
  String _eventType;
  String _eventLink;
  String _day;
  String _duration;
  Creator _creator;
  int _invitedUsersCount;
  List<Invited_users> _invitedUsers;
  String _description;
  String _eventDate;
  String _eventDateFormat;
  String _startTime;
  String _startTimeFormat;
  String _endTime;
  String _endTimeFormat;
  String _address;
  String _latitude;
  String _longitude;
  int _countDown;
  bool _public;
  List<String> _media;
  List<String> _eventMemories;
  String _status;
  String _createdAt;
  String thumImage = "";
  String _eventStatus;

  int get id => _id;
  int get categoryId => _categoryId;
  String get category => _category;
  String get subCategory => _subCategory;
  String get title => _title;
  String get eventType => _eventType;
  String get eventLink => _eventLink;
  String get day => _day;
  String get duration => _duration;
  Creator get creator => _creator;
  int get invitedUsersCount => _invitedUsersCount;
  List<Invited_users> get invitedUsers => _invitedUsers;
  String get description => _description;
  String get eventDate => _eventDate;
  String get eventDateFormat => _eventDateFormat;
  String get startTime => _startTime;
  String get startTimeFormat => _startTimeFormat;
  String get endTime => _endTime;
  String get endTimeFormat => _endTimeFormat;
  String get address => _address;
  String get latitude => _latitude;
  String get longitude => _longitude;
  bool get public => _public;
  List<String> get media => _media;
  List<String> get eventMemories => _eventMemories;
  String get status => _status;
  String get createdAt => _createdAt;
  int get countDown => _countDown;
  String get eventStatus => _eventStatus;

  Data({
      int id, 
      int categoryId, 
      String category, 
      String subCategory, 
      String title, 
      String eventType, 
      String eventLink, 
      String day, 
      String duration, 
      Creator creator, 
      int invitedUsersCount, 
      List<Invited_users> invitedUsers, 
      String description, 
      String eventDate, 
      String eventDateFormat, 
      String startTime, 
      String startTimeFormat, 
      String endTime, 
      String endTimeFormat, 
      String address, 
      String latitude, 
      String longitude, 
      bool public, 
      List<String> media, 
      List<String> eventMemories, 
      String status, 
      int countDown,
      String createdAt,
      String eventStatus
  }){
    _id = id;
    _categoryId = categoryId;
    _category = category;
    _subCategory = subCategory;
    _title = title;
    _eventType = eventType;
    _eventLink = eventLink;
    _day = day;
    _duration = duration;
    _creator = creator;
    _invitedUsersCount = invitedUsersCount;
    _invitedUsers = invitedUsers;
    _description = description;
    _eventDate = eventDate;
    _eventDateFormat = eventDateFormat;
    _startTime = startTime;
    _startTimeFormat = startTimeFormat;
    _endTime = endTime;
    _endTimeFormat = endTimeFormat;
    _address = address;
    _latitude = latitude;
    _longitude = longitude;
    _public = public;
    _media = media;
    _eventMemories = eventMemories;
    _status = status;
    _createdAt = createdAt;
    _countDown = countDown;
    _eventStatus = eventStatus;
}

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _categoryId = json["category_id"];
    _category = json["category"];
    _subCategory = json["sub_category"];
    _title = json["title"];
    _eventType = json["event_type"];
    _eventLink = json["event_link"];
    _day = json["day"];
    _duration = json["duration"];
    _creator = json["creator"] != null ? Creator.fromJson(json["creator"]) : null;
    _invitedUsersCount = json["invited_users_count"];
    if (json["invited_users"] != null) {
      _invitedUsers = [];
      json["invited_users"].forEach((v) {
        _invitedUsers.add(Invited_users.fromJson(v));
      });
    }
    _description = json["description"];
    _eventDate = json["event_date"];
    _eventDateFormat = json["event_date_format"];
    _startTime = json["start_time"];
    _startTimeFormat = json["start_time_format"];
    _endTime = json["end_time"];
    _endTimeFormat = json["end_time_format"];
    _address = json["address"];
    _latitude = json["latitude"];
    _longitude = json["longitude"];
    _public = json["public"];
    _media = json["media"] != null ? json["media"].cast<String>() : [];
    _eventMemories = json["event_memories"] != null ? json["event_memories"].cast<String>() : [];
    _status = json["status"];
    _createdAt = json["created_at"];
    _countDown = json["countdown"];
    _eventStatus = json["event_status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["category_id"] = _categoryId;
    map["category"] = _category;
    map["sub_category"] = _subCategory;
    map["title"] = _title;
    map["event_type"] = _eventType;
    map["event_link"] = _eventLink;
    map["day"] = _day;
    map["duration"] = _duration;
    if (_creator != null) {
      map["creator"] = _creator.toJson();
    }
    map["invited_users_count"] = _invitedUsersCount;
    if (_invitedUsers != null) {
      map["invited_users"] = _invitedUsers.map((v) => v.toJson()).toList();
    }
    map["description"] = _description;
    map["event_date"] = _eventDate;
    map["event_date_format"] = _eventDateFormat;
    map["start_time"] = _startTime;
    map["start_time_format"] = _startTimeFormat;
    map["end_time"] = _endTime;
    map["end_time_format"] = _endTimeFormat;
    map["address"] = _address;
    map["latitude"] = _latitude;
    map["longitude"] = _longitude;
    map["public"] = _public;
    map["media"] = _media;
    map["event_memories"] = _eventMemories;
    map["status"] = _status;
    map["created_at"] = _createdAt;
    map["countdown"] = _countDown;
    map["event_status"] = _eventStatus;
    return map;
  }

}

class Invited_users {
  int _id;
  String _name;
  String _profileImage;
  String _status;
  String _chatId;
  bool _friendStatus;

  int get id => _id;
  String get name => _name;
  String get profileImage => _profileImage;
  String get status => _status;
  String get chatId => _chatId;
  bool get friendStatus => _friendStatus;

  Invited_users({
      int id, 
      String name, 
      String profileImage,
      String status,
      String chatId,
      bool friendStatus
  }){
    _id = id;
    _name = name;
    _profileImage = profileImage;
    _chatId = chatId;
    _status = status;
    _chatId = chatId;
    _friendStatus = friendStatus;
}

  Invited_users.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _profileImage = json["profile_image"];
    _friendStatus = json["friend_status"];
    _status = json["status"];
    _chatId = json["chat_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["profile_image"] = _profileImage;
    map["friend_status"] = _friendStatus;
    map["status"] = _status;
    map["chat_id"] = _chatId;
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