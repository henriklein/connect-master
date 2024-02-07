import 'dart:io';

import 'package:barcode/barcode.dart';
import 'package:c0nnect/ChatSystem.dart';
import 'package:c0nnect/components/cards.dart';
import 'package:c0nnect/components/constants.dart';
import 'package:c0nnect/components/default_button.dart';
import 'package:c0nnect/model/my_profile_model.dart';
import 'package:c0nnect/repository/home_repo.dart';
import 'package:c0nnect/widget/LoadingWidget.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Setup/completeProfile.dart';
import 'Setup/loginScreen.dart';
import 'edit_profile_screen.dart';
import 'helper/config.dart';
import 'helper/shared_prefs.dart';
import 'helper/strings.dart' as str;
import 'globals.dart'as global;
import 'helper/strings.dart'as string;
import 'model/option_selection_model.dart';

final BorderRadius bottomSheetRadius = BorderRadius.only(
    topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0));

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  double socialsSize = 30;

  File barcodeSvgFile;

  MyProfileModel myProfileModel;

  List<OptionSelectionModel> notificationCenterDataList = [];
  List<OptionSelectionModel> privacySettingDataList = [];

  @override
  void initState() {
    getProfileData();
    getNotificationCenterSetting();
    getPrivacySetting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    double iconDistance = (MediaQuery.of(context).size.width - (2 * 15) - (4 * 2 * 30)) / 3;

    return Scaffold(
        backgroundColor: kBackgroundColor,
        body: Stack(
          children: <Widget>[
            myProfileModel != null && myProfileModel.data != null
                ? Stack(
                    children: [
                      Container(
                        child: Column(
                          children: <Widget>[
                            SafeArea(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(23, 10, 25, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.arrow_back_ios),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                    RaisedButton.icon(
                                      onPressed: () {
                                        _showEditProfileSheet();
                                        HapticFeedback.mediumImpact();
                                      },
                                      icon: Icon(Icons.edit),
                                      color: Colors.grey.shade100,
                                      label: Text(
                                        "Options",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            CircleAvatar(
                              backgroundImage: NetworkImage(myProfileModel.data.photo ?? ""),
                              radius: height * 0.11,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '${myProfileModel.data.firstName} ${myProfileModel.data.lastName}' ,
                              //Text('user',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 40.0),
                            ),
                            Text(myProfileModel.data.bio ?? "", // short description
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                  decoration: TextDecoration.underline,
                                )),

                            InkWell(
                              onTap: (){
                                Get.to(EditProfileScreen(myProfileModel: myProfileModel,)).then((value){
                                  getProfileData();
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.green
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.edit,color: Colors.white,size: 22,),
                                     SizedBox(width: 10,),
                                     Text('Edit Profile',
                                            style: TextStyle(
                                             color: Colors.white,
                                              letterSpacing: 1.0,
                                                fontFamily: 'Roboto',
                                           fontSize: 14,
                                           fontWeight: FontWeight.w600
                                                               ),
                                                               ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            if (barcodeSvgFile != null)
                              SvgPicture.file(
                                barcodeSvgFile,
                                color: Colors.black,
                                fit: BoxFit.contain,
                              ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          DraggableScrollableSheet(
                              initialChildSize: 0.25,
                              minChildSize: 0.25,
                              maxChildSize: 0.7,
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
                                          offset: Offset(
                                              0, 3), // changes position of shadow
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
                                                  Text("Stats",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w900,
                                                          fontSize: 30.0)),
                                                  Icon(
                                                    Icons.arrow_upward,
                                                    color: Colors.black,
                                                    size: 30.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //Categories
                                            myProfileModel.data.statistics != null && myProfileModel.data.statistics.length > 0 ?
                                            Container(
                                              padding: EdgeInsets.fromLTRB(10, 15, 10, 25),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  Wrap(
                                                      children: myProfileModel.data.statistics.map((e) {
                                                        return Container(
                                                          padding: const EdgeInsets.all(8.0),
                                                          width: (Get.width / 2) - 20,
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
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(e.label ?? "",
                                                                      style: TextStyle(
                                                                          color: Colors.grey[400],
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w400
                                                                      ),
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                    Text(e.value.toString() ?? "",
                                                                      style: TextStyle(
                                                                          color: Colors.black,
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w400,
                                                                      ),

                                                                    ),
                                                                  ],
                                                                ),
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


                                          ]),
                                    ));
                              }),
                          DraggableScrollableSheet(
                              initialChildSize: 0.13,
                              minChildSize: 0.13,
                              maxChildSize: 0.7,
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
                                          offset: Offset(
                                              0, 3), // changes position of shadow
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
                                                          fontWeight:
                                                          FontWeight.w900,
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
                                                          if(myProfileModel.data.facebook != null){
                                                            _launchURL(myProfileModel.data.facebook);
                                                          }else{
//                                                        global.showToast(string.Strings.noSocialLinkFound);
                                                            Get.to(EditProfileScreen(myProfileModel: myProfileModel,)).then((value){
                                                              getProfileData();
                                                            });
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
                                                                    FontAwesomeIcons.facebook,
                                                                    color: Color.fromRGBO(
                                                                        73, 104, 173, 1)),
                                                              ),
                                                            ))),
                                                    SizedBox(
                                                      width: iconDistance,
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          if(myProfileModel.data.instagram != null){
                                                            _launchURL(myProfileModel.data.instagram);
                                                          }else{
//                                                        global.showToast(string.Strings.noSocialLinkFound);
                                                            Get.to(EditProfileScreen(myProfileModel: myProfileModel,)).then((value){
                                                              getProfileData();
                                                            });
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
                                                                        .instagram,
                                                                    color: Color.fromRGBO(
                                                                        204, 62, 122, 1)),
                                                              ),
                                                            ))),
                                                    SizedBox(
                                                      width: iconDistance,
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          if(myProfileModel.data.twitter != null){
                                                            _launchURL(myProfileModel.data.twitter);
                                                          }else{
//                                                        global.showToast(string.Strings.noSocialLinkFound);
                                                            Get.to(EditProfileScreen(myProfileModel: myProfileModel,)).then((value){
                                                              getProfileData();
                                                            });
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
                                                                    FontAwesomeIcons.twitter,
                                                                    color: Color.fromRGBO(
                                                                        74, 160, 235, 1)),
                                                              ),
                                                            ))),
                                                    SizedBox(
                                                      width: iconDistance,
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          if(myProfileModel.data.snapchat != null){
                                                            _launchURL(myProfileModel.data.snapchat);
                                                          }else{
//                                                        global.showToast(string.Strings.noSocialLinkFound);
                                                            Get.to(EditProfileScreen(myProfileModel: myProfileModel,)).then((value){
                                                              getProfileData();
                                                            });
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
                                                                    FontAwesomeIcons.snapchat,
                                                                    color: Color.fromRGBO(
                                                                        255, 251, 84, 1)),
                                                              ),
                                                            ))),
                                                    SizedBox(
                                                      width: iconDistance,
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {},
                                                        child: Center(
                                                            child: CircularProfileAvatar(
                                                              '',
                                                              backgroundColor:
                                                              Colors.grey.shade300,
                                                              radius: socialsSize,
                                                              elevation: 5,
                                                              child: Center(
                                                                child: FaIcon(
                                                                    FontAwesomeIcons.snapchat,
                                                                    color: Color.fromRGBO(
                                                                        255, 251, 84, 1)),
                                                              ),
                                                            ))),
                                                  ],
                                                )),

                                            //Categories
                                            myProfileModel.data.categories != null && myProfileModel.data.categories.length > 0 ?
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
                                                      children: myProfileModel.data.categories.map((e) {
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
                                              visible: myProfileModel.data.phone != null ? true : false,
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
                                                        child: Image.asset("assets/images/telephone.png", width: 10, height: 10,),
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("${myProfileModel.data.firstName}'s phone number",
                                                            style: TextStyle(
                                                                color: Colors.grey[400],
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w400
                                                            ),
                                                          ),
                                                          Text(myProfileModel.data.phone ?? "",
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

                                            //Address Container
                                            Visibility(
                                              visible: myProfileModel.data.address != null ? true : false,
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
                                                          Text("${myProfileModel.data.firstName}'s address",
                                                            style: TextStyle(
                                                                color: Colors.grey[400],
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w400
                                                            ),
                                                          ),
                                                          Text(myProfileModel.data.address ?? "",
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
                                              visible: myProfileModel.data.dob != null ? true : false,
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
                                                          Text("${myProfileModel.data.firstName}'s birthday",
                                                            style: TextStyle(
                                                                color: Colors.grey[400],
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w400
                                                            ),
                                                          ),
                                                          Text(myProfileModel.data.dob != null && myProfileModel.data.dob != "" ?string.Strings.formatDateNew(myProfileModel.data.dob) : "",
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
                                            )


//                                        Padding(
//                                          padding: const EdgeInsets.fromLTRB(
//                                              20.0, 0, 20, 0),
//                                          child: Column(
//                                            crossAxisAlignment:
//                                                CrossAxisAlignment.start,
//                                            children: [
//                                              SizedBox(
//                                                height: 10,
//                                              ),
//                                              Divider(
//                                                color: Colors.grey,
//                                                height: 4,
//                                                thickness: 0.5,
//                                              ),
//                                              SizedBox(
//                                                height: 10,
//                                              ),
//                                              Text(
//                                                "Who is ${myProfileModel.data.firstName ?? ""} ${myProfileModel.data.lastName ?? ""}?",
//                                                style: TextStyle(fontSize: 20),
//                                              ),
//                                              SizedBox(
//                                                height: 10,
//                                              ),
//                                              Text(
//                                                myProfileModel.data.bio ?? "",
//                                                maxLines: 3,
//                                              ),
//                                              SizedBox(
//                                                height: 10,
//                                              ),
//                                              Divider(
//                                                color: Colors.grey,
//                                                height: 4,
//                                                thickness: 0.5,
//                                              ),
//                                              SizedBox(
//                                                height: 10,
//                                              ),
//                                              Align(
//                                                alignment: Alignment.topLeft,
//                                              ),
//                                              SizedBox(
//                                                height: 10,
//                                              ),
//                                              Card(
//                                                elevation: 4.0,
//                                                color: Colors.white,
//                                                margin: const EdgeInsets.fromLTRB(
//                                                    16.0, 8.0, 16.0, 16.0),
//                                                shape: RoundedRectangleBorder(
//                                                    borderRadius:
//                                                    BorderRadius.circular(15.0)),
//                                                child: Column(
//                                                  children: <Widget>[
//                                                    ListTile(
//                                                      leading: Icon(
//                                                        Icons.phone,
//                                                        color: Colors.lightGreen,
//                                                      ),
//                                                      title: Text(myProfileModel.data.phone),
//                                                      onTap: () {
//                                                        //open change password
//                                                      },
//                                                    ),
//                                                    Visibility(
//                                                      visible: myProfileModel.data.email != null ? true : false,
//                                                      child: ListTile(
//                                                        leading: Icon(
//                                                          Icons.email,
//                                                          color: Colors.lightGreen,
//                                                        ),
//                                                        title:
//                                                        Text(myProfileModel.data.email ?? ""),
//                                                        onTap: () {
//                                                          //open change language
//                                                        },
//                                                      ),
//                                                    ),
//                                                    ListTile(
//                                                      leading: Icon(
//                                                        Icons.cake,
//                                                        color: Colors.lightGreen,
//                                                      ),
//                                                      title: Text(string.Strings.formatDateNew(myProfileModel.data.dob)),
//                                                      onTap: () {
//                                                        //open change location
//                                                      },
//                                                    ),
//                                                    Visibility(
//                                                      visible: myProfileModel.data.address != null ? true : false,
//                                                      child: ListTile(
//                                                        leading: Icon(
//                                                          Icons.location_on,
//                                                          color: Colors.lightGreen,
//                                                        ),
//                                                        title: Text(myProfileModel.data.address??""),
//                                                        onTap: () {
//                                                          //open change location
//                                                        },
//                                                      ),
//                                                    ),
//                                                  ],
//                                                ),
//                                              ),
//                                              SizedBox(
//                                                height: 20,
//                                              )
//                                            ],
//                                          ),
//                                        )
                                          ]),
                                    ));
                              }),
                        ],
                      )

                    ],
                  )
                : Container(
                    height: Get.height,
                    width: Get.width,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Get.theme.primaryColor),
                      ),
                    )),
          ],
        ));
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
                                                 Expanded(child: Text(notificationCenterDataList[i].name)),

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
    List<String> dataList = [
      "Event Nofifications","Challenge Notifications","Friend Invitation","Chat Notifications","Birthday Notifications","Notifications to add Memories"
    ];

    for(int i=0;i<dataList.length;i++){
      OptionSelectionModel optionSelectionModel = OptionSelectionModel();
      optionSelectionModel.name = dataList[i];
      optionSelectionModel.iconData = Icons.notifications;
      notificationCenterDataList.add(optionSelectionModel);
    }
  }

  void getPrivacySetting(){
    List<String> dataList = [
      "Allow friends to see your active Status (online/Oflline)",
      "Allow your friends to see you on the map",
      "Allow us to send friends your birthday notofication",
      "Allow your friends friends to see your profile"
    ];

    for(int i=0;i<dataList.length;i++){
      OptionSelectionModel optionSelectionModel = OptionSelectionModel();
      optionSelectionModel.name = dataList[i];
      optionSelectionModel.iconData = Icons.settings;
      privacySettingDataList.add(optionSelectionModel);
    }
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

  void buildBarcode(
    Barcode bc,
    String data, {
    String filename,
    double width,
    double height,
    double fontHeight,
  }) async {
    /// Create the Barcode
    final svg = bc.toSvg(
      data,
      width: width ?? 200,
      height: height ?? 80,
      fontHeight: fontHeight ?? 2,
    );

    // Save the image
//    filename = generateRandomString(10);
    filename = "scanner";

    String dir = (await getApplicationDocumentsDirectory()).path;

    if(File('${dir}/${filename}.svg').existsSync()){
      print("File exist");
    }else{
      File('${dir}/${filename}.svg').writeAsStringSync(svg);
      print("File not exist");
    }

    setState(() {
      barcodeSvgFile = File('${dir}/${filename}.svg');
      print("Checking barcode file --- ${barcodeSvgFile.path}");
    });
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  void getProfileData() {
    HomeRepo().getProfileData().then((value) {
      if (value != null) {
        setState(() {
          myProfileModel = value;

//          Future.delayed(Duration(seconds: 1), () {
//            buildBarcode(Barcode.aztec(), myProfileModel.data.qrCode ?? "", height: 200);
//          });

        });
      }
    });
  }


  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity")
          .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
      Track("translateY").add(
          Duration(milliseconds: 500), Tween(begin: -30.0, end: 0.0),
          curve: Curves.easeOut)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
            offset: Offset(0, animation["translateY"]), child: child),
      ),
    );
  }
}
