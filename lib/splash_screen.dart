import 'package:c0nnect/Setup/completeProfile.dart';
import 'package:c0nnect/Setup/otp/otp_screen.dart';
import 'package:c0nnect/helper/shared_prefs.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();


    Future.delayed(Duration(milliseconds: 1500), () {

      if(UserPreferences().get(UserPreferences.SHARED_USER_TOKEN) != null){
        Get.offNamedUntil('/controller', (route) => false);
//        Get.to(OtpScreen());
      }else{
       Get.offNamedUntil("/login", (route) => false);
//          Get.to(ContactPermissionScreen());
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            Container(
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 160,
                    height: 160,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
