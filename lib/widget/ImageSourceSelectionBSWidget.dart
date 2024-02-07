import 'package:c0nnect/helper/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageSourceSelectionBSWidget extends StatelessWidget {
  final ValueChanged<String> clickListener;

  const ImageSourceSelectionBSWidget({Key key, this.clickListener})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 10,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey[300]),
          ),

          //Emoji
          Container(
            width: Get.width,
            height: 1,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            decoration: BoxDecoration(color: Colors.grey[300]),
          ),
          InkWell(
            onTap: (){
              clickListener("emoji");
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                Strings.use_emoji,
                style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1.0,
                    fontSize: 22,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
          Container(
            width: Get.width,
            height: 1,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            decoration: BoxDecoration(color: Colors.grey[300]),
          ),


          //Take Selfie
          InkWell(
            onTap: (){
              clickListener("camera");

            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                Strings.take_selfie,
                style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1.0,
                    fontSize: 22,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
          Container(
            width: Get.width,
            height: 1,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            decoration: BoxDecoration(color: Colors.grey[300]),
          ),


          //Choose image
          InkWell(
            onTap: (){
              clickListener("gallery");

            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                Strings.choose_image,
                style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1.0,
                    fontSize: 22,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
          Container(
            width: Get.width,
            height: 1,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            decoration: BoxDecoration(color: Colors.grey[300]),
          ),

          //Close
          InkWell(
            onTap: (){
              Get.back();
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: Text(
                Strings.close,
                style: TextStyle(
                    color: Colors.grey[400],
                    letterSpacing: 1.0,
                    fontSize: 22,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
