
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: Get.width,
        child: Center(
          child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Get.theme.primaryColor),
          ),
        )
    );
  }
}
