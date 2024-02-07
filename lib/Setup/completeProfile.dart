import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:c0nnect/PageController.dart';
import 'package:c0nnect/Setup/login_success_screen.dart';
import 'package:c0nnect/components/default_button.dart';
import 'package:c0nnect/helper/api_urls.dart';
import 'package:c0nnect/helper/config.dart';
import 'package:c0nnect/helper/shared_prefs.dart';
import 'package:c0nnect/helper/strings.dart';
import 'package:c0nnect/model/category_model.dart';
import 'package:c0nnect/model/contact_model.dart';
import 'package:c0nnect/model/login_model.dart';
import 'package:c0nnect/model/post_contact_model.dart';
import 'package:c0nnect/repository/home_repo.dart';
import 'package:c0nnect/repository/login_repo.dart';
import 'package:c0nnect/widget/CustomizeEmojiWidget.dart';
import 'package:c0nnect/widget/ImageSourceSelectionBSWidget.dart';
import 'package:c0nnect/widget/LoadingWidget.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart'as dio;
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:c0nnect/globals.dart' as global;
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class AddName extends StatefulWidget {
  @override
  _AddNameState createState() => _AddNameState();
}

class _AddNameState extends State<AddName> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        padding: EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Container(
                    height: 200,
                    child: Image.asset("assets/images/happyGuy.png")),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "That worked well!",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "we now got you verified",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "We would now like to complete your profile.\nYou decinde weather you want to share your infromation with your friends or not.",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: new InputDecoration(
                  labelText: "what is your first name",
                  fillColor: Colors.white,
                  focusColor: Colors.green,
                  hoverColor: Colors.green,

                  //fillColor: Colors.green
                ),
                onChanged: (value) {
                  global.userFirstName = value;
                },
              ),
              SizedBox(height: 20,),

              TextFormField(
                decoration: new InputDecoration(
                    labelText: "what is your last name",
                    fillColor: Colors.white,
                    focusColor: Colors.green,
                    hoverColor: Colors.green,
                    border: UnderlineInputBorder()

                  //fillColor: Colors.green
                ),
                onChanged: (value) {
                  global.userLastName = value;
                },
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                child: DefaultButton(
                  text: "Continue",
                  press: () {
                    if( global.userFirstName == ""){
                      Config().displaySnackBar(Strings.enterFirstName, "");
                     return;
                    }
                    if( global.userLastName == ""){
                      Config().displaySnackBar(Strings.enterLastName, "");
                      return;
                    }

                    UserPreferences().saveData(UserPreferences.SHARED_USER_NAME, '${global.userFirstName} ${global.userLastName}' );

                    FocusScope.of(context).unfocus();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AddBirthday();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddBirthday extends StatefulWidget {
  @override
  _AddBirthdayState createState() => _AddBirthdayState();
}

class _AddBirthdayState extends State<AddBirthday> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                  height: 170,
                  child: Image.asset("assets/images/Birthday.png")),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "It's my Birthday",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Your friends migth be praparing something!",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "So before you type in any missleading information which will confuse your frinds, please just skip it.",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Container(
              height: 250,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                maximumDate: DateTime.now(),
                initialDateTime: DateTime(2000,1),
                onDateTimeChanged: (DateTime newDateTime) {
                  // Do something
                  global.userDOB = DateFormat("yyyy-MM-dd").format(newDateTime);
                },
              ),
            ),
            Container(
              width: double.infinity,
              child: DefaultButton(
                text: "Continue",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ChooseTags(isEdit: false,);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChooseTags extends StatefulWidget {

  bool isEdit = false;

  ChooseTags({Key key, this.isEdit}) : super(key: key);

  @override
  _ChooseTagsState createState() => _ChooseTagsState();
}

class _ChooseTagsState extends State<ChooseTags> {
  TextEditingController describeController = TextEditingController();
  String actionButtonText = "Continue";
  final List<String> tags = [
    '📌 American Football',
    '🏀 Basketball ',
    '⚽️ European Football',
    "🎾 Tennis",
    "🏒 Hockey"
  ];

  bool isBuildLoaded = false;
  CategoryModel categoryModel = CategoryModel();

  @override
  void initState() {
    super.initState();
    global.selectedCategoryId.clear();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    isBuildLoaded = true;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 0, right: 0, bottom: 0),
        child: ListView(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                  height: 170,
                  child: Image.asset("assets/images/Birthday.png")),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What do you like",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Let your friends know about your interests",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Please discribe ourself in text as well as in tags. We tryed to create wide range of possable tags, however, feel free to add some of your owns. ",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: describeController,
                    decoration: new InputDecoration(
                      labelText: "one sentence that best describes you",
                      fillColor: Colors.white,
                      focusColor: Colors.green,
                      hoverColor: Colors.green,
                      //fillColor: Colors.green
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (categoryModel != null && categoryModel.data != null)
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categoryModel.data[i].name,
                            style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 1.0,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 50,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    if (categoryModel.data[i]
                                        .subcategories[index].isSelected) {
                                      setState(() {
                                        categoryModel
                                            .data[i]
                                            .subcategories[index]
                                            .isSelected = false;
                                        global.selectedCategoryId
                                            .removeAt(index);
                                      });
                                    } else {
                                      setState(() {
                                        categoryModel
                                            .data[i]
                                            .subcategories[index]
                                            .isSelected = true;
                                        global.selectedCategoryId.add(
                                            categoryModel.data[i]
                                                .subcategories[index].id);
                                      });
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    decoration: BoxDecoration(
                                        color: categoryModel.data[i]
                                            .subcategories[index].isSelected
                                            ? Colors.green.withOpacity(0.4)
                                            : Colors.grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(22))),
                                    child: Padding(
                                      padding:
                                      EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      child: Text(
                                        categoryModel
                                            .data[i].subcategories[index].name,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount:
                              categoryModel.data[i].subcategories.length,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: categoryModel.data.length,
                ),
              ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                child: DefaultButton(
                  text: actionButtonText,
                  press: () {
                    global.bio = describeController.text;
                    if(widget.isEdit){
                      if(global.selectedCategoryId.isNotEmpty){
                        updateInterest();
                      }else{
                        Config().displaySnackBar("Select at least one intrest", "");
                      }
                    }else{
                      Get.to(AddProfileImageScreen());
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getCategory() {
    Map<String,String> params = {
      "type" : "user"
    };
    LoginRepo().getCategoryData(params).then((value) {
      if (value != null && value.data != null && value.data.length > 0) {
        setState(() {
          if (isBuildLoaded) {
            categoryModel = value;
            if(widget.isEdit){
              getSelectedCategory();
            }
          }
        });
      }
    });
  }

  void getSelectedCategory(){
    HomeRepo().getSelectedInterest().then((value){
      if(value.data != null){
        for(int i=0;i<value.data.length;i++){
          for(int j=0;j<categoryModel.data.length;j++){
            for(int k=0;k<categoryModel.data[j].subcategories.length;k++){
              if(categoryModel.data[j].subcategories[k].id == value.data[i].id){
                categoryModel.data[j].subcategories[k].isSelected = true;
                global.selectedCategoryId.add(categoryModel.data[j].subcategories[k].id);
              }
            }
          }
        }
      }

      setState(() {

      });

    });
  }

  void updateInterest(){
    setState(() {
      actionButtonText = Strings.pleaseWait;
    });
    Map<String,dynamic> params = {
      "tags" : global.selectedCategoryId
    };
    HomeRepo().updateInterest(params).then((value){
      if(value.status){
        Get.back();
        Config().displaySnackBar(value.message, "");
      }else{
        Config().displaySnackBar(value.message, "");
        setState(() {
          actionButtonText = "Continue";
        });
      }
    });
  }

}

class AddProfileImageScreen extends StatefulWidget {
  @override
  _AddProfileImageScreenState createState() => _AddProfileImageScreenState();
}

class _AddProfileImageScreenState extends State<AddProfileImageScreen> {
  File selectedImageFile;
  String selectedEmoji="😀";
  Color emojiBackgroundColor = Colors.pink.withOpacity(0.5);
  String actionButtonText = "Continue";
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.profile_title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              Strings.profile_des,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 100,
            ),
            Stack(
              children: [
                selectedImageFile != null
                    ? Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 220,
                    height: 220.0,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(110),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      child: Image.file(
                        selectedImageFile,
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                      BorderRadius.all(Radius.circular(110)),
                    ),
                  ),
                )
                    :
                Screenshot(
                  controller: screenshotController,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 220,
                      height: 220.0,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(110),
                        color: emojiBackgroundColor,
                      ),
                      child: ClipRRect(
                        child: Center(
                          child: Text(
                            selectedEmoji ?? "",
                            style: TextStyle(
                                fontSize: 100,
                               ),
                          ),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 80,
                  child: InkWell(
                    onTap: () {
                      imageSourceSelectionBS();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Colors.white,
                          boxShadow: [BoxShadow(blurRadius: 2)]),
                      child: Icon(
                        Icons.edit,
                        size: 30,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                child: DefaultButton(
                  text: actionButtonText,
                  press: () async {
                    setState(() {
                      actionButtonText = "Please Wait....";
                    });

                    String dir = (await getApplicationDocumentsDirectory()).path;
                    screenshotController.capture(path: dir+"/${Random().nextInt(1000)}.png").then((value){
                        selectedImageFile = value;
                        userLogin();
                    });

                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> userLogin() async {


    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    await _firebaseMessaging.getToken().then((String token) async{
      assert(token != null);
      Map<String, dynamic> params = {
        "phone": global.userPhoneNumber,
        "first_name": global.userFirstName,
        "last_name": global.userLastName,
        "notification_token": token,
        "dob": global.userDOB,
        "description": global.bio,
        "tags": global.selectedCategoryId.toString(),
        "platform": Platform.isAndroid ? "android" : "ios"
      };

      if (selectedImageFile == null) {
        return;
      }

      params["profile_image"] = await dio.MultipartFile.fromFile(selectedImageFile.path, filename: "profile_image.png");
      params["platform_version"] = await GetVersion.platformVersion;

      LoginRepo().postUserLogin(params).then((value) {
        if (value.status) {
          UserPreferences().saveData(UserPreferences.SHARED_USER_ID, value.userId.toString());
          UserPreferences().saveData(UserPreferences.SHARED_USER_TOKEN, value.token);
          UserPreferences().saveData(UserPreferences.SHARED_USER_IMAGE, value.profileImage);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ContactPermissionScreen();
              },
            ),
          );
        } else {
          global.showToast(value.message);
        }
      });

    });


  }

  void getImage(String type) async {
    File image;
    if (type == "camera") {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    }
    if (type == "gallery") {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    if (image == null) {
      return;
    }

    setState(() {
      selectedImageFile = image;
    });
  }

  void imageSourceSelectionBS() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ImageSourceSelectionBSWidget(
          clickListener: (value) {
            Get.back();
            if (value == "camera" || value == "gallery") {
              getImage(value);
            }
            if (value == "emoji") {
              customiseSelectedEmojiBs(selectedEmoji);
            }
          },
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
    );
  }

//  void selectEmojiBS() {
//    showModalBottomSheet(
//      context: context,
//      builder: (context) {
//        return SingleChildScrollView(
//          child: Container(
//            child: Wrap(
//              children: global.emojiList.map((e) {
//                return Container();
//              }).toList(),
//            ),
//          ),
//        );
//      },
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.only(
//          topLeft: Radius.circular(50),
//          topRight: Radius.circular(50),
//        ),
//      ),
//    );
//  }

  void selectEmojiBS() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: Get.height,
            child: SingleChildScrollView(
              child: EmojiPicker(
                  rows: 5,
                  columns: 5,
                  recommendKeywords: ["racing", "horse"],
                  numRecommended: 10,
                  onEmojiSelected: (emoji, category) {
                    Get.back();
                    selectedEmoji = emoji.emoji;
                    customiseSelectedEmojiBs(emoji.emoji);

                    print(emoji);
                  },
                  selectedCategory: Category.SMILEYS),
            ));
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
    );

  }

  void customiseSelectedEmojiBs(String selectedEmoji) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CustomizeEmojiWidget(selectedEmoji: selectedEmoji,backgroundColorListener: (selectedColor){
          Get.back();
          setState(() {
            selectedImageFile = null;
            emojiBackgroundColor = selectedColor;
          });
        },editListener: (value){
          Get.back();
          selectEmojiBS();
        },);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
    );
  }


}


class InviteFriendsScreen extends StatefulWidget {

  final String redirection;

  const InviteFriendsScreen({Key key, this.redirection}) : super(key: key);


  @override
  _InviteFriendsScreenState createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {


  List<PostContactModel> localContactList = [];
  ContactModel contactModel;
  bool isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestForContactPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              width: Get.width,
              height: Get.height,
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20,10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: 40,),
                    InkWell(
                      onTap: (){
                        Get.back();
                      },
                        child: Icon(Icons.arrow_back_ios,color: Colors.black,size: 26,)
                    ),
                    SizedBox(height: 30,),
                    Text(
                      Strings.inviteFriendsTitle,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      Strings.inviteFriendsDesc,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        _buildDynamicLink("");
                      },
                      child: Container(
                        width: Get.width,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        padding: EdgeInsets.fromLTRB(10, 14, 10, 14),
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Invite",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    contactModel != null && contactModel.data != null
                        ? Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
                          child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                          return Container(
                            padding:
                            EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44.0,
                                  margin:
                                  EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(22),
                                    color: Colors.grey[200],
                                  ),
                                  child: ClipRRect(
                                    child: Image.network(
                                      contactModel.data[i].profileImage ??
                                          '',
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(22)),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      child: Text(
                                        contactModel.data[i].name,
                                        style: TextStyle(
                                            color: Colors.black,
                                            letterSpacing: 1.0,
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight.w500),
                                      ),
                                    )),
                                Visibility(
                                  visible: !contactModel.data[i].friend ? !contactModel.data[i].connectUser : false,
                                  child: Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        onTap: (){
                                          _buildDynamicLink(contactModel.data[i].phone);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(
                                              15, 5, 15, 5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.blue),
                                          child: Center(
                                            child: Text(
                                              'Invite',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  letterSpacing: 1.0,
                                                  fontFamily: 'Roboto',
                                                  fontSize: 14,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                                Visibility(
                                  visible: !contactModel.data[i].friend ? contactModel.data[i].connectUser :  false,
                                  child: Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        onTap: (){
//                                    sendEventInvite(contactModel.data[i].userId.toString());
                                          sendFriendRequest(contactModel.data[i].userId.toString());
                                        },
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(
                                              15, 5, 15, 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  20),
                                              color: Colors.green),
                                          child: Center(
                                            child: Text(
                                              'Request',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  letterSpacing: 1.0,
                                                  fontSize: 14,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                                Visibility(
                                  visible:
                                  contactModel.data[i].friend,
                                  child: Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        onTap: (){
//
                                        },
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(
                                              15, 5, 15, 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  20),
                                              color: Colors.green),
                                          child: Center(
                                            child: Icon(Icons.check,color : Colors.white,size: 20,),
                                          ),
                                        ),
                                      )),
                                ),

                              ],
                            ),
                          );
                      },
                      itemCount: contactModel.data.length,
                    ),
                        )
                        : LoadingWidget(),

                    SizedBox(
                      height: 50,
                    )

                  ],
                ),
              ),
            ),

            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20,10),
                width: double.infinity,
                child: DefaultButton(
                  text: widget.redirection == "home" ? "Done" : "Continue",
                  press: () {

                    if(widget.redirection == "home"){

                      Get.back();
                    }else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginSuccessScreen();
                          },
                        ),
                      );
                    }


                  },
                ),
              ),
            ),

            Visibility(
              visible: isLoading,
              child: Stack(
                children: [
                  Container(
                    width: Get.width,
                    height: Get.height,
                    color: Colors.white.withOpacity(0.4),
                  ),
                  Container(
                      width: Get.width,
                      height: Get.height,
                      child:  Center(
                        child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Get.theme.primaryColor),
                        ),
                      )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  void requestForContactPermission() async {
    if (await Permission.contacts.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      getAllContactList();
//    List<Contact> testList = await compute(getAllContactList,"Get Contact");
//    print(testList.length);
    }
  }

  void getAllContactList() async {
    Iterable<Contact> contacts =
    await ContactsService.getContacts(withThumbnails: false);
    for (Contact contact in contacts) {
      if (contact.displayName != null && contact.phones.length > 0) {
        String phoneNumber =
        contact.phones.toList()[0].value.replaceAll(" ", "");
        localContactList.add(
            PostContactModel(phone: phoneNumber, name: contact.displayName));
      }
    }
    postContact();
  }

  void postContact() {
//    if(localContactList.length > 100){
//      localContactList = localContactList.sublist(0,100);
//    }
    Map<String, dynamic> params = {"contacts": jsonEncode(localContactList)};

    HomeRepo().postContact(params).then((value) {
      if (value != null && value.status) {
        getContactList();
      }
    });
  }

  void getContactList() {
    Map<String, String> params = {};
//    if(widget.redirection != "home"){
      params["connect"] = "1";
//    }
    HomeRepo().getContactList(params).then((value) {
      if (value != null && value.data != null) {
        setState(() {
          contactModel = value;
        });
      }
    });
  }

  void inviteUserViaWhatsApp(String phoneNumber,String message)async{
    String url = 'https://wa.me/${phoneNumber}?text=${message}';
    if (await canLaunch(url)) {
      await launch(url);
      setState(() {
        isLoading = false;
      });
    } else {
      throw 'Could not launch $url';
    }
  }

  void _buildDynamicLink(String number) async {
    setState(() {
      isLoading = true;
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://connnect.page.link',
      link: Uri.parse('https://connect.joistic.com?'),
      androidParameters: AndroidParameters(
        packageName: 'com.connect.app',
      ),
      iosParameters: IosParameters(
        bundleId: 'com.connect.app',
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable,
      ),
    );

//    final Uri dynamicUrl = await parameters.buildShortLink();
    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri dynamicUrl = shortDynamicLink.shortUrl;

    print('Dynamiclink: $dynamicUrl');

//   inviteUserViaWhatsApp(number,"Download Connect App - ${dynamicUrl}");
    openShareOption("Download Connect App - ${dynamicUrl}");
//    Share.share('check out my website $dynamicUrl');
  }

  void openShareOption(String content){
    setState(() {
      isLoading = false;
    });
    Share.share(content);

  }

  void sendFriendRequest(String userId){

    setState(() {
      isLoading = true;
    });
    Map<String,String> params = {
      "user_id" : userId
    };
    HomeRepo().sendFriendRequest(params).then((value){
      setState(() {
        isLoading = false;
      });
      Config().displaySnackBar(value.message, "");
    });

  }

}


class ContactPermissionScreen extends StatefulWidget {
  @override
  _ContactPermissionScreenState createState() => _ContactPermissionScreenState();
}

class _ContactPermissionScreenState extends State<ContactPermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          children: [

            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
                child: Image.asset("assets/images/contact.gif",width: Get.width,height: 200,fit: BoxFit.cover,)
              ),
            ),

            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 50,),
                    Text(
                      Strings.connectFriends,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      Strings.searchForFriends,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Container(
                width: Get.width,
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      child: DefaultButton(
                        text: Strings.allowAccess,
                        press: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return InviteFriendsScreen(redirection: "loginSuccess",);
                                },
                              ));
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginSuccessScreen();
                            },
                          ),
                        );
                      },
                      child: Text(
                        Strings.contactSkip,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
