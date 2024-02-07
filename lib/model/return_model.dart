class ReturnModel {
  bool _status;
  String _message;
  int _eventId;

  bool get status => _status;
  String get message => _message;
  int get eventId => _eventId;

  ReturnModel({
      bool status, 
      int eventId,
      String message}){
    _status = status;
    _message = message;
    _eventId = eventId;
}

  ReturnModel.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _eventId = json["event_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    map["event_id"] = _eventId;
    return map;
  }

}