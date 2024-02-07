import 'package:c0nnect/helper/shared_prefs.dart';
import 'package:c0nnect/helper/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:c0nnect/globals.dart' as globals;

class ChallengeTitleWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        children: [

          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.grey
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(UserPreferences().get(UserPreferences.SHARED_USER_IMAGE) ?? "", width: 80, height: 80,fit: BoxFit.cover,),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.challengeTitle,
                  style: TextStyle(color: Colors.black, letterSpacing: 1.0,
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10,),
                Flexible(
                  child: Text(
                    globals.challengeString,
                    style: TextStyle(color: Colors.grey[400], letterSpacing: 1.0,
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }
}
