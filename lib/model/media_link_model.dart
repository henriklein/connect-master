class MediaLinkModel {
  String _url;
  String _imageName;
  String _thumb;

  String get url => _url;
  String get imageName => _imageName;
  String get thumb => _thumb;

  MediaLinkModel({
      String url, 
      String thumb,
      String imageName}){
    _url = url;
    _thumb = thumb;
    _imageName = imageName;
}

  MediaLinkModel.fromJson(dynamic json) {
    _url = json["url"];
    _imageName = json["image_name"];
    _thumb = json["thumb"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["url"] = _url;
    map["image_name"] = _imageName;
    map["thumb"] = _thumb;
    return map;
  }

}