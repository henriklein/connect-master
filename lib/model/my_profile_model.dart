class MyProfileModel {
  Data _data;

  Data get data => _data;

  MyProfileModel({
      Data data}){
    _data = data;
}

  MyProfileModel.fromJson(dynamic json) {
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
  String _firstName;
  String _lastName;
  String _phone;
  String _dob;
  String _bio;
  String _email;
  String _photo;
  String _gender;
  String _address;
  String _facebook;
  String _instagram;
  String _twitter;
  String _snapchat;
  String _qrCode;
  List<Categories> _categories;
  int _mutualFriends;
  int _lastSeen;
  bool _friendStatus;
  String _signUpDate;
  List<Statistics> _statistics;

  int get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get phone => _phone;
  String get dob => _dob;
  String get bio => _bio;
  String get email => _email;
  String get photo => _photo;
  String get gender => _gender;
  String get address => _address;
  String get facebook => _facebook;
  String get instagram => _instagram;
  String get twitter => _twitter;
  String get snapchat => _snapchat;
  String get qrCode => _qrCode;
  List<Categories> get categories => _categories;
  int get mutualFriends => _mutualFriends;
  int get lastSeen => _lastSeen;
  bool get friendStatus => _friendStatus;
  String get signUpDate => _signUpDate;
  List<Statistics> get statistics => _statistics;

  Data({
      int id, 
      String firstName, 
      String lastName, 
      String phone, 
      String dob, 
      String bio, 
      String email, 
      String photo, 
      String gender, 
      String address, 
      String facebook, 
      String instagram, 
      String twitter, 
      String snapchat, 
      String qrCode, 
      List<Categories> categories, 
      int mutualFriends, 
      int lastSeen, 
      bool friendStatus, 
      String signUpDate, 
      List<Statistics> statistics}){
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _phone = phone;
    _dob = dob;
    _bio = bio;
    _email = email;
    _photo = photo;
    _gender = gender;
    _address = address;
    _facebook = facebook;
    _instagram = instagram;
    _twitter = twitter;
    _snapchat = snapchat;
    _qrCode = qrCode;
    _categories = categories;
    _mutualFriends = mutualFriends;
    _lastSeen = lastSeen;
    _friendStatus = friendStatus;
    _signUpDate = signUpDate;
    _statistics = statistics;
}

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _firstName = json["first_name"];
    _lastName = json["last_name"];
    _phone = json["phone"];
    _dob = json["dob"];
    _bio = json["bio"];
    _email = json["email"];
    _photo = json["photo"];
    _gender = json["gender"];
    _address = json["address"];
    _facebook = json["facebook"];
    _instagram = json["instagram"];
    _twitter = json["twitter"];
    _snapchat = json["snapchat"];
    _qrCode = json["qr_code"];
    if (json["categories"] != null) {
      _categories = [];
      json["categories"].forEach((v) {
        _categories.add(Categories.fromJson(v));
      });
    }
    _mutualFriends = json["mutual_friends"];
    _lastSeen = json["last_seen"];
    _friendStatus = json["friend_status"];
    _signUpDate = json["sign_up_date"];
    if (json["statistics"] != null) {
      _statistics = [];
      json["statistics"].forEach((v) {
        _statistics.add(Statistics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["first_name"] = _firstName;
    map["last_name"] = _lastName;
    map["phone"] = _phone;
    map["dob"] = _dob;
    map["bio"] = _bio;
    map["email"] = _email;
    map["photo"] = _photo;
    map["gender"] = _gender;
    map["address"] = _address;
    map["facebook"] = _facebook;
    map["instagram"] = _instagram;
    map["twitter"] = _twitter;
    map["snapchat"] = _snapchat;
    map["qr_code"] = _qrCode;
    if (_categories != null) {
      map["categories"] = _categories.map((v) => v.toJson()).toList();
    }
    map["mutual_friends"] = _mutualFriends;
    map["last_seen"] = _lastSeen;
    map["friend_status"] = _friendStatus;
    map["sign_up_date"] = _signUpDate;
    if (_statistics != null) {
      map["statistics"] = _statistics.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Statistics {
  String _label;
  int _value;
  String _icon;

  String get label => _label;
  int get value => _value;
  String get icon => _icon;

  Statistics({
      String label, 
      int value, 
      String icon}){
    _label = label;
    _value = value;
    _icon = icon;
}

  Statistics.fromJson(dynamic json) {
    _label = json["label"];
    _value = json["value"];
    _icon = json["icon"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["label"] = _label;
    map["value"] = _value;
    map["icon"] = _icon;
    return map;
  }

}

class Categories {
  int _id;
  String _label;
  String _value;
  String _icon;

  int get id => _id;
  String get label => _label;
  String get value => _value;
  String get icon => _icon;

  Categories({
      int id, 
      String label, 
      String value, 
      String icon}){
    _id = id;
    _label = label;
    _value = value;
    _icon = icon;
}

  Categories.fromJson(dynamic json) {
    _id = json["id"];
    _label = json["label"];
    _value = json["value"];
    _icon = json["icon"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["label"] = _label;
    map["value"] = _value;
    map["icon"] = _icon;
    return map;
  }

}