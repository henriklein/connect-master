class NotificationSubmitModel {
  List<Data> _data;

  List<Data> get data => _data;

  NotificationSubmitModel({
      List<Data> data}){
    _data = data;
}

  NotificationSubmitModel.fromJson(dynamic json) {
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
  String _key;
  String _name;
  String _value;

  String get key => _key;
  String get name => _name;
  String get value => _value;

  Data({
      String key, 
      String name,
    String value}){
    _key = key;
    _value = value;
    _name = name;
}

  Data.fromJson(dynamic json) {
    _key = json["key"];
    _value = json["value"];
    _name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["key"] = _key;
    map["value"] = _value;
    map["name"] = _name;
    return map;
  }

}