import 'package:get_storage/get_storage.dart';

class UserPreferences {
  static const String SHARED_USER_TOKEN = "sharedUserToken";
  static const String SHARED_USER_NAME = "sharedUserName";
  static const String SHARED_USER_IMAGE = "sharedUserImage";
  static const String SHARED_USER_ROLE = "sharedUserRole";
  static const String SHARED_USER_FCM_TOKEN = "sharedUserFcmToken";
  static const String SHARED_SHARE_IMAGE = "sharedShareImage";
  static const String SHARED_LOCALE = "sharedLocale";
  static const String SHARED_THEME = "sharedTheme";
  static const String SHARED_SITE_ID = "sharedSiteID";
  static const String SHARED_VENDOR_ID = "sharedVendorId";
  static const String SHARED_METER_ID = "sharedMeterId";
  static const String SHARED_REPORT_IMAGE = "sharedReportImage";
  static const String SHARED_USER_NUMBER = "sharedUserNumber";
  static const String SHARED_USER_NUMBER_TWO = "sharedUserNumberTwo";
  static const String SHARED_USER_ID = "sharedUserId";
  static const String SHARED_USER_PREMIUM = "sharedUserPremium";
  static const String SHARED_USER_REFERRAL = "sharedUserReferral";
  static const String SHARED_COUNTRY_CODE = "sharedCountryCode";
  static const String SHARED_ONBOARDING = "sharedOnboarding";

  static final UserPreferences _instance = UserPreferences._constructor();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._constructor();

//  SharedPreferences _prefs;

  GetStorage getStorage;

  init() async {
//    _prefs = await SharedPreferences.getInstance();
      getStorage =  GetStorage();
  }

  String get(String key) {
    return getStorage.read(key);
  }

  saveData(String key,String value) {
    getStorage.write(key,value);
  }


  String getBearerToken() {
    return 'Bearer ${getStorage.read(SHARED_USER_TOKEN)}';
  }




}
