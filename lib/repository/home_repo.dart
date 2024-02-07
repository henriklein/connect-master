import 'dart:convert';
import 'dart:io';
import 'package:c0nnect/helper/api_urls.dart';
import 'package:c0nnect/helper/shared_prefs.dart';
import 'package:c0nnect/model/event_details_model.dart';
import 'package:c0nnect/model/events_model.dart';
import 'package:c0nnect/model/friend_request_model.dart';
import 'package:c0nnect/model/friends_model.dart';
import 'package:c0nnect/model/map_model.dart';
import 'package:c0nnect/model/media_link_model.dart';
import 'package:c0nnect/model/memories_model.dart';
import 'package:c0nnect/model/my_interest_model.dart';
import 'package:c0nnect/model/my_profile_model.dart';
import 'package:c0nnect/model/notification_submit_model.dart';
import 'package:c0nnect/model/participant_model.dart';
import 'package:c0nnect/model/return_model.dart';
import 'package:c0nnect/model/together_model.dart';
import 'package:c0nnect/model/user_profile_model.dart';
import 'package:dio/dio.dart';
import 'package:c0nnect/model/contact_model.dart';


class HomeRepo {

  Future<EventsModel> getEventsList(params) async {
    var dio = Dio();
    Response response = await dio.get(
      ApiUrls.eventsList,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
      }),
      queryParameters: params
    );
    print('API RESPONSE EVENTS LIST : ${response.toString()}');
    EventsModel eventsModel = EventsModel.fromJson(jsonDecode(response.toString()));
    return eventsModel;
  }

  Future<FriendRequestModel> getFriendRequest() async {
    var dio = Dio();
    Response response = await dio.get(
      ApiUrls.getFriendRequest,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
      }),
    );
    print('API RESPONSE FRIEND REQUEST : ${response.toString()}');
    FriendRequestModel data = FriendRequestModel.fromJson(jsonDecode(response.toString()));
    return data;
  }

  Future<ReturnModel> postContact(params) async {
    print(params);
    var dio = Dio();
    Response response = await dio.post(
      ApiUrls.postContact,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
      }),
      data: params
    );
    print('API RESPONSE CONTACT POST : ${response.toString()}');
    ReturnModel returnModel = ReturnModel.fromJson(jsonDecode(response.toString()));
    return returnModel;
  }

  Future<ContactModel> getContactList(params) async {

    var dio = Dio();
    Response response = await dio.get(
      ApiUrls.getContact,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
      }),
      queryParameters: params
    );
    print('API RESPONSE CONTACT LIST : ${response.toString()}');
    ContactModel contactModel = ContactModel.fromJson(jsonDecode(response.toString()));
    return contactModel;
  }


  Future<ReturnModel> createEvent(params) async {

    var dio = Dio();
    Response response = await dio.post(
      ApiUrls.createPost,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
      }),
      data: params
    );
    print('API RESPONSE CREATE EVENT : ${response.toString()}');
    ReturnModel returnModel = ReturnModel.fromJson(jsonDecode(response.toString()));
    return returnModel;
  }

  Future<ReturnModel> createChallenge(params) async {

    var dio = Dio();
    Response response = await dio.post(
      ApiUrls.createPost,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
      }),
      data: params
    );
    print('API RESPONSE CREATE EVENT : ${response.toString()}');
    ReturnModel returnModel = ReturnModel.fromJson(jsonDecode(response.toString()));
    return returnModel;
  }

  Future<ReturnModel> updateEvent(params,eventId) async {

    String url = ApiUrls.BASE_URL+"/event/"+eventId;
    var dio = Dio();
    Response response = await dio.put(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
      }),
      data: params
    );
    print('API RESPONSE UPDATE EVENT : ${response.toString()}');
    ReturnModel returnModel = ReturnModel.fromJson(jsonDecode(response.toString()));
    return returnModel;
  }

  Future<ReturnModel> sendEventInvite(eventId,params) async {

    String url = ApiUrls.BASE_URL + "/invitation/"+eventId+"/send";
    var dio = Dio();
    Response response = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
      }),
      data: params
    );
    print('API RESPONSE CREATE EVENT : ${response.toString()}');
    ReturnModel returnModel = ReturnModel.fromJson(jsonDecode(response.toString()));
    return returnModel;
  }

  Future<ReturnModel> sendFriendRequest(params) async {

    String url = ApiUrls.friendRequest;
    var dio = Dio();
    Response response = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
      }),
      data: params
    );
    print('API RESPONSE FRIEND REQUEST : ${response.toString()}');
    ReturnModel returnModel = ReturnModel.fromJson(jsonDecode(response.toString()));
    return returnModel;
  }

  Future<ReturnModel> acceptInvitation(eventId) async {

    String url = ApiUrls.BASE_URL+"/invitation/"+eventId+"/accept";
    var dio = Dio();
    Response response = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
      }),
    );
    print('API RESPONSE ACCEPT INVITATION: ${response.toString()}');
    ReturnModel returnModel = ReturnModel.fromJson(jsonDecode(response.toString()));
    return returnModel;
  }

  Future<ReturnModel> rejectInvitation(eventId,params) async {

    String url = ApiUrls.BASE_URL+"/invitation/"+eventId+"/reject";
    var dio = Dio();
    Response response = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
      }),
      data: params
    );
    print('API RESPONSE REJECT INVITATION : ${response.toString()}');
    ReturnModel returnModel = ReturnModel.fromJson(jsonDecode(response.toString()));
    return returnModel;
  }

  Future<ReturnModel> acceptRejectFriendRequest(requestId,params) async {

    String url = ApiUrls.BASE_URL+"/friend/"+requestId+"/ack_request";
    var dio = Dio();
    Response response = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
      }),
      data: params
    );
    print('API RESPONSE REJECT INVITATION : ${response.toString()}');
    ReturnModel returnModel = ReturnModel.fromJson(jsonDecode(response.toString()));
    return returnModel;
  }

  Future<MyProfileModel> getProfileData() async {

    String url = ApiUrls.myProfile;
    var dio = Dio();
    Response response = await dio.get(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
      }),
    );
    print('API RESPONSE MY PROFILE  : ${response.toString()}');
    MyProfileModel returnModel = MyProfileModel.fromJson(jsonDecode(response.toString()));
    return returnModel;
  }

  Future<ReturnModel> postUserEdit(params) async {
    FormData formData = FormData.fromMap(params);

    var dio = Dio();
    Response response = await dio.post(
        ApiUrls.editProfile,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
        data: formData
    );
    ReturnModel returnModel = ReturnModel.fromJson(jsonDecode(response.toString()));
    print('API RESPONSE EDIT : ${response.toString()}');
    return returnModel;
  }

  Future<UserProfileModel> getUserProfile(userId) async {

    String url = ApiUrls.BASE_URL + "/profile/"+userId;
    var dio = Dio();
    Response response = await dio.get(
        url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
    );
    print('API RESPONSE USER PROFILE : ${response.toString()}');
    UserProfileModel userProfileModel = UserProfileModel.fromJson(jsonDecode(response.toString()));
    return userProfileModel;
  }

  Future<UserProfileModel> getScannedUser(params) async {

    String url = ApiUrls.scanUser;
    var dio = Dio();
    Response response = await dio.get(
        url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
      queryParameters: params
    );
    print('API RESPONSE SCANNED USER : ${response.toString()}');
    UserProfileModel userProfileModel = UserProfileModel.fromJson(jsonDecode(response.toString()));
    return userProfileModel;
  }

  Future<TogetherModel> getTogetherData(userId) async {

    String url = ApiUrls.BASE_URL+"/user/"+userId+"/together";
    var dio = Dio();
    Response response = await dio.get(
        url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
    );
    print('API RESPONSE TOGETHER DATA : ${response.toString()}');
    TogetherModel togetherModel = TogetherModel.fromJson(jsonDecode(response.toString()));
    return togetherModel;
  }

  Future<EventDetailsModel> getEventDetails(eventId) async {

    String url = ApiUrls.BASE_URL+"/event/"+eventId;
    var dio = Dio();
    Response response = await dio.get(
        url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
    );
    print('API RESPONSE EVENT DETAILS : ${response.toString()}');
    EventDetailsModel data = EventDetailsModel.fromJson(jsonDecode(response.toString()));
    return data;
  }

  Future<FriendsModel> getFriendsList() async {

    String url = ApiUrls.friendsList;
    var dio = Dio();
    Response response = await dio.get(
        url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
    );
    print('API RESPONSE FRIENDS LIST : ${response.toString()}');
    FriendsModel data = FriendsModel.fromJson(jsonDecode(response.toString()));
    return data;
  }


  Future<MediaLinkModel> getImageLink(params) async {
    FormData formData = FormData.fromMap(params);

    var dio = Dio();
    Response response = await dio.post(
        ApiUrls.getMediaLink,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
        data: formData
    );
    MediaLinkModel data = MediaLinkModel.fromJson(jsonDecode(response.toString()));
    print('API RESPONSE MEDIA LINK  : ${response.toString()}');
    return data;
  }

  Future<ParticipantModel> getEventParticipant(eventId) async {
    var dio = Dio();
    Response response = await dio.get(
        ApiUrls.BASE_URL+"/event/"+eventId+"/participant",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
    );
    print('API RESPONSE PARTICIPANTS  : ${response.toString()}');
    ParticipantModel data = ParticipantModel.fromJson(jsonDecode(response.toString()));
    return data;
  }

  Future<ReturnModel> uploadMemories(eventId,params) async {
    FormData formData = FormData.fromMap(params);

    var dio = Dio();
    Response response = await dio.post(
        ApiUrls.BASE_URL+"/event/"+eventId+"/memories",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
      data: formData
    );
    print('API RESPONSE MEMORIES  : ${response.toString()}');
    ReturnModel data = ReturnModel.fromJson(jsonDecode(response.toString()));
    return data;
  }

  Future<ReturnModel> updateUserLocation(params) async {

    var dio = Dio();
    Response response = await dio.post(
        ApiUrls.userLocation,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
      data: params
    );
    print('API RESPONSE USER LOCATION  : ${response.toString()}');
    ReturnModel data = ReturnModel.fromJson(jsonDecode(response.toString()));
    return data;
  }

  Future<MemoriesModel> getMemories() async {
    var dio = Dio();
    Response response = await dio.get(
        ApiUrls.getMemories,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
    );
    print('API RESPONSE HOME MEMORIES  : ${response.toString()}');
    MemoriesModel data = MemoriesModel.fromJson(jsonDecode(response.toString()));
    return data;
  }

  Future<ReturnModel> sendChatNotification(params) async {
    var dio = Dio();
    Response response = await dio.post(
        ApiUrls.sendChatNotification,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
      data: params
    );
    print('API RESPONSE CHAT NOTI  : ${response.toString()}');
    ReturnModel data = ReturnModel.fromJson(jsonDecode(response.toString()));
    return data;
  }

  Future<MyInterestModel> getSelectedInterest() async {
    var dio = Dio();
    Response response = await dio.get(
        ApiUrls.selectedInterest,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
    );
    print('API RESPONSE SELECTED INTEREST  : ${response.toString()}');
    MyInterestModel data = MyInterestModel.fromJson(jsonDecode(response.toString()));
    return data;
  }

  Future<ReturnModel> updateInterest(params) async {
    var dio = Dio();
    Response response = await dio.post(
        ApiUrls.updateInterest,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
      data: params
    );
    print('API RESPONSE UPDATE INTEREST  : ${response.toString()}');
    ReturnModel data = ReturnModel.fromJson(jsonDecode(response.toString()));
    return data;
  }

  Future<ReturnModel> clearChatCount(params) async {
    var dio = Dio();
    Response response = await dio.post(
        ApiUrls.clearChatCount,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
      data: params
    );
    print('API RESPONSE CLEAR CHAT COUNT  : ${response.toString()}');
    ReturnModel data = ReturnModel.fromJson(jsonDecode(response.toString()));
    return data;
  }

  Future<MapModel> getMapData() async {
    var dio = Dio();
    Response response = await dio.get(
        ApiUrls.mapData,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
    );
    print('API RESPONSE MAP DATA  : ${response.toString()}');
    MapModel data = MapModel.fromJson(jsonDecode(response.toString()));
    return data;
  }

  Future<ReturnModel> cancelEvent(id) async {
    var dio = Dio();
    Response response = await dio.post(
        ApiUrls.BASE_URL + "/event/"+id+"/cancel",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
    );
    print('API RESPONSE CANCEL EVENT  : ${response.toString()}');
    ReturnModel data = ReturnModel.fromJson(jsonDecode(response.toString()));
    return data;
  }

  Future<ReturnModel> reportUser(id,params) async {
    var dio = Dio();
    Response response = await dio.post(
        ApiUrls.BASE_URL + "/user/"+id+"/report",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
      data: params
    );
    print('API RESPONSE REPORT USER  : ${response.toString()}');
    ReturnModel data = ReturnModel.fromJson(jsonDecode(response.toString()));
    return data;
  }

  Future<ReturnModel> notificationSetting(params) async {
    var dio = Dio();
    Response response = await dio.post(
        ApiUrls.notificationSetting,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
      data: params
    );
    print('API RESPONSE REPORT USER  : ${response.toString()}');
    ReturnModel data = ReturnModel.fromJson(jsonDecode(response.toString()));
    return data;
  }

  Future<NotificationSubmitModel> getNotificationSetting(params) async {
    var dio = Dio();
    Response response = await dio.get(
        ApiUrls.notificationSetting,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: UserPreferences().getBearerToken(),
        }),
      queryParameters: params
    );
    print('API RESPONSE NOTIFICATION SETTING  : ${response.toString()}');
    NotificationSubmitModel data = NotificationSubmitModel.fromJson(jsonDecode(response.toString()));
    return data;
  }


}
