import 'dart:io';
import 'dart:math';

import 'package:c0nnect/model/my_profile_model.dart';
import 'package:c0nnect/repository/home_repo.dart';
import 'package:c0nnect/widget/CustomizeEmojiWidget.dart';
import 'package:c0nnect/widget/EditProfileTextWidget.dart';
import 'package:c0nnect/widget/EditProfileTextWidget2.dart';
import 'package:c0nnect/widget/ImageSourceSelectionBSWidget.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'components/default_button.dart';
import 'helper/app_colors.dart';
import 'package:dio/dio.dart'as dio;
import 'helper/strings.dart';

import 'helper/config.dart';

class EditProfileScreen extends StatefulWidget {

  final MyProfileModel myProfileModel;

  const EditProfileScreen({Key key, this.myProfileModel}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File selectedImageFile;
  String selectedEmoji;
  Color emojiBackgroundColor = Colors.grey.withOpacity(0.5);
  String actionButtonText = "Continue";
  ScreenshotController screenshotController = ScreenshotController();
  bool isMaleSelected = true;
  DateTime selectedDate;
  String selectedDateStr;
  String networkImage;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController instaController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController snapchatController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    firstNameController.text = widget.myProfileModel.data.firstName ?? "";
    lastNameController.text = widget.myProfileModel.data.lastName ?? "";
    dobController.text = widget.myProfileModel.data.dob ?? "";
    facebookController.text = widget.myProfileModel.data.facebook ?? "";
    instaController.text = widget.myProfileModel.data.instagram ?? "";
    twitterController.text = widget.myProfileModel.data.twitter ?? "";
    snapchatController.text = widget.myProfileModel.data.snapchat ?? "";
    bioController.text = widget.myProfileModel.data.bio ?? "";

    if(widget.myProfileModel.data.gender != null){
      if(widget.myProfileModel.data.gender == "male"){
        isMaleSelected = true;
      }else{
        isMaleSelected = false;
      }
    }

    if(widget.myProfileModel.data.photo != null){
      networkImage = widget.myProfileModel.data.photo;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ),

                networkImage == null ?

                Stack(
                  children: [
                    selectedImageFile != null
                        ? Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 180,
                              height: 180.0,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                color: Colors.grey[200],
                              ),
                              child: ClipRRect(
                                child: Image.file(
                                  selectedImageFile,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(90)),
                              ),
                            ),
                          )
                        : Screenshot(
                            controller: screenshotController,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 180,
                                height: 180.0,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(90),
                                  color: emojiBackgroundColor,
                                ),
                                child: ClipRRect(
                                  child: Center(
                                    child: Text(
                                      selectedEmoji ?? "",
                                      style: TextStyle(
                                        fontSize: 60,
                                      ),
                                    ),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(90)),
                                ),
                              ),
                            ),
                          ),
                    Positioned(
                      bottom: 10,
                      right: 130,
                      child: InkWell(
                        onTap: () {
                          imageSourceSelectionBS();
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
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
                )
                :
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 180,
                        height: 180.0,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          color: Colors.grey[200],
                        ),
                        child: ClipRRect(
                          child: Image.network(
                            networkImage,
                            fit: BoxFit.cover,
                          ),
                          borderRadius:
                          BorderRadius.all(Radius.circular(90)),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 130,
                      child: InkWell(
                        onTap: () {
                          imageSourceSelectionBS();
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20)),
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

                Container(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EditProfileTextWidget(
                        controller: firstNameController,
                        label: "What is your first name",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      EditProfileTextWidget(
                          controller: lastNameController,
                          label: "What is your last name"),
                      SizedBox(
                        height: 20,
                      ),
                      EditProfileTextWidget(
                        controller: bioController,
                        label: "Bio",
                        minLine: 2,
                        maxLine: 3,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: (){
                          selectDate(context);
                        },
                        child: AbsorbPointer(
                          absorbing: true,
                          child: EditProfileTextWidget2(
                            controller: dobController,
                            image: "assets/images/calendar.png",
                            label: "Date of Birth",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Gender',
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 1.0,
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isMaleSelected = true;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: isMaleSelected
                                        ? Get.theme.primaryColor
                                        : Colors.grey[300]),
                                child: Center(
                                  child: Text(
                                    "Male",
                                    style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 1.0,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isMaleSelected = false;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: !isMaleSelected
                                        ? Get.theme.primaryColor
                                        : Colors.grey[300]),
                                child: Center(
                                  child: Text(
                                    'Female',
                                    style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 1.0,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      EditProfileTextWidget(
                        controller: addressController,
                        label: "Address",
                        minLine: 2,
                        maxLine: 3,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      EditProfileTextWidget2(
                        controller: facebookController,
                        image: "assets/images/facebook.png",
                        label: "Facebook Username eg(John Doe)",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      EditProfileTextWidget2(
                        controller: instaController,
                        image: "assets/images/insta.png",
                        label: "Instagram Username eg(JohnDoe23)",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      EditProfileTextWidget2(
                        controller: twitterController,
                        image: "assets/images/twitter.png",
                        label: "Twitter Username eg(john_doe23)",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      EditProfileTextWidget2(
                        controller: snapchatController,
                        image: "assets/images/snapchat.png",
                        label: "Snapchat Username eg(JohnDoe23)",
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.infinity,
                        child: DefaultButton(
                          text: "Continue",
                          press: () async{

                            if(selectedEmoji != null){
                              String dir = (await getApplicationDocumentsDirectory()).path;
                            screenshotController.capture(path: dir+"/${Random().nextInt(1000)}.png").then((value) async{
                            selectedImageFile = value;
                            updateUserDetails();
                            });
                            }else{
                              updateUserDetails();
                            }

                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: isLoading,
            child: Container(
                height: Get.height,
                width: Get.width,
                color: Colors.white.withOpacity(0.4),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Get.theme.primaryColor),
                  ),
                )),
          )
        ],
      ),
    );
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
      networkImage = null;
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
              selectEmojiBS();
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

  void selectEmojiBS() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
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
                selectedCategory: Category.SMILEYS));
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
        return CustomizeEmojiWidget(
          selectedEmoji: selectedEmoji,
          backgroundColorListener: (selectedColor) {
            Get.back();
            setState(() {
              networkImage = null;
              selectedImageFile = null;
              emojiBackgroundColor = selectedColor;
            });
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

  void selectDate(BuildContext context)async{
    selectedDate  = await
    showDatePicker(
      context: context,
      initialDate: DateTime(2000,02),
      firstDate: DateTime(1900,02),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Get.theme.primaryColor,
            accentColor: Get.theme.accentColor,
            colorScheme: ColorScheme.light(primary: Get.theme.primaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );

    selectedDateStr = DateFormat("yyyy-MM-dd").format(selectedDate);

    setState(() {
      dobController.text = selectedDateStr;
    });

  }


  void updateUserDetails()async {

    if(firstNameController.text.length == 0){
      Config().displaySnackBar(Strings.enterFirstName, "");
      return;
    }

    if(lastNameController.text.length == 0){
      Config().displaySnackBar(Strings.enterLastName, "");
      return;
    }

    FocusScope.of(context).unfocus();

    Map<String,dynamic> params = {
      "first_name" : firstNameController.text,
      "last_name" : lastNameController.text,
      "bio" : bioController.text,
      "dob" : dobController.text,
      "gender" : isMaleSelected ? "male" : "female",
      "address" : addressController.text,
      "facebook" : facebookController.text,
      "instagram" : instaController.text,
      "twitter" : twitterController.text,
      "snapchat" : snapchatController.text,
    };

    if(selectedImageFile != null){
      params["profile_image"] = await dio.MultipartFile.fromFile(selectedImageFile.path, filename: "profile_image.png");
    }

    setState(() {
      isLoading = true;
    });

    HomeRepo().postUserEdit(params).then((value){
      setState(() {
        isLoading = false;
      });
      if(value != null && value.status){
        Get.back();
        Config().displaySnackBar(value.message ?? "", "");
      }else{
        Config().displaySnackBar(value.message ?? "", "");
      }
    });

  }
}
