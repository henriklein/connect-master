import 'package:c0nnect/components/default_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaSelectionBSWidget extends StatelessWidget {
  final ValueChanged<String> clickListener;

  const MediaSelectionBSWidget({Key key, this.clickListener}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Media Type',
            style: TextStyle(
                color: Colors.black,
                letterSpacing: 1.0,
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 20,),

          BoldButton(
            text: "Image",
            icon: Icons.image,
            press: () {
              clickListener("image");
            },
          ),

          BoldButton(
            text: "Video",
            icon: Icons.video_library,
            press: () {
              clickListener("video");
            },
          ),

          SizedBox(height: 10,),

        ],
      ),
    );
  }
}
