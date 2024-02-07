import 'package:c0nnect/components/default_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanSelectionBSWidget extends StatelessWidget {
  final ValueChanged<String> clickListener;

  const ScanSelectionBSWidget({Key key, this.clickListener}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Do you want to scan QR Code or view your QR Code?',
            style: TextStyle(
                color: Colors.black,
                letterSpacing: 1.0,
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 20,),

          BoldButton(
            text: "Scanner",
            icon: Icons.qr_code_scanner_sharp,
            press: () {
              clickListener("scanner");
            },
          ),

          BoldButton(
            text: "QR Code",
            icon: Icons.qr_code,
            press: () {
              clickListener("qrCode");
            },
          ),

          SizedBox(height: 10,),

        ],
      ),
    );
  }
}
