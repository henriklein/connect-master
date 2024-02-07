import 'package:c0nnect/helper/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';



class AcceptTermsWidget extends StatelessWidget {

  final Color textColor;
  final Color linkColor;
  final EdgeInsets padding;

  const AcceptTermsWidget({Key key, this.textColor, this.linkColor, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:padding??EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 2.5,
        children: [
          Text(
            'By continuing you agree with connect\'s',
            style: TextStyle(color:textColor??Colors.grey, letterSpacing: 0.5, fontFamily: 'Quicksand', fontSize: 11, fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 5,),
          InkWell(
            onTap: ()async{
              if (await canLaunch(ApiUrls.TERMS_URL)){
                await launch(ApiUrls.TERMS_URL);
              }
            },
            child: Text(
              'Terms of Use'.tr,
              style: TextStyle(    decoration: TextDecoration.underline,
                  color: Colors.green, letterSpacing: 0.5, fontFamily: 'Quicksand', fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(width: 5,),
          Text(
            'and confirm that you have read connect\'s '.tr,
            style: TextStyle(color:Colors.grey, letterSpacing: 0.5, fontFamily: 'Quicksand', fontSize: 11, fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 5,),
          InkWell(
            onTap: ()async{
              if (await canLaunch(ApiUrls.PRIVACY_URL)){
                await launch(ApiUrls.PRIVACY_URL);
              }
            },
            child: Text(
              'Privacy Policy'.tr,
              style: TextStyle( decoration: TextDecoration.underline,color: Colors.green, letterSpacing: 0.5, fontFamily: 'Quicksand', fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(width: 5,),

        ],
      ),
    );
  }
}
