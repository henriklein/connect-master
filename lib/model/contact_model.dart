class ContactModel {
  List<Data> _data;
  List<Data> get data => _data;

  ContactModel({
      List<Data> data}){
    _data = data;
}

  ContactModel.fromJson(dynamic json) {
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
  String _name;
  String _phone;
  bool _connectUser;
  dynamic _userId;
  bool _friend;
  String _profileImage;
  bool isSelected = false;

  String get name => _name;
  String get phone => _phone;
  bool get connectUser => _connectUser;
  dynamic get userId => _userId;
  bool get friend => _friend;
  String get profileImage => _profileImage;


  set friend(bool value) {
    _friend = value;
  }

  Data({
      String name, 
      String phone, 
      String profileImage,
      bool connectUser,
      dynamic userId, 
      bool friend}){
    _name = name;
    _phone = phone;
    _connectUser = connectUser;
    _userId = userId;
    _friend = friend;
    _profileImage = profileImage;
}

  Data.fromJson(dynamic json) {
    _name = json["name"];
    _phone = json["phone"];
    _connectUser = json["connect_user"];
    _userId = json["user_id"];
    _friend = json["friend"];
    _profileImage = json["profile_image"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["phone"] = _phone;
    map["connect_user"] = _connectUser;
    map["user_id"] = _userId;
    map["friend"] = _friend;
    map["profile_image"] = _profileImage;
    return map;
  }

}