class LoginModel {
  String _token;
  bool _status;
  String _message;
  String _referralCode;
  String _userName;
  String _profileImage;
  int _userId;

  String get token => _token;
  bool get status => _status;
  String get message => _message;
  String get referralCode => _referralCode;
  int get userId => _userId;
  String get userName => _userName;
  String get profileImage => _profileImage;

  LoginModel({
      String token, 
      bool status, 
      String message, 
      String userName,
      String referralCode,
      String profileImage,
      int userId}){
    _token = token;
    _status = status;
    _message = message;
    _userId = userId;
    _referralCode = referralCode;
    _userName = userName;
    _profileImage = profileImage;
}

  LoginModel.fromJson(dynamic json) {
    _token = json["token"];
    _status = json["status"];
    _message = json["message"];
    _userId = json["user_id"];
    _referralCode = json["referral_code"];
    _userName = json["user_name"];
    _profileImage = json["image"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["token"] = _token;
    map["status"] = _status;
    map["message"] = _message;
    map["user_id"] = _userId;
    map["referral_code"] = _referralCode;
    map["image"] = _profileImage;
    map["user_name"] = _userName;
    return map;
  }

}