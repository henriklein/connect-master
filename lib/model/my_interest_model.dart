class MyInterestModel {
  List<Data> _data;

  List<Data> get data => _data;

  MyInterestModel({
      List<Data> data}){
    _data = data;
}

  MyInterestModel.fromJson(dynamic json) {
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
  String _label;
  String _value;
  String _icon;

  int get id => _id;
  String get label => _label;
  String get value => _value;
  String get icon => _icon;

  Data({
      int id, 
      String label, 
      String value, 
      String icon}){
    _id = id;
    _label = label;
    _value = value;
    _icon = icon;
}

  Data.fromJson(dynamic json) {
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