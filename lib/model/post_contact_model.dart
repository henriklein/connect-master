class PostContactModel {
  String _phone;
  String _name;

  String get phone => _phone;
  String get name => _name;

  PostContactModel({
      String phone,
      String name}){
    _phone = phone;
    _name = name;
}

  PostContactModel.fromJson(dynamic json) {
    _phone = json["phone"];
    _name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["phone"] = _phone;
    map["name"] = _name;
    return map;
  }

}