import 'dart:io';
import 'dart:ui';

import 'package:c0nnect/HomeScreen.dart';
import 'package:c0nnect/WhatsUp.dart';
import 'package:c0nnect/components/default_button.dart';
import 'package:c0nnect/contacts.dart';
import 'package:c0nnect/helper/shared_prefs.dart';
import 'package:c0nnect/newEvent.dart';
import 'package:c0nnect/repository/home_repo.dart';
import 'package:c0nnect/scan_code_screen.dart';
import 'package:c0nnect/widget/ScanSelectionBSWidget.dart';
import 'package:c0nnect/widget/ScannedUserWidget.dart';
import 'package:c0nnect/widget/UserQRCodeWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
// import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:get/get.dart';

import 'Setup/completeProfile.dart';
import 'create_challenge_screen.dart';
import 'main.dart';
import 'model/scan_code.dart';
import 'model/user_profile_model.dart';

class Controller extends StatefulWidget {
  @override
  _ControllerState createState() => _ControllerState();
}

class _ControllerState extends State<Controller> with AutomaticKeepAliveClientMixin<Controller> {
  bool _state;
  PageController _controller = PageController(
    initialPage: 1,
  );
  int currentPage=1;

  LocationData _position;
  bool _serviceEnabled;
  Location location = new Location();
  PermissionStatus _permissionGranted;

  bool createChallengeVisible = false;
  bool createEventVisible = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();
    print(UserPreferences().get(UserPreferences.SHARED_USER_TOKEN));
    _state = false;
//    getLocation();
    notificationCheck();
  }

  void _onVerticalSwipe(SwipeDirection direction) {
    setState(() {
      if (direction == SwipeDirection.up) {
        _state = true;
        HapticFeedback.mediumImpact();
        print('Swiped up!');
      } else {
        HapticFeedback.mediumImpact();
        _state = false;
        print('Swiped down!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    double _sigmaX = 3; // from 0-10
    double _sigmaY = 3; // from 0-10
    double _opacity = .0; // from 0-1.0

    var width = MediaQuery.of(context).size.width * 0.90;
    var nav_height = MediaQuery.of(context).size.width / 6;

    Widget navItem(String title, Icon icon, Function onPressed) {
      return Column(
        mainAxisAlignment: _state == true
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _state == true
              ? Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        onPressed();
                        HapticFeedback.mediumImpact();
                      },
                      icon: icon,
                    ),
                    Text(
                      title,
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                )
              : Column(
                  children: [
                    IconButton(
                        icon: icon,
                        onPressed: () {
                          onPressed();
                          HapticFeedback.mediumImpact();
                        })
                  ],
                )
        ],
      );
    }

    Widget bottomnav() {
      // starting
      var _myValue = 0.0;

      // ending
      final _myNewValue = 30.0;

      return Stack(
        children: [
          Column(children: [
            Expanded(
                child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: AnimatedContainer(
                margin: EdgeInsets.only(bottom: 20),
                duration: Duration(milliseconds: 150),
                height: _state == true
                    ? MediaQuery.of(context).size.width + 50
                    : nav_height + _myValue,
                width: width,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(28.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 15),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BoldButton(
                          text: "Host an event",
                          icon: Icons.edit,
                          press: () {
                            setState(() {
                              createEventVisible = true;
                            });
                          },
                        ),
                        BoldButton(
                          text: "Create challenge",
                          icon: Icons.edit,
                          press: () {

                            setState(() {
                              _state = false;
                              createChallengeVisible = true;
                            });
                          },
                        ),
                        BoldButton(
                          text: "Add some memories",
                          icon: Icons.notification_important,
                          press: () {},
                        ),

                        Row(
                          children: [

                            Expanded(
                              flex: 2,
                              child: InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16.0,right: 5),
                                  child: FlatButton(
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    color: Color(0xFFF5F6F9),
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      setState(() {
                                        _state = false;
                                      });
                                      openUserQRCode();
                                    },
                                    child:    Icon(
                                      Icons.qr_code,
                                      color: Colors.green.shade300,
                                      size: 22.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 8,
                              child: BoldButton(
                                text: "Invite friends to connect",
                                icon: Icons.people,
                                press: () {
                                  setState(() {
                                    _state = false;
                                  });
                                  Get.to(InviteFriendsScreen(redirection: "home",));
                                },
                              ),
                            ),
                          ],
                        ),


                        BoldButton(
                          text: "Close Action items",
                          icon: Icons.close,
                          press: () {
                            setState(() {
                              _state = false;

                            });

                            print('Swiped down!');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
          ]),
          AnimatedAlign(
            duration: Duration(milliseconds: 150),
            alignment: _state == true
                ? FractionalOffset.center
                : FractionalOffset.bottomCenter,
            child: AnimatedContainer(
              margin: EdgeInsets.only(bottom: _state ? 220 : 20),
              duration: Duration(milliseconds: 150),
              height:
                  _state == true ? nav_height + _myNewValue : nav_height + 10,
              width: width,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(28.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  navItem(
                    "Timeline",
                    Icon(
                      Icons.event,
                      color: currentPage == 0 ? Colors.green : Colors.grey[500]
                    ),
                    () {
                      _controller.animateToPage(0,duration: Duration(milliseconds: 300),curve: Curves.easeIn);
                    },
                  ),
                  navItem(
                    "Home",
                    Icon(
                      Icons.home,
                        color: currentPage == 1 ? Colors.green : Colors.grey[500]
                    ),
                    () {
                      _controller.animateToPage(1,duration: Duration(milliseconds: 300),curve: Curves.easeIn);
                    },
                  ),
                  navItem(
                    "Friends",
                    Icon(Icons.people,
                        color: currentPage == 2 ? Colors.green : Colors.grey[500]
                    ),
                    () {
                      _controller.animateToPage(2,duration: Duration(milliseconds: 300),curve: Curves.easeIn);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return WillPopScope(
      onWillPop: (){
        exit(0);
      },
      child: Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              color: Colors.black.withOpacity(_opacity),
              child: PageView(
                controller: _controller,
                onPageChanged: (index){
                  print("checking page --- ${index}");
                  setState(() {
                    currentPage = index;
                  });
                },
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: MapScreen(
                      openCreateEvent: (value){
                        setState(() {
                          createEventVisible = true;
                        });
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    child: HomeScreen(switchTab: (value){

                      if(value=='challenge'){
                        setState(() {
                          createChallengeVisible = true;
                        });
                      }else{
                        _controller.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                      }
                    },
                      openBottomBar: (value){
                      setState(() {
                        _state = true;
                      });
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    child: Contacts(),
                  )
                ],
              ),
            ),
            Positioned(
                width: _state == true ? MediaQuery.of(context).size.width : 0,
                height: _state == true ? MediaQuery.of(context).size.height : 0,
                // Note: without ClipRect, the blur region will be expanded to full
                // size of the Image instead of custom size
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _state = false;
                    });
                  },
                  child: ClipRect(
                      child: BackdropFilter(
                          filter: _state == true
                              ? ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY)
                              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                          child: GestureDetector(
                            child: Container(
                              color: Colors.black.withOpacity(_opacity),
                            ),
                          ))),
                )),
            SimpleGestureDetector(
              onVerticalSwipe: _onVerticalSwipe,
              swipeConfig: SimpleSwipeConfig(
                verticalThreshold: 40.0,
                horizontalThreshold: 40.0,
                swipeDetectionBehavior: SwipeDetectionBehavior.continuousDistinct,
              ),
              child: bottomnav(),
            ),

            //Create Challenge container
            Visibility(
              visible: createChallengeVisible,
              child: Container(
                width: Get.width,
                height: Get.height,
                child: CreateChallengeScreen(
                  backListener: (value){
                    setState(() {
                      createChallengeVisible = false;
                    });
                  },
                ),
              ),
            ) ,

            Visibility(
              visible: createEventVisible,
              child: Container(
                width: Get.width,
                height: Get.height,
                child: NewEvent(
                  closeCurrentPage: (value){
                    setState(() {
                      createEventVisible = false;
                    });
                  },
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  void openUserQRCode(){
    Get.dialog(
        UserQRCodeWidget(userCode: "hello",openScanner: (_) => openQRScan(),)
    );
  }

  void openQRScan()async{

    Navigator.of(context).push<ScanCode>(
      MaterialPageRoute(
        builder: (c) {
          return ScanCodeScreen(onBarcodeScanned: (barcodeValue){
            Get.back();
            print("Scanned barcode value --- ${barcodeValue}");
            getScannedUserData(barcodeValue);
          },);
        },
      ),
    );

  }

  void getScannedUserData(String qrCode){
    Map<String,String> params = {
      "qr_code" : qrCode
    };
    HomeRepo().getScannedUser(params).then((value) {
      openScannedUserWidget(value,qrCode);
    });
  }

  void openScannedUserWidget(UserProfileModel userProfileModel,String qrCode){
    Get.dialog(
        ScannedUserWidget(userProfileModel: userProfileModel,qrCode: qrCode,backListener: (_){
          Get.back();
        },)
    );
  }



  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive {
    return true;
  }


  void getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _position = await location.getLocation();

    print("Check User location ${_position.latitude} : ${_position.longitude}");

    Map<String,String> params = {
      "lat" : _position.latitude.toString(),
      "long" : _position.longitude.toString(),
    };
    HomeRepo().updateUserLocation(params).then((value) {

    });

  }

  void notificationCheck()async{
    final notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      await onSelectNotification(notificationAppLaunchDetails.payload);
    }
  }

  Future<void> onSelectNotification(String payload) async {
    notificationRedirection(payload);
  }

}
