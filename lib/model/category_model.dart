class CategoryModel {
  List<Data> _data;

  List<Data> get data => _data;

  CategoryModel({
      List<Data> data}){
    _data = data;
}

  CategoryModel.fromJson(dynamic json) {
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
  String _icon;
  List<Subcategories> _subcategories;
  bool isSelected = false;

  int get id => _id;
  String get name => _name;
  String get icon => _icon;
  List<Subcategories> get subcategories => _subcategories;




  Data({
      int id, 
      String name, 
      String icon, 
      bool isSelected,
      List<Subcategories> subcategories}){
    _id = id;
    _name = name;
    _icon = icon;
    _subcategories = subcategories;
    isSelected = isSelected;
}

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _icon = json["icon"];
    if (json["subcategories"] != null) {
      _subcategories = [];
      json["subcategories"].forEach((v) {
        _subcategories.add(Subcategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["icon"] = _icon;
    if (_subcategories != null) {
      map["subcategories"] = _subcategories.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Subcategories {
  int _id;
  String _name;
  bool _isSelected = false;

  int get id => _id;
  String get name => _name;
  bool get isSelected => _isSelected;


  set isSelected(bool value) {
    _isSelected = value;
  }

  Subcategories({
      int id, 
      String name,
      bool isSelected
  }){
    _id = id;
    _name = name;
    _isSelected = isSelected;
}

  Subcategories.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    return map;
  }

}