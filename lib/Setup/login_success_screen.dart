import 'package:c0nnect/PageController.dart';
import 'package:flutter/material.dart';
import 'package:c0nnect/components/default_button.dart';

import 'package:c0nnect/components/constants.dart';

class LoginSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          Image.asset(
            "assets/images/success.png",
            height: SizeConfig.screenHeight * 0.4, //40%
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.08),
          Text(
            "Login Success",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(30),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Spacer(),
          SizedBox(
            width: SizeConfig.screenWidth * 0.8,
            child: DefaultButton(
              text: "Go to home",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Controller();
                    },
                  ),
                );
              },
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
