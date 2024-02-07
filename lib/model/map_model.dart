class MapModel {
  List<MapData> _data;

  List<MapData> get data => _data;

  MapModel({
      List<MapData> data}){
    _data = data;
}

  MapModel.fromJson(dynamic json) {
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(MapData.fromJson(v));
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

class MapData {
  int _id;
  String _name;
  String _image;
  String _type;
  String _latitude;
  String _longitude;
  String _address;
  String _date;
  String _updatedAt;

  int get id => _id;
  String get name => _name;
  String get image => _image;
  String get type => _type;
  String get latitude => _latitude;
  String get longitude => _longitude;
  String get address => _address;
  String get date => _date;
  String get updatedAt => _updatedAt;

  MapData({
      int id, 
      String name, 
      String image, 
      String type, 
      String latitude, 
      String longitude, 
      String address, 
      String date, 
      String updatedAt}){
    _id = id;
    _name = name;
    _image = image;
    _type = type;
    _latitude = latitude;
    _longitude = longitude;
    _address = address;
    _date = date;
    _updatedAt = updatedAt;
}

  MapData.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _image = json["image"];
    _type = json["type"];
    _latitude = json["latitude"];
    _longitude = json["longitude"];
    _address = json["address"];
    _date = json["date"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["image"] = _image;
    map["type"] = _type;
    map["latitude"] = _latitude;
    map["longitude"] = _longitude;
    map["address"] = _address;
    map["date"] = _date;
    map["updated_at"] = _updatedAt;
    return map;
  }

}