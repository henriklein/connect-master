import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:c0nnect/components/icon_btn_with_counter.dart';
import 'package:c0nnect/components/cards.dart';
import 'package:c0nnect/components/constants.dart';
import 'package:c0nnect/helper/shared_prefs.dart';
import 'package:c0nnect/model/friends_model.dart' as friend;
import 'package:c0nnect/model/scan_code.dart';
import 'package:c0nnect/model/user_profile_model.dart';
import 'package:c0nnect/model/notification_submit_model.dart' as notiSubmitModel;
import 'package:c0nnect/my_profile.dart';
import 'package:c0nnect/profile.dart' as profile;
import 'package:c0nnect/profile.dart';
import 'package:c0nnect/repository/home_repo.dart';
import 'package:c0nnect/scan_code_screen.dart';
import 'package:c0nnect/edit_profile_screen.dart';
import 'package:c0nnect/widget/LoadingWidget.dart';
import 'package:c0nnect/widget/ScanSelectionBSWidget.dart';
import 'package:c0nnect/widget/ScannedUserWidget.dart';
import 'package:c0nnect/widget/UserQRCodeWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Setup/completeProfile.dart';
import 'components/default_button.dart';
import 'helper/config.dart';


import 'ChatSystem.dart';
import 'model/chat_model.dart';
import 'model/my_profile_model.dart';
import 'model/notification_submit_model.dart';
import 'model/option_selection_model.dart';
import 'model/participant_model.dart';

void main() => runApp(Contacts());

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> with  AutomaticKeepAliveClientMixin<Contacts>{
  int activeMenu = 0;
  List menu = ["Contact", "Group"];
  String selectedFilter = "single";

  bool isLoading = false;
  MyProfileModel myProfileModel;
  friend.FriendsModel friendsModel;
  List<friend.Data> friendsFilteredList =[];

  ParticipantModel participantModel;
  List<OptionSelectionModel> notificationCenterDataList = [];
  List<OptionSelectionModel> privacySettingDataList = [];


  @override
  void initState() {
    getProfileData();
    getFriendsList();
    getNotificationCenterSetting();
    getPrivacySetting();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: ()async{
        getProfileData();
        getFriendsList();
      },
      child: Scaffold(
        backgroundColor: Colors.green,
        body: Stack(
          children: [
            CustomScrollView(
              // controller: _scrollViewController,

              slivers: [
                SliverAppBar(
                  shadowColor: Colors.transparent,
                  onStretchTrigger: () {
                    HapticFeedback.heavyImpact();
                    return;
                  },
                  expandedHeight: 150.0,
                  floating: false,
                  pinned: true,
                  snap: false,
                  stretch: true,
                  backgroundColor: Colors.green.withOpacity(.9),
                  leading: Row(
                    children: [

//                    IconBtnWithCounter(
//                      svgSrc: "assets/icons/User.svg",
//                      press: () => HapticFeedback.heavyImpact(),
//                    ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconBtnWithCounter(
                          svgSrc: "assets/images/scan.svg",
                          press: (){
                            HapticFeedback.heavyImpact();
//                        openQRScan();
                            openScanSelectionBS();
                          },
                        ),
                      ),
                    ],
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    title: Text(
                      'your friends',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w200),
                    ),
                    background: Container(color: Colors.green),
                  ),
                  actions: [


                    GestureDetector(
                      onTap: (){
                        _showEditProfileSheet();
                        HapticFeedback.mediumImpact();
                      },
                      child: Container(
                                          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(30)),
                                            color: Colors.grey.shade100,
                                          ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit,color: Colors.black,),
                            SizedBox(width: 8,),
                            Text(
                              "Options",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                                        ),
                    ),


                    SizedBox(width: 10,),

                    AvatarBtnWithCounter(
                        picture: myProfileModel?.data?.photo ?? "",
                        press: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyProfile()));
                        }),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(60),
                          ),
                          color: kBackgroundColor,
                        ),
                        child: Column(
                          children: [

                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 20, 20, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(menu.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    HapticFeedback.mediumImpact();
                                    if(index == 0){
                                      selectedFilter = "single";
                                    }else if(index == 1){
                                      selectedFilter = "group";
                                    }
                                    activeMenu = index;
                                    filterFriendList();
                                  },
                                  child: activeMenu == index
                                      ? ElasticIn(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                          BorderRadius.circular(30)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 8,
                                            bottom: 8),
                                        child: Row(
                                          children: [
                                            Text(
                                              menu[index],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: white),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                      : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                        BorderRadius.circular(30)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: 8,
                                          bottom: 8),
                                      child: Row(
                                        children: [
                                          Text(
                                            menu[index],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),

                            friendsModel != null && friendsModel.data != null ?
                            ListView.builder(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              shrinkWrap: true,
                                   physics: NeverScrollableScrollPhysics(),
                                   itemBuilder: (context,i){
                                         return InkWell(
                                           onTap: () {

                                             if(friendsFilteredList[i].chatType == "group"){

                                               getEventParticipant(friendsFilteredList[i].id.toString(),friendsFilteredList[i].chatId,friendsFilteredList[i].name);

                                             }else{
                                               if(friendsFilteredList[i].unreadCount == 0){
                                                 Navigator.of(context).push(MaterialPageRoute(
                                                     builder: (context) => Profile(
                                                       userId: friendsFilteredList[i].id.toString(),
                                                       roomId: friendsFilteredList[i].chatId,
                                                     ))).then((value){
                                                   getFriendsList();
                                                 });
                                               }else{
                                                 openChatScreen(friendsFilteredList[i].name,friendsFilteredList[i].chatId,friendsFilteredList[i]);
                                               }


                                             }


                                             HapticFeedback.mediumImpact();
                                           },
                                           child: ContactsCard(
                                           imgPath: friendsFilteredList[i].profileImage,
                                           contactName: friendsFilteredList[i].name,
                                            contactBiography: friendsFilteredList[i].message ?? "",
                                            chatId: friendsFilteredList[i].chatId,
                                             unreadCount: friendsFilteredList[i].unreadCount,
                                             timeAgo: friendsFilteredList[i].timeAgo,
                                           ),
                                         );
                                       },
                                      itemCount: friendsFilteredList.length,
                                        )
                                :
                                Container()

                          ],
                        ),
                      ),
                      Container(
                        width: Get.width,
                        height: Get.height*0.9,
                        color: kBackgroundColor,
                      )

                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible: isLoading,
              child: Container(
                width: Get.width,
                height: Get.height,
                color: Colors.white.withOpacity(0.4),
                child: LoadingWidget(),
              ),
            )
          ],
        ),
      ),
    );
  }

  void openQRScan()async{

    Navigator.of(context).push<ScanCode>(
      MaterialPageRoute(
        builder: (c) {
          return ScanCodeScreen(onBarcodeScanned: (barcodeValue){
            Get.back();
            print("Scanned barcode value --- ${barcodeValue}");
            getScannedUserData(barcodeValue);
            setState(() {
              isLoading = true;
            });
          },);
        },
      ),
    );

  }


  void openScannedUserWidget(UserProfileModel userProfileModel,String qrCode){
    Get.dialog(
      ScannedUserWidget(userProfileModel: userProfileModel,qrCode: qrCode,backListener: (_){
        Get.back();
        getFriendsList();

        //Open selfie dialog
      },)
    );
  }

  void getScannedUserData(String qrCode){
    Map<String,String> params = {
      "qr_code" : qrCode
    };
    HomeRepo().getScannedUser(params).then((value) {
      setState(() {
        isLoading = false;
      });
      openScannedUserWidget(value,qrCode);
    });
  }

  void openScanSelectionBS(){
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ScanSelectionBSWidget(clickListener: (value){
          Get.back();
          if(value == "scanner"){
            openQRScan();
          }
          else{
            openUserQRCode();
          }
        },);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
    );
  }

  void openUserQRCode(){
    Get.dialog(
      UserQRCodeWidget(userCode: myProfileModel.data.qrCode,openScanner: (_) => openQRScan(),)
    ).then((value) {
      getFriendsList();
    });
  }

  void getProfileData() {
    HomeRepo().getProfileData().then((value) {
      if (value != null) {
        setState(() {
          myProfileModel = value;
        });
      }
    });
  }

  void getFriendsList(){
    HomeRepo().getFriendsList().then((value){

      if(value != null && value.data != null){
          friendsModel = value;
          filterFriendList();
      }

    });
  }

  void filterFriendList(){
    friendsFilteredList.clear();
    for(int i=0;i<friendsModel.data.length;i++){
      if(friendsModel.data[i].chatType.toLowerCase() == selectedFilter){
        friendsFilteredList.add(friendsModel.data[i]);
      }
    }

    setState(() {

    });
  }

  void openChatScreen(String userName,String roomId,friend.Data data){
    Get.to(ChatScreen(contactName: userName, chatRoomId: roomId,
      userList: [
        Users(name: UserPreferences().get(UserPreferences.SHARED_USER_NAME), id: int.parse(UserPreferences().get(UserPreferences.SHARED_USER_ID)), isOnline: true),
        Users(name: data.name, id: data.id, image: data.profileImage, isOnline: false)
      ],
      isGroupChat: false,
    ),).then((value){
      getFriendsList();
    });
  }

  void openGroupChat(String chatId,String roomName) {
    if (participantModel != null && participantModel.data != null && participantModel.data.length > 0) {
      List<Users> userList = [];
      for (int i = 0; i < participantModel.data.length; i++) {
        userList.add(
          Users(name: participantModel.data[i].name, id: participantModel.data[i].id, isOnline: false),
        );
      }
      Get.to(
        ChatScreen(
          contactName: roomName,
          chatRoomId: chatId,
          userList: userList,
          previousPageListener: (_) {},
          isGroupChat: true,
        ),
      ).then((value){
        getFriendsList();
      });
    }
  }

  void getEventParticipant(String eventId,String chatId,String roomName) {
    HomeRepo().getEventParticipant(eventId).then((value) {
      if (value != null) {
          participantModel = value;
          openGroupChat(chatId,roomName);
      }
    });
  }


  void _showEditProfileSheet() {
    //Settings
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(65.0))),
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0, left: 5),
                            child: Text(
                              "Options",
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          BoldButton(
                            text: "Edit Profile",
                            icon: Icons.edit,
                            press: () {
                              Get.back();
                              Get.to(EditProfileScreen(myProfileModel: myProfileModel,)).then((value){
                                getProfileData();
                              });
                            },
                          ),
                          BoldButton(
                            text: "Edit Interest",
                            icon: Icons.bookmark,
                            press: () {
                              Get.back();
                              Get.to(ChooseTags(isEdit : true));
                            },
                          ),
                          BoldButton(
                            text: "Notifications",
                            icon: Icons.notification_important,
                            press: () {
                              Get.back();
                              _showNotificationCenterSheet();
                            },
                          ),
                          BoldButton(
                            text: "Privacy Settings",
                            icon: Icons.settings,
                            press: () {
                              Get.back();
                              _showPrivacySettingSheet();
                            },
                          ),
                          BoldButton(
                            text: "Help Center",
                            icon: Icons.help_center,
                            press: () {
                              _launchURL("https://c0nnect.me/help");
                            },
                          ),
                          BoldButton(
                            text: "Log out",
                            icon: Icons.logout,
                            press: () async{

                              Config().showAlertDialog(
                                  context: context,
                                  content: "Are you sure you want to logout?",
                                  actionText: "Logout",
                                  title: "LOGOUT",
                                  action: ()async{
                                    await UserPreferences().getStorage.erase();
                                    Get.offNamedUntil("/login", (route) => false);
                                  }
                              );

                            },
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void _showNotificationCenterSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(65.0))),
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0, left: 5),
                            child: Text(
                              "Notification Center",
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context,i){
                              return Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: FlatButton(
                                  padding: EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  color: Color(0xFFF5F6F9),
                                  onPressed: () {
                                    HapticFeedback.mediumImpact();
                                    setState(() {
                                      notificationCenterDataList[i].selected.value = !notificationCenterDataList[i].selected.value;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        notificationCenterDataList[i].iconData,
                                        color: Colors.green.shade300,
                                        size: 22.0,
                                        semanticLabel: 'Text to announce in accessibility modes',
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(child: Text(notificationCenterDataList[i].name ?? "")),

                                      Obx(()=>  Switch(
                                          value: notificationCenterDataList[i].selected.value,
                                          onChanged: (value){
                                            setState(() {
                                              notificationCenterDataList[i].selected.value = value;
                                            });
                                          }
                                      ))

                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: notificationCenterDataList.length,
                          ),

                          Container(
                            padding: const EdgeInsets.only(left: 40, right: 40),
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            width: Get.width,
                            child: DefaultButton(
                              text: "SUBMIT",
                              press: () {
                                submitNotificationSetting();
                              },
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void _showPrivacySettingSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(65.0))),
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0, left: 5),
                            child: Text(
                              "Privacy",
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context,i){
                              return Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: FlatButton(
                                  padding: EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  color: Color(0xFFF5F6F9),
                                  onPressed: () {
                                    HapticFeedback.mediumImpact();
                                    setState(() {
                                      privacySettingDataList[i].selected.value = !privacySettingDataList[i].selected.value;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        privacySettingDataList[i].iconData,
                                        color: Colors.green.shade300,
                                        size: 22.0,
                                        semanticLabel: 'Text to announce in accessibility modes',
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(child: Text(privacySettingDataList[i].name)),

                                      Obx(()=>  Switch(
                                          value: privacySettingDataList[i].selected.value,
                                          onChanged: (value){
                                            setState(() {
                                              privacySettingDataList[i].selected.value = value;
                                            });
                                          }
                                      ))

                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: privacySettingDataList.length,
                          ),

                          Container(
                            padding: const EdgeInsets.only(left: 40, right: 40),
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            width: Get.width,
                            child: DefaultButton(
                              text: "SUBMIT",
                              press: () {
                                submitPrivacyNotification();
                              },
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }



  void getNotificationCenterSetting(){

    Map<String,String> params = {
      "type" : "notification"
    };
    HomeRepo().getNotificationSetting(params).then((value){

      if(value.data != null){
        List<String> dataList = [
          "Event Nofifications","Challenge Notifications","Friend Invitation","Chat Notifications","Birthday Notifications","Notifications to add Memories"
        ];

        List<String> dataIdList = [
          "event_notification","challenge_notifications","friend_notification","chat_notifications","birthday_notifications","memories_notification"
        ];

        for(int i=0;i<value.data.length;i++){
          OptionSelectionModel optionSelectionModel = OptionSelectionModel();
          optionSelectionModel.name = value.data[i].name;
          optionSelectionModel.iconData = Icons.notifications;
          optionSelectionModel.id = value.data[i].key;
          optionSelectionModel.selected.value = value.data[i].value == "1" ? true : false;
          notificationCenterDataList.add(optionSelectionModel);
        }
      }

    });



  }

  void getPrivacySetting(){

    Map<String,String> params = {
      "type" : "privacy"
    };
    HomeRepo().getNotificationSetting(params).then((value){
      List<String> dataList = [
        "Allow friends to see your active Status (online/Oflline)",
        "Allow your friends to see you on the map",
        "Allow us to send friends your birthday notification",
        "Allow your friends friends to see your profile"
      ];
      for(int i=0;i<value.data.length;i++){
        OptionSelectionModel optionSelectionModel = OptionSelectionModel();
        optionSelectionModel.name = value.data[i].name;
        optionSelectionModel.iconData = Icons.notifications;
        optionSelectionModel.id = value.data[i].key;
        optionSelectionModel.selected.value = value.data[i].value == "1" ? true : false;
        privacySettingDataList.add(optionSelectionModel);
      }
    });




  }

  void submitNotificationSetting(){

    List<notiSubmitModel.Data> submitList = [];

    for(int i=0;i<notificationCenterDataList.length;i++){
      submitList.add(notiSubmitModel.Data(value: notificationCenterDataList[i].selected.value ? "1" : "0",
          key: notificationCenterDataList[i].id));
    }


    Map<String,dynamic> params = {
      "type" : "notification",
      "settings" : submitList.map((v) => v.toJson()).toList()
    };

    HomeRepo().notificationSetting(params).then((value){
      if(value.status){
        Get.back();
      }
      Config().displaySnackBar(value.message, "");
    });

  }

  void submitPrivacyNotification(){

    List<notiSubmitModel.Data> submitList = [];

    for(int i=0;i<privacySettingDataList.length;i++){
      submitList.add(notiSubmitModel.Data(value: privacySettingDataList[i].selected.value ? "1" : "0",
          key: privacySettingDataList[i].id));
    }


    Map<String,dynamic> params = {
      "type" : "privacy",
      "settings" : submitList.map((v) => v.toJson()).toList()
    };

    HomeRepo().notificationSetting(params).then((value){
      if(value.status){
        Get.back();
      }
      Config().displaySnackBar(value.message, "");
    });

  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive {
    return true;
  }


}
