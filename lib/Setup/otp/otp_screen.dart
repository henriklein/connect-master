import 'dart:io';

import 'package:c0nnect/PageController.dart';
import 'package:c0nnect/Setup/completeProfile.dart';

import 'package:c0nnect/components/default_button.dart';
import 'package:c0nnect/helper/shared_prefs.dart';
import 'package:c0nnect/helper/strings.dart';
import 'package:c0nnect/repository/login_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:c0nnect/components/constants.dart';
import 'package:c0nnect/globals.dart' as globals;
import 'package:get/get.dart';

class OtpScreen extends StatefulWidget {
  static String routeName = "/otp";

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController _box1 = TextEditingController();
  TextEditingController _box2 = TextEditingController();
  TextEditingController _box3 = TextEditingController();
  TextEditingController _box4 = TextEditingController();
  TextEditingController _box5 = TextEditingController();
  TextEditingController _box6 = TextEditingController();

  TextEditingController otpController = TextEditingController();

  FocusNode pin2FocusNode;
  FocusNode pin3FocusNode;
  FocusNode pin4FocusNode;
  FocusNode pin5FocusNode;
  FocusNode pin6FocusNode;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
    super.initState();
    _verifyPhone();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  String _verificationCode;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.1),
                  Text(
                    "OTP Verification",
                    style: headingStyle,
                  ),
                  Text("We sent your code to " + globals.userPhoneNumber),
                  buildTimer(),
                  Form(
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfig.screenHeight * 0.15),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: [
//                            SizedBox(
//                              width: getProportionateScreenWidth(40),
//                              child: TextFormField(
//                                controller: _box1,
//                                autofocus: true,
//                                obscureText: false,
//                                style: TextStyle(fontSize: 24),
//                                keyboardType: TextInputType.number,
//                                textAlign: TextAlign.center,
//                                decoration: otpInputDecoration,
//                                onChanged: (value) {
//                                  nextField(value, pin2FocusNode);
//                                },
//                              ),
//                            ),
//                            SizedBox(
//                              width: getProportionateScreenWidth(40),
//                              child: TextFormField(
//                                controller: _box2,
//                                focusNode: pin2FocusNode,
//                                obscureText: false,
//                                style: TextStyle(fontSize: 24),
//                                keyboardType: TextInputType.number,
//                                textAlign: TextAlign.center,
//                                decoration: otpInputDecoration,
//                                onChanged: (value) {
//                                  nextField(value, pin3FocusNode);
//                                },
//                              ),
//                            ),
//                            SizedBox(
//                              width: getProportionateScreenWidth(40),
//                              child: TextFormField(
//                                controller: _box3,
//                                focusNode: pin3FocusNode,
//                                obscureText: false,
//                                style: TextStyle(fontSize: 24),
//                                keyboardType: TextInputType.number,
//                                textAlign: TextAlign.center,
//                                decoration: otpInputDecoration,
//                                onChanged: (value) =>
//                                    nextField(value, pin4FocusNode),
//                              ),
//                            ),
//                            SizedBox(
//                              width: getProportionateScreenWidth(40),
//                              child: TextFormField(
//                                controller: _box4,
//                                focusNode: pin4FocusNode,
//                                obscureText: false,
//                                style: TextStyle(fontSize: 24),
//                                keyboardType: TextInputType.number,
//                                textAlign: TextAlign.center,
//                                decoration: otpInputDecoration,
//                                onChanged: (value) =>
//                                    nextField(value, pin5FocusNode),
//                              ),
//                            ),
//                            SizedBox(
//                              width: getProportionateScreenWidth(40),
//                              child: TextFormField(
//                                controller: _box5,
//                                focusNode: pin5FocusNode,
//                                obscureText: false,
//                                style: TextStyle(fontSize: 24),
//                                keyboardType: TextInputType.number,
//                                textAlign: TextAlign.center,
//                                decoration: otpInputDecoration,
//                                onChanged: (value) =>
//                                    nextField(value, pin6FocusNode),
//                              ),
//                            ),
//                            SizedBox(
//                              width: getProportionateScreenWidth(40),
//                              child: TextFormField(
//                                controller: _box6,
//                                focusNode: pin6FocusNode,
//                                obscureText: false,
//                                style: TextStyle(fontSize: 24),
//                                keyboardType: TextInputType.number,
//                                textAlign: TextAlign.center,
//                                decoration: otpInputDecoration,
//                                onChanged: (value) async {
//                                  globals.userOTPinput = _box1.text +
//                                      _box2.text +
//                                      _box3.text +
//                                      _box4.text +
//                                      _box5.text +
//                                      _box6.text;
//                                  print("USER OTP INPUT = " + globals.userOTPinput);
//                                  if (value.length == 1) {
//                                    pin6FocusNode.unfocus();
//                                    // Then you need to check is the code is correct or not
//                                    verifyOtpNew();
//                                  }
//                                },
//                              ),
//                            ),
//                          ],
//                        ),


                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: TextFormField(
                                controller: otpController,
                                autofocus: true,
                                obscureText: false,
                                maxLength: 6,
                                style: TextStyle(fontSize: 20),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding:
                                  EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
                                  border: outlineInputBorder(),
                                  focusedBorder: outlineInputBorder(),
                                  hintText: "ENTER OTP",
                                  hintStyle: TextStyle(fontSize: 16),
                                  enabledBorder: outlineInputBorder(),
                                ),
                                onChanged: (value) {

                                }),
                          ),
                        ),

                        SizedBox(height: 30),

                        Container(
                          width: double.infinity,
                          child: DefaultButton(
                            text: "Continue",
                            press: () {
                              globals.userOTPinput = otpController.text;
                              verifyOtpNew();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      // OTP code resend
                    },
                    child: Text(
                      "Resend OTP Code",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.green),
                    ),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: isLoading,
            child: Container(
              width: Get.width,
              height: Get.height,
              color: Colors.white.withOpacity(0.4),
              child: Center(
                child:  Center(
                  child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Get.theme.primaryColor),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("This code will expired in "),
        TweenAnimationBuilder(
          tween: Tween(begin: 90.0, end: 0),
          duration: Duration(seconds: 90),
          builder: (_, value, child) => Text(
            "${value.toInt()}",
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: globals.userPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              print("USER LOGGED IN");
              loginCheck();
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationID, int resendToken) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 60));
  }



  void verifyOtpNew()async{
    try {
      await FirebaseAuth.instance
          .signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: _verificationCode,
              smsCode: globals.userOTPinput))
          .then((value) async {
        if (value.user != null) {
          //Otp verified
          loginCheck();
        }else{
          globals.showToast(Strings.invalid_otp);
        }
      });
    } catch (e) {
      print("INVALID OTP");
 //     globals.showToast(Strings.invalid_otp);

    }
  }


  void loginCheck()async{

    setState(() {
      isLoading = true;
    });

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    await _firebaseMessaging.getToken().then((String token) {
      assert(token != null);

      Map<String,String> params = {
        "phone" : globals.userPhoneNumber,
        "notification_token" : token,
        "platform" : Platform.isAndroid ? "android" : "ios"
      };

      LoginRepo().loginCheck(params).then((value) {

        if(value != null && value.status){
          UserPreferences().saveData(UserPreferences.SHARED_USER_ID, value.userId.toString());
          UserPreferences().saveData(UserPreferences.SHARED_USER_NAME, value.userName);
          UserPreferences().saveData(UserPreferences.SHARED_USER_IMAGE, value.profileImage);

          UserPreferences().saveData(UserPreferences.SHARED_USER_TOKEN, value.token);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Controller();
              },
            ),
          );

        }else{

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddName();
              },
            ),
          );

        }

      });

    });



  }


}
