import 'dart:convert';

import 'package:c0nnect/ChatSystem.dart';
import 'package:c0nnect/Setup/loginScreen.dart';
import 'package:c0nnect/components/cards.dart';
import 'package:c0nnect/components/constants.dart';
import 'package:c0nnect/components/default_button.dart';
import 'package:c0nnect/helper/shared_prefs.dart';
import 'package:c0nnect/model/chat_model.dart';
import 'package:c0nnect/model/together_model.dart';
import 'package:c0nnect/model/user_profile_model.dart';
import 'package:c0nnect/repository/home_repo.dart';
import 'package:c0nnect/widget/LoadingWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'globals.dart' as global;
import 'helper/config.dart';
import 'helper/strings.dart' as string;

final BorderRadius bottomSheetRadius = BorderRadius.only(
    topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0));

class Profile extends StatefulWidget {

  final String userId;
  final String roomId;

  const Profile({Key key, this.userId, this.roomId}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  double socialsSize = 30;

  PageController pageController = PageController();

  UserProfileModel userProfileModel;
  TogetherModel togetherModel;

  bool oppositeUserOnlineStatus = false;
  bool  onlineStatusChecked= false;

  List<Users> userList = [];
  List<String> reportList = [string.Strings.reportReason1,string.Strings.reportReason2,string.Strings.reportReason3,];

  @override
  void initState() {
    getUserProfile(widget.userId);
    getTogetherData();
    getOppositeUserOnlineStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    double iconDistance = (MediaQuery
        .of(context)
        .size
        .width - (2 * 15) - (4 * 2 * 30)) / 3;

    return Scaffold(
        backgroundColor: kBackgroundColor,
        body:
        userProfileModel != null ?
        PageView(
          controller: pageController,
          scrollDirection: Axis.vertical,
          children: [
            Stack(
              children: <Widget>[
                Container(
                  height: height * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SafeArea(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(23, 10, 25, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.arrow_back_ios),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),

                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Visibility(
                                    visible: userProfileModel.data.friendStatus ? true : false,
                                    child: InkWell(
                                      onTap: (){
                                        unFriendApi(userProfileModel.data.id.toString());
                                      },
                                      child: Text(string.Strings.unFriend,
                                        style: TextStyle(
                                            color: Colors.black,
                                            letterSpacing: 1.0,
                                            fontFamily: 'Roboto',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  InkWell(
                                    onTap: (){
                                      openReportBS();
                                    },
                                    child: Text(string.Strings.report,
                                      style: TextStyle(
                                          color: Colors.black,
                                          letterSpacing: 1.0,
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            userProfileModel.data.photo ?? ""),
                        radius: height * 0.11,
                        backgroundColor: Colors.grey[200],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '${userProfileModel.data.firstName} ${userProfileModel
                            .data.lastName}',
                        //Text('user',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 40.0),
                      ),
                      Text(userProfileModel.data.bio ?? "", // short description
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                            decoration: TextDecoration.underline,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: widget.roomId != null ? true : false,
                        child: InkWell(
                          onTap: () {
                            pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 25.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "Message",
                                style: TextStyle(
                                  // replace
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: <Widget>[
                    DraggableScrollableSheet(
                        initialChildSize: 0.25,
                        minChildSize: 0.25,
                        maxChildSize: 0.8,
                        builder: (BuildContext context, myscrollController) {
                          return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset:
                                    Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: MediaQuery.removePadding(
                                removeTop: true,
                                context: context,
                                child: ListView(
                                    controller: myscrollController,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 150, right: 150, top: 20),
                                        child: Container(
                                          width: 50,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(30.0),
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(30.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("About",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 30.0)),
                                            Icon(
                                              Icons.arrow_upward,
                                              color: Colors.black,
                                              size: 30.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        // give a custom height
                                          height: 80,
                                          width: double.infinity,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                  onTap: () async {
                                                    if (userProfileModel.data
                                                        .facebook != null) {
                                                      _launchURL(
                                                          userProfileModel.data
                                                              .facebook);
                                                    } else {
                                                      global.showToast(
                                                          string.Strings
                                                              .noSocialLinkFound);
                                                    }
                                                  },
                                                  child: Center(
                                                      child: CircularProfileAvatar(
                                                        '',
                                                        backgroundColor:
                                                        Colors.grey.shade300,
                                                        radius: socialsSize,
                                                        elevation: 5,
                                                        child: Center(
                                                          child: FaIcon(
                                                              FontAwesomeIcons
                                                                  .facebook,
                                                              color: userProfileModel.data.facebook != null ?
                                                              Color.fromRGBO(73, 104, 173, 1)
                                                                  :
                                                              Colors.grey[500]
                                                          ),
                                                        ),
                                                      ))),

                                              GestureDetector(
                                                  onTap: () {
                                                    if (userProfileModel.data
                                                        .instagram != null) {
                                                      _launchURL(
                                                          userProfileModel.data
                                                              .instagram);
                                                    } else {
                                                      global.showToast(
                                                          string.Strings
                                                              .noSocialLinkFound);
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(iconDistance, 0, 0, 0),

                                                    child: Center(
                                                        child: CircularProfileAvatar(
                                                          '',
                                                          backgroundColor:
                                                          Colors.grey.shade300,
                                                          radius: socialsSize,
                                                          elevation: 5,
                                                          child: Center(
                                                            child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .instagram,
                                                                color: userProfileModel.data.instagram != null ?
                                                                Color.fromRGBO(204, 62, 122, 1)
                                                                    :
                                                                Colors.grey[500]
                                                            ),
                                                          ),
                                                        )),
                                                  )),

                                              GestureDetector(
                                                  onTap: () {
                                                    if (userProfileModel.data
                                                        .twitter != null) {
                                                      _launchURL(
                                                          userProfileModel.data
                                                              .twitter);
                                                    } else {
                                                      global.showToast(
                                                          string.Strings
                                                              .noSocialLinkFound);
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(iconDistance, 0, 0, 0),
                                                    child: Center(
                                                        child: CircularProfileAvatar(
                                                          '',
                                                          backgroundColor:
                                                          Colors.grey.shade300,
                                                          radius: socialsSize,
                                                          elevation: 5,
                                                          child: Center(
                                                            child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .twitter,
                                                                color: userProfileModel.data.twitter != null ?
                                                                Color.fromRGBO(74, 160, 235, 1)
                                                                    :
                                                                    Colors.grey[500]
                                                            ),
                                                          ),
                                                        )),
                                                  )),

                                              GestureDetector(
                                                  onTap: () {
                                                    if (userProfileModel.data
                                                        .snapchat != null) {
                                                      _launchURL(
                                                          userProfileModel.data
                                                              .snapchat);
                                                    } else {
                                                      global.showToast(
                                                          string.Strings
                                                              .noSocialLinkFound);
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(iconDistance, 0, 0, 0),
                                                    child: Center(
                                                        child: CircularProfileAvatar(
                                                          '',
                                                          backgroundColor:
                                                          Colors.grey.shade300,
                                                          radius: socialsSize,
                                                          elevation: 5,
                                                          child: Center(
                                                            child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .snapchat,
                                                                color: userProfileModel.data.snapchat != null ?
                                                                Color.fromRGBO(255, 251, 84, 1)
                                                                    :
                                                                    Colors.grey[500]
                                                            ),
                                                          ),
                                                        )),
                                                  )),

                                            ],
                                          )),

                                      //Categories
                                      userProfileModel.data.categories != null && userProfileModel.data.categories.length > 0 ?
                                      Container(
                                        padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Some Facts',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  letterSpacing: 1.0,
                                                  fontFamily: 'Roboto',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400
                                              ),
                                            ),

                                            SizedBox(height: 20,),

                                            Wrap(
                                                children: userProfileModel.data.categories.map((e) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          width: 40,
                                                          height: 40,
                                                          padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                  color: Colors.grey[400], width: 1),
                                                          ),
                                                          child: Image.network(e.icon ?? "", width: 10, height: 10,),
                                                        ),
                                                        SizedBox(width: 10,),
                                                        Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(e.label ?? "",
                                                              style: TextStyle(
                                                                  color: Colors.grey[400],
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w400
                                                              ),
                                                            ),
                                                            Text(e.value ?? "",
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w400
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }).toList()
                                            )

                                          ],
                                        ),
                                      )
                                          :
                                      Container(),

                                      //Phone Container
                                      Visibility(
                                        visible: userProfileModel.data.phone != null ? true : false,
                                        child: InkWell(
                                          onTap: (){
                                            String url = "tel:${userProfileModel.data.phone ?? ""}";
                                            launch(url);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 40,
                                                    height: 40,
                                                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.grey[400], width: 1),
                                                    ),
                                                    child: Image.asset("assets/images/telephone.png", width: 10, height: 10,),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("${userProfileModel.data.firstName}'s phone number",
                                                        style: TextStyle(
                                                            color: Colors.grey[400],
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w400
                                                        ),
                                                      ),
                                                      Text(userProfileModel.data.phone ?? "",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w400
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      //Address Container
                                      Visibility(
                                        visible: userProfileModel.data.address != null ? true : false,
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.grey[400], width: 1),
                                                  ),
                                                  child: Image.asset("assets/images/location.png", width: 10, height: 10,),
                                                ),
                                                SizedBox(width: 10,),
                                                Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("${userProfileModel.data.firstName}'s address",
                                                      style: TextStyle(
                                                          color: Colors.grey[400],
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                    Text(userProfileModel.data.address ?? "",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ) ,

                                      //DOB Container
                                      Visibility(
                                        visible: userProfileModel.data.dob != null ? true : false,
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.grey[400], width: 1),
                                                  ),
                                                  child: Image.asset("assets/images/birthday-cake.png", width: 10, height: 10,),
                                                ),
                                                SizedBox(width: 10,),
                                                Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("${userProfileModel.data.firstName}'s birthday",
                                                      style: TextStyle(
                                                          color: Colors.grey[400],
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                    Text(userProfileModel.data.dob != null && userProfileModel.data.dob != "" ?string.Strings.formatDateNew(userProfileModel.data.dob) : "",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),


                                      SizedBox(height: 120,)


//                                      Padding(
//                                        padding: const EdgeInsets.fromLTRB(
//                                            20.0, 0, 20, 0),
//                                        child: Column(
//                                          crossAxisAlignment: CrossAxisAlignment
//                                              .start,
//                                          children: [
//                                            SizedBox(
//                                              height: 10,
//                                            ),
//                                            Divider(
//                                              color: Colors.grey,
//                                              height: 4,
//                                              thickness: 0.5,
//                                            ),
//                                            SizedBox(
//                                              height: 10,
//                                            ),
//
//                                            Text(
//                                              "Who is ${userProfileModel.data
//                                                  .firstName} ${userProfileModel
//                                                  .data.lastName}?",
//                                              style: TextStyle(fontSize: 20),
//                                            ),
//                                            SizedBox(
//                                              height: 10,
//                                            ),
//                                            Text(
//                                              userProfileModel.data.bio ?? "",
//                                              maxLines: 3,
//                                            ),
//
//
//                                            SizedBox(
//                                              height: 10,
//                                            ),
//                                            Divider(
//                                              color: Colors.grey,
//                                              height: 4,
//                                              thickness: 0.5,
//                                            ),
//                                            SizedBox(
//                                              height: 10,
//                                            ),
//                                            Align(
//                                              alignment: Alignment.topLeft,
//                                            ),
//                                            SizedBox(
//                                              height: 10,
//                                            ),
//                                            Card(
//                                              elevation: 4.0,
//                                              color: Colors.white,
//                                              margin: const EdgeInsets.fromLTRB(
//                                                  16.0, 8.0, 16.0, 16.0),
//                                              shape: RoundedRectangleBorder(
//                                                  borderRadius:
//                                                  BorderRadius.circular(15.0)),
//                                              child: Column(
//                                                children: <Widget>[
//                                                  ListTile(
//                                                    leading: Icon(
//                                                      Icons.phone,
//                                                      color: Colors.lightGreen,
//                                                    ),
//                                                    title: Text(
//                                                        userProfileModel.data
//                                                            .phone),
//                                                    onTap: () {
//                                                      //open change password
//                                                    },
//                                                  ),
//                                                  Visibility(
//                                                    visible: userProfileModel
//                                                        .data.email != null
//                                                        ? true
//                                                        : false,
//                                                    child: ListTile(
//                                                      leading: Icon(
//                                                        Icons.email,
//                                                        color: Colors
//                                                            .lightGreen,
//                                                      ),
//                                                      title:
//                                                      Text(userProfileModel.data
//                                                          .email ?? ""),
//                                                      onTap: () {
//                                                        //open change language
//                                                      },
//                                                    ),
//                                                  ),
//                                                  ListTile(
//                                                    leading: Icon(
//                                                      Icons.cake,
//                                                      color: Colors.lightGreen,
//                                                    ),
//                                                    title: Text(
//                                                        userProfileModel.data.dob != null ? string.Strings.formatDateNew(userProfileModel.data.dob) : ""),
//                                                    onTap: () {
//                                                      //open change location
//                                                    },
//                                                  ),
//                                                  Visibility(
//                                                    visible: userProfileModel
//                                                        .data.address != null
//                                                        ? true
//                                                        : false,
//                                                    child: ListTile(
//                                                      leading: Icon(
//                                                        Icons.location_on,
//                                                        color: Colors
//                                                            .lightGreen,
//                                                      ),
//                                                      title: Text(
//                                                          userProfileModel.data
//                                                              .address ?? ""),
//                                                      onTap: () {
//                                                        //open change location
//                                                      },
//                                                    ),
//                                                  ),
//                                                ],
//                                              ),
//                                            ),
//                                            Card(
//                                              elevation: 4.0,
//                                              color: Colors.blueGrey.shade50,
//                                              margin: const EdgeInsets.fromLTRB(
//                                                  16.0, 8.0, 16.0, 16.0),
//                                              shape: RoundedRectangleBorder(
//                                                  borderRadius:
//                                                  BorderRadius.circular(15.0)),
//                                              child: Column(
//                                                children: <Widget>[
//                                                  ListTile(
//                                                    leading: Icon(
//                                                      Icons.bubble_chart,
//                                                      color: Colors.lightGreen,
//                                                    ),
//                                                    title: Text(
//                                                        "Didnt meet in ${userProfileModel
//                                                            .data
//                                                            .lastSeen} days"),
//                                                    onTap: () {
//                                                      //open change location
//                                                    },
//                                                  ),
//                                                  ListTile(
//                                                    leading: Icon(
//                                                      Icons.people,
//                                                      color: Colors.lightGreen,
//                                                    ),
//                                                    title: Text(
//                                                        "You got ${userProfileModel
//                                                            .data
//                                                            .mutualFriends} mutural Friends"),
//                                                    onTap: () {
//                                                      //open change location
//                                                    },
//                                                  ),
//                                                ],
//                                              ),
//                                            ),
//                                            SizedBox(
//                                              height: 120,
//                                            )
//                                          ],
//                                        ),
//                                      )
                                    ]),
                              ));
                        }),
                    DraggableScrollableSheet(
                        initialChildSize: 0.13,
                        minChildSize: 0.13,
                        maxChildSize: 0.8,
                        builder: (BuildContext context, myscrollController) {
                          return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset:
                                    Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: MediaQuery.removePadding(
                                removeTop: true,
                                context: context,
                                child: ListView(
                                    controller: myscrollController,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 150, right: 150, top: 20),
                                        child: Container(
                                          width: 50,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(30.0),
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(30.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("2gether",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 30.0)),
                                            Icon(
                                              Icons.arrow_upward,
                                              color: Colors.black,
                                              size: 30.0,
                                            ),
                                          ],
                                        ),
                                      ),

                                      togetherModel != null && togetherModel.data != null ?
                                      togetherModel.data.length > 0 ?
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, i) {
                                          return BuildEventCard(
                                            time: togetherModel.data[i].day,
                                            amORpm: togetherModel.data[i].startTime,
                                            duration: togetherModel.data[i].duration??"",
                                            header: togetherModel.data[i].title,
                                            subtitle: togetherModel.data[i].description,
                                            avatarOfPerson: togetherModel.data[i].creator.profileImage ?? "",
                                            person: togetherModel.data[i].creator.name,
                                            location: togetherModel.data[i].address,
                                            type: togetherModel.data[i].type,
                                            exactLocation: "",
                                          );
                                        },
                                        itemCount: togetherModel.data.length,
                                      )
                                          :
                                      Container(
                                        width: Get.width,
                                        height: 300,
                                        child: Center(
                                          child: Text(string.Strings.noTogetherData,
                                            style: TextStyle(
                                                color: Colors.black,
                                                letterSpacing: 1.0,
                                                fontFamily: 'Roboto',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ),
                                      )
                                          :
                                      LoadingWidget(),
                                    ]),
                              ));
                        }),
                  ],
                ),
              ],
            ),
            if(widget.roomId != null)
              userList != null && userList.isNotEmpty ?
              ChatScreen(contactName: userProfileModel.data.firstName, chatRoomId: widget.roomId,
                userList: userList,
                previousPageListener: (_) {
                  pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                },
                isGroupChat: false,
              )
              :
              ChatScreen(contactName: userProfileModel.data.firstName, chatRoomId: widget.roomId,
                userList: [
                  Users(name: userProfileModel.data.firstName, id: userProfileModel.data.id, image: userProfileModel.data.photo, isOnline: oppositeUserOnlineStatus),
                  Users(name: UserPreferences().get(UserPreferences.SHARED_USER_NAME), id: int.parse(UserPreferences().get(UserPreferences.SHARED_USER_ID)), isOnline: true),
                ],
                previousPageListener: (_) {
                  pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                },
                isGroupChat: false,
              )


          ],
        )
            :
        Container(
            height: 300,
            width: Get.width,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Get.theme.primaryColor),
              ),
            )
        )
    );
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
                            press: () {},
                          ),
                          BoldButton(
                            text: "Notifications",
                            icon: Icons.notification_important,
                            press: () {},
                          ),
                          BoldButton(
                            text: "Privacy Settings",
                            icon: Icons.settings,
                            press: () {},
                          ),
                          BoldButton(
                            text: "About c0nnect",
                            icon: Icons.people,
                            press: () {},
                          ),
                          BoldButton(
                            text: "Help Center",
                            icon: Icons.help_center,
                            press: () {},
                          ),
                          BoldButton(
                            text: "Log out",
                            icon: Icons.logout,
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LoginPage()), //Link to Information page
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

  Widget makeItem({image, date}) {
    return Row(
      children: <Widget>[
        Container(
          width: 50,
          height: 200,
          margin: EdgeInsets.only(right: 20),
          child: Column(
            children: <Widget>[
              Text(
                date.toString(),
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "SEP",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: AssetImage(image), fit: BoxFit.cover)),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(colors: [
                    Colors.black.withOpacity(.4),
                    Colors.black.withOpacity(.1),
                  ])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Bumbershoot 2019",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "19:00 PM",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void getUserProfile(String userId) {
    HomeRepo().getUserProfile(userId).then((value) {
      if (value != null) {
        setState(() {
          userProfileModel = value;
          //Default value
     });


    }
    });
  }

  void getTogetherData() {
    HomeRepo().getTogetherData(widget.userId).then((value) {
      if (value.data != null) {
        setState(() {
          togetherModel = value;
        });
      }
    });
  }

  void getOppositeUserOnlineStatus(){
    FirebaseFirestore.instance
            .collection("ChatRoom")
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            if(doc.id == widget.roomId){


              userList.clear();

              Users user1 = Users.fromJson(doc["users"][0]);
              Users user2 = Users.fromJson(doc["users"][1]);
              userList.add(user1);
              userList.add(user2);

              print("Checking length --------- ${userList.length}");

            }


          });
        });
  }

  void unFriendApi(String requestId){
    showLoader();
    Map<String, String> params = {"acknowledge": "unfriend"};
    HomeRepo().acceptRejectFriendRequest(requestId, params).then((value) {
      Get.back();
      Config().displaySnackBar(value?.message, "");
      if (value != null && value.status) {
        getUserProfile(widget.userId);
      }
    });
  }

  void showLoader(){
    Future.delayed(
        Duration.zero,
            () => Get.dialog(
            Container(
              width: Get.width,
              height: Get.width,
              color: Colors.white.withOpacity(0.3),
              child: Center(
                  child: LoadingWidget()),
            ),
            barrierDismissible: false));
  }

  void openReportBS(){
      showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Report User',
                      style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 1.0,
                          fontFamily: 'Roboto',
                          fontSize: 22,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 20,),

                    ListView.builder(
                      shrinkWrap: true,
                           physics: NeverScrollableScrollPhysics(),
                           itemBuilder: (context,i){
                                 return InkWell(
                                   onTap: (){
                                     Config().showAlertDialog(
                                         context: context,
                                         content: "Are you sure you want to report ${userProfileModel.data.firstName} ${userProfileModel.data.lastName}?",
                                         actionText: "Report",
                                         title: "REPORT",
                                         action: ()async{
                                          Get.back();
                                          Get.back();

                                          reportUser(reportList[i]);
                                         }
                                     );
                                   },
                                   child: Container(
                                     width: Get.width,
                                     margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                     padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                     decoration: BoxDecoration(
                                         borderRadius: BorderRadius.all(Radius.circular(10)),
                                         color: Colors.green[500]
                                     ),
                                     child:  Center(
                                       child: Text(reportList[i],
                                         style: TextStyle(
                                             color: Colors.white,
                                             letterSpacing: 1.0,
                                             fontFamily: 'Roboto',
                                             fontSize: 14,
                                             fontWeight: FontWeight.w600
                                         ),
                                       ),
                                     ),
                                   ),
                                 );
                           },
                              itemCount: reportList.length,
                                )

                  ],
                ),
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
          );
  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';


  void reportUser(String reason){
    Map<String,String> params = {
      "reason" : reason
    };
    HomeRepo().reportUser(userProfileModel.data.id.toString(),params).then((value){
      Config().displaySnackBar(value.message, "");
    });
  }

}

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity").add(
          Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
      Track("translateY").add(
          Duration(milliseconds: 500), Tween(begin: -30.0, end: 0.0),
          curve: Curves.easeOut)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) =>
          Opacity(
            opacity: animation["opacity"],
            child: Transform.translate(
                offset: Offset(0, animation["translateY"]), child: child),
          ),
    );
  }



}
