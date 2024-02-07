import 'dart:io';

import 'package:barcode/barcode.dart';
import 'package:c0nnect/components/default_button.dart';
import 'package:c0nnect/globals.dart';
import 'package:c0nnect/model/my_profile_model.dart';
import 'package:c0nnect/model/user_profile_model.dart';
import 'package:c0nnect/widget/LoadingWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class UserQRCodeWidget extends StatefulWidget {
  final String userCode;
  final ValueChanged<String> openScanner;
  const UserQRCodeWidget({Key key, this.userCode, this.openScanner}) : super(key: key);

  @override
  _UserQRCodeWidgetState createState() => _UserQRCodeWidgetState();
}

class _UserQRCodeWidgetState extends State<UserQRCodeWidget> {
  File barcodeSvgFile;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
      buildBarcode(Barcode.aztec(), widget.userCode ?? "", height: 200);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: Get.width,
          margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'QR Code',
                style: TextStyle(color: Colors.black,
                    letterSpacing: 1.0,
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              barcodeSvgFile != null
                  ? SvgPicture.file(
                barcodeSvgFile,
                color: Colors.black,
                fit: BoxFit.contain,
              )
                  : LoadingWidget(),

              SizedBox(height: 25,),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                        width: Get.width,
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),
                              color: Colors.grey[300]),
                          child: Center(
                            child: Text('CLOSE',
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: (){
                        Get.back();
                        widget.openScanner("");
                      },
                      child: Container(
                        width: Get.width,
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),
                              color: Colors.green),
                          child: Center(
                            child: Text('SCANNER',
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),

            ],
          ),
        ),
      ),
    );
  }

  void buildBarcode(Barcode bc,
      String data, {
        String filename,
        double width,
        double height,
        double fontHeight,
      }) async {
    /// Create the Barcode
    final svg = bc.toSvg(
      data,
      width: width ?? 200,
      height: height ?? 80,
      fontHeight: fontHeight ?? 2,
    );

    // Save the image
//    filename = generateRandomString(10);
    filename = "scanner";

    String dir = (await getApplicationDocumentsDirectory()).path;

    if (File('${dir}/${filename}.svg').existsSync()) {
      print("File exist");
    } else {
      File('${dir}/${filename}.svg').writeAsStringSync(svg);
      print("File not exist");
    }

    setState(() {
      barcodeSvgFile = File('${dir}/${filename}.svg');
      print("Checking barcode file --- ${barcodeSvgFile.path}");
    });
  }
}
