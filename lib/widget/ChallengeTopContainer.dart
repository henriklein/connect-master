
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChallengeTopContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
      alignment: Alignment.center,
      child: Container(
        width: 80,
        height: 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[400]
        ),
      ),
    );
  }
}
