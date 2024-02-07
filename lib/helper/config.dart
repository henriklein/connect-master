
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Config {

  static const PRIMARY_COLOR_2 =  Color(0xFF142850);
  static const PRIMARY_COLOR_2_600 =  Color(0xff112442);
  static const PRIMARY_COLOR_2_700 =  Color(0xff0a1a33);
  static const PRIMARY_COLOR_2_800 =  Color(0xff0d2344);
  static const PRIMARY_COLOR_2_400 =  Color(0xff1d375b);
  static const PRIMARY_COLOR_600 =  Color(0xFF5fc1be);
  static const ORANGE_COLOR =  Color(0xFFfebf63);
  static const ORANGE_COLOR_600 =  Color(0xFFcc8e44);
  static const ORANGE_COLOR_2 =  Color(0xFFf7944b);



  List colors = [Colors.red, Colors.green, Colors.yellow];
  Random random = new Random();

  void displaySnackBar(String title,String message){
    Get.snackbar(title, message, backgroundColor: Get.theme.primaryColor, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
  }


  List<Color> barColors = [
  Color.fromRGBO(193, 37, 82,1), Color.fromRGBO(255, 102, 0,1), Color.fromRGBO(245, 199, 0,1),
  Color.fromRGBO(106, 150, 31,1), Color.fromRGBO(179, 100, 53,1),Color.fromRGBO(179, 100, 53,1)
  ];

  showAlertDialog({BuildContext context,String actionText,String title,String content,Function action}) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Get.back();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(actionText),
      onPressed:  () {
        action();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


}