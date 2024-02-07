import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
class OptionSelectionModel {
  String _name;
  var selected = false.obs;
  String _image;
  IconData _iconData;
  String _id;

  String get name => _name;
  String get image => _image;
  IconData get iconData => _iconData;


  String get id => _id;

  set id(String value) {
    _id = value;
  }

  set name(String value) {
    _name = value;
  }

  OptionSelectionModel({
      String name, 
      IconData iconData,
      bool selected,
      String image,
      String id,
  }){
    _name = name;
    _iconData = iconData;
    _image = image;
    _id = id;
}

  OptionSelectionModel.fromJson(dynamic json) {
    _name = json["name"];
    _image = json["image"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["image"] = _image;
    return map;
  }


  set image(String value) {
    _image = value;
  }

  set iconData(IconData value) {
    _iconData = value;
  }

}