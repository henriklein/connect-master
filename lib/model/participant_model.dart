class ParticipantModel {
  List<Data> _data;

  List<Data> get data => _data;

  ParticipantModel({
      List<Data> data}){
    _data = data;
}

  ParticipantModel.fromJson(dynamic json) {
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

  int get id => _id;
  String get name => _name;
  String get profileImage => _profileImage;

  Data({
      int id, 
      String name, 
      String profileImage}){
    _id = id;
    _name = name;
    _profileImage = profileImage;
}

  Data.fromJson(dynamic json) {
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