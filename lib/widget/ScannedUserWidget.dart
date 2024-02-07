import 'package:c0nnect/components/default_button.dart';
import 'package:c0nnect/globals.dart';
import 'package:c0nnect/helper/config.dart';
import 'package:c0nnect/model/user_profile_model.dart';
import 'package:c0nnect/repository/home_repo.dart';
import 'package:c0nnect/widget/LoadingWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScannedUserWidget extends StatefulWidget {
  final UserProfileModel userProfileModel;
  final String qrCode;
  final ValueChanged<String> backListener;

  const ScannedUserWidget({Key key, this.userProfileModel, this.qrCode, this.backListener}) : super(key: key);

  @override
  _ScannedUserWidgetState createState() => _ScannedUserWidgetState();
}

class _ScannedUserWidgetState extends State<ScannedUserWidget> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: Get.width,
              margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.userProfileModel.data.photo ?? ""),
                    radius: 60,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${widget.userProfileModel.data.firstName} ${widget.userProfileModel.data.lastName}',
                    //Text('user',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 25.0),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.userProfileModel.data.bio ?? "",
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 14, 0, 14),
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 4,
                                  blurRadius: 6,
                                  offset:
                                  Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLoading = true;
                                });
                                sendFriendRequest();
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 14, 0, 14),
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 4,
                                      blurRadius: 6,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "Connect",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),

          Visibility(
            visible: isLoading,
            child: Container(
              width: Get.width,
              height: Get.height,
              color: Colors.white.withOpacity(0.5),
              child: Center(child: LoadingWidget()),
            ),
          )
        ],
      ),
    );
  }

  void sendFriendRequest(){
    Map<String,String> params = {
      "user_id" : widget.userProfileModel.data.id.toString(),
      "qr_code" :  widget.qrCode
    };
    HomeRepo().sendFriendRequest(params).then((value){
      widget.backListener("");
      setState(() {
        isLoading = false;
      });
      Config().displaySnackBar(value.message, "");
    });
  }

}
