import 'dart:convert';

import 'package:c0nnect/components/constants.dart';
import 'package:c0nnect/helper/config.dart';
import 'package:c0nnect/helper/shared_prefs.dart';
import 'package:c0nnect/repository/home_repo.dart';
import 'package:c0nnect/repository/login_repo.dart';
import 'package:c0nnect/widget/ChallengeTitleWidget.dart';
import 'package:c0nnect/widget/ChallengeTopContainer.dart';
import 'package:c0nnect/widget/LoadingWidget.dart';
import 'package:c0nnect/widget/TimePickerWidget.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:table_calendar/table_calendar.dart';

import 'components/default_button.dart';
import 'helper/strings.dart';
import 'package:c0nnect/globals.dart' as globals;

import 'model/category_model.dart';
import 'model/contact_model.dart';
import 'model/post_contact_model.dart';

class CreateChallengeScreen extends StatefulWidget {
  final ValueChanged<String> backListener;

  const CreateChallengeScreen({Key key, this.backListener}) : super(key: key);

  @override
  _CreateChallengeScreenState createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.black.withOpacity(0.7),
      body: Stack(
        children: [
          Positioned(
            top: Get.height*0.05,
            child: InkWell(
              onTap: () {
                widget.backListener("");
              },
              child: Container(
                width: Get.width,
                height: Get.height,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.cancel,size: 38,color:Colors.white),
                  ),
                ),
              ),
            ),
          ),
          DraggableScrollableActuator(
            child: DraggableScrollableSheet(
                initialChildSize: 0.8,
                minChildSize: 0.8,
                maxChildSize: 1,
                builder: (BuildContext context, scrollController) {
                  return Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          topLeft: Radius.circular(50),
                        ),
                        color: Colors.white,
                      ),
                      child: PageView(
                        scrollDirection: Axis.vertical,
                        controller: pageController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          ChallengeCategorySelectionScreen(
                            pageChangeListener: (value) {
                              nextPage();
                            },
                          ),
                          ChallengeNameScreen(
                            pageChangeListener: (value) {
                              nextPage();
                            },
                          ),
//                          ChallengeLocationScreen(
//                            pageChangeListener: (value) {
//                              nextPage();
//                            },
//                          ),
//                          ChallengeDateScreen(
//                            pageChangeListener: (value) {
//                              nextPage();
//                            },
//                          ),
                          ChallengeInviteScreen(
                            pageChangeListener: (value) {
                              nextPage();
                            },
                            backListener: (_) {
//                              widget.backListener("");
                              Get.offNamedUntil("/controller", (route) => false);
                            },
                            fromDetailPage: false,
                          )
                        ],
                      ));
                }),
          ),
        ],
      ),
    );
  }

  void nextPage() {
    pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }
}

class ChallengeCategorySelectionScreen extends StatefulWidget {
  final ValueChanged<String> pageChangeListener;

  const ChallengeCategorySelectionScreen({Key key, this.pageChangeListener}) : super(key: key);

  @override
  _ChallengeCategorySelectionScreenState createState() => _ChallengeCategorySelectionScreenState();
}

class _ChallengeCategorySelectionScreenState extends State<ChallengeCategorySelectionScreen> with AutomaticKeepAliveClientMixin<ChallengeCategorySelectionScreen> {
  CategoryModel categoryModel;
  List<Subcategories> subcategoriesList = [];
  String selectedCategoryId;
  String selectedCategoryName;
  String selectedSubCategoryName;
  String selectedSubCategoryId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ChallengeTopContainer(),
            SizedBox(
              height: 50,
            ),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(60), color: Colors.grey),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.network(
                  UserPreferences().get(UserPreferences.SHARED_USER_IMAGE) ?? "",
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              Strings.challengeTitle,
              style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 26, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            categoryModel != null && categoryModel.data != null && categoryModel.data.length > 0
                ? Wrap(
                    children: categoryModel.data.map((e) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            deSelectAllCategory();
                            e.isSelected = true;
                            subcategoriesList = [];
                            subcategoriesList.addAll(e.subcategories);
                            for (int i = 0; i < subcategoriesList.length; i++) {
                              subcategoriesList[i].isSelected = false;
                            }

                            selectedCategoryName = e.name;
                            selectedCategoryId = e.id.toString();
                          });
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                          margin: EdgeInsets.fromLTRB(12, 12, 12, 12),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: Colors.white, border: Border.all(color: e.isSelected ? Colors.green : Colors.grey[300], width: 2)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: Image.network(
                              e.icon,
                              width: 10,
                              height: 10,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                : Container(
                    child: LoadingWidget(),
                  ),
            subcategoriesList != null && subcategoriesList.length > 0
                ? Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Wrap(
                      children: subcategoriesList.map((e) {
                        return InkWell(
                          onTap: () {
                            for (int i = 0; i < subcategoriesList.length; i++) {
                              subcategoriesList[i].isSelected = false;
                            }

                            e.isSelected = true;

                            selectedSubCategoryName = e.name;
                            selectedSubCategoryId = e.id.toString();
                            setState(() {});
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            decoration: BoxDecoration(color: e.isSelected ? Colors.green.withOpacity(0.4) : Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.all(Radius.circular(22))),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                              child: Text(
                                e.name,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 40,
            ),
            if (selectedCategoryId != null && selectedSubCategoryId != null)
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Container(
                    width: double.infinity,
                    child: DefaultButton(
                      text: "Continue",
                      press: () {
                        challengeParams["category_id"] = selectedSubCategoryId;

                        globals.challengeString = selectedCategoryName + " -> " + selectedSubCategoryName;
                        widget.pageChangeListener("");
                      },
                    )),
              ),
          ],
        ),
      ),
    );
  }

  void getCategory() {
    Map<String, String> params = {"type": "challenge"};
    LoginRepo().getCategoryData(params).then((value) {
      if (value != null && value.data != null && value.data.length > 0) {
        setState(() {
          categoryModel = value;
        });
      }
    });
  }

  void deSelectAllCategory() {
    for (int i = 0; i < categoryModel.data.length; i++) {
      categoryModel.data[i].isSelected = false;
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive {
    return true;
  }
}

class ChallengeNameScreen extends StatefulWidget {
  final ValueChanged<String> pageChangeListener;

  const ChallengeNameScreen({Key key, this.pageChangeListener}) : super(key: key);

  @override
  _ChallengeNameScreenState createState() => _ChallengeNameScreenState();
}

class _ChallengeNameScreenState extends State<ChallengeNameScreen> with AutomaticKeepAliveClientMixin<ChallengeNameScreen> {
  TextEditingController challengeNameController = TextEditingController();
  TextEditingController challengeDescController = TextEditingController();
  TextEditingController challengeHoursController = TextEditingController();

  bool privateChallenge = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ChallengeTopContainer(),
                SizedBox(
                  height: 10,
                ),
                ChallengeTitleWidget(),
                SizedBox(
                  height: 20,
                ),
//                Container(
//                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                  child: SwitchListTile(
//                    title: const Text('This is a private event'),
//                    value: privateChallenge,
//                    onChanged: (bool value) {
//                      setState(() {
//                        privateChallenge = value;
//                      });
//                    },
//                  ),
//                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 20, 40, 0),
                  child: TextFormField(
                    controller: challengeNameController,
                    decoration: InputDecoration(
                        labelText: 'Name your Challenge',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat', //First Name
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: TextField(
                    controller: challengeDescController,
                    maxLength: 180,
                    maxLines: 4,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        alignLabelWithHint: false,
                        labelText: 'Add a short description',
                        hintMaxLines: 2,
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat', //First Name
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40,top: 0,bottom: 30),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              challengeHoursController.text = "24";
                            });
                          },
                          child: Container(
                            width: Get.width,
                                              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                border: Border.all(color: Colors.green,width: 1),
                                              ),
                            child:  Center(
                              child: Text('24',
                                     style: TextStyle(
                                      color: Colors.black,
                                       letterSpacing: 1.0,
                                         fontFamily: 'Roboto',
                                    fontSize: 13,
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
                            setState(() {
                              challengeHoursController.text = "48";
                            });
                          },
                          child: Container(
                            width: Get.width,
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              border: Border.all(color: Colors.green,width: 1),
                            ),
                            child:  Center(
                              child: Text('48',
                                style: TextStyle(
                                    color: Colors.black,
                                    letterSpacing: 1.0,
                                    fontFamily: 'Roboto',
                                    fontSize: 13,
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
                            setState(() {
                              challengeHoursController.text = "72";
                            });
                          },
                          child: Container(
                            width: Get.width,
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              border: Border.all(color: Colors.green,width: 1),
                            ),
                            child:  Center(
                              child: Text('72',
                                style: TextStyle(
                                    color: Colors.black,
                                    letterSpacing: 1.0,
                                    fontFamily: 'Roboto',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40,top: 0,bottom: 30),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Challenge Completes in : ',
                          style: TextStyle(color: Colors.black,
                               fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Expanded(
                        flex:2,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:  BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: challengeHoursController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                                      hintText: '',
                                      counterText: "",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: Colors.white, width: 1),
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    ),
                                    maxLength: 3,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),

                                  ),
                                ),

                                SizedBox(width: 10,),
                                Expanded(
                                  child: Text(
                                    'Hrs',
                                    style: TextStyle(color: Colors.black,
                                        fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Container(
                      width: double.infinity,
                      child: DefaultButton(
                        text: "Continue",
                        press: () {
                          if (challengeNameController.text.length <= 0) {
                            Config().displaySnackBar("Enter title", "");
                            return;
                          }

                          if (challengeDescController.text.length <= 0) {
                            Config().displaySnackBar("Enter description", "");
                            return;
                          }

                          if (challengeHoursController.text.length <= 0) {
                            Config().displaySnackBar("Enter Hours To Complete", "");
                            return;
                          }

                          challengeParams["name"] = challengeNameController.text;
                          challengeParams["description"] = challengeDescController.text;
                          challengeParams["public"] = privateChallenge ? "0" : "1";
                          challengeParams["challenge_duration"] = challengeHoursController.text;

//                          widget.pageChangeListener("");
                        createChallenge();
                        },
                      )),
                )
              ],
            ),
          ),
          Visibility(
            visible: isLoading,
            child: Container(
              width: Get.width,
              height: Get.height,
              color: Colors.white.withOpacity(0.4),
              child: Center(child: LoadingWidget()),
            ),
          )
        ],
      ),
    );
  }

  void createChallenge() {
    setState(() {
      isLoading = true;
    });
//    challengeParams["event_type"] = "offline";
    challengeParams["type"] = "challenge";
    HomeRepo().createChallenge(challengeParams).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.status) {
        eventId = value.eventId.toString();
        widget.pageChangeListener("");
        Config().displaySnackBar(value.message, "");
      } else {
        Config().displaySnackBar(value.message, "");
      }
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive {
    return true;
  }
}

//class ChallengeLocationScreen extends StatefulWidget {
//  final ValueChanged<String> pageChangeListener;
//
//  const ChallengeLocationScreen({Key key, this.pageChangeListener}) : super(key: key);
//
//  @override
//  _ChallengeLocationScreenState createState() => _ChallengeLocationScreenState();
//}
//
//class _ChallengeLocationScreenState extends State<ChallengeLocationScreen> with AutomaticKeepAliveClientMixin<ChallengeLocationScreen> {
//  String selectedAddress;
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      width: Get.width,
//      child: SingleChildScrollView(
//        child: Column(
//          children: [
//            ChallengeTopContainer(),
//            SizedBox(
//              height: 10,
//            ),
//            ChallengeTitleWidget(),
//            SizedBox(
//              height: 150,
//            ),
//            Column(
//              children: [
//                Container(
//                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                  child: Text(
//                    selectedAddress == null ? 'Select Challenge Location' : selectedAddress,
//                    style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 18, fontWeight: FontWeight.w400),
//                  ),
//                ),
//                InkWell(
//                  onTap: () {
//                    openGoogleMap();
//                  },
//                  child: Container(
//                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
//                    padding: EdgeInsets.fromLTRB(50, 12, 50, 12),
//                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.blue[500]),
//                    child: Text(
//                      'MAP',
//                      style: TextStyle(color: Colors.white, letterSpacing: 1.0, fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.w600),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//            SizedBox(
//              height: 150,
//            ),
//            Padding(
//              padding: const EdgeInsets.only(left: 40, right: 40),
//              child: Container(
//                  width: double.infinity,
//                  child: DefaultButton(
//                    text: "Continue",
//                    press: () {
//                      if (selectedAddress == null) {
//                        Config().displaySnackBar("Select Challenge Location", "");
//                        return;
//                      }
//                      widget.pageChangeListener("");
//                    },
//                  )),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//
//  void openGoogleMap() async {
//    LocationResult result = await showLocationPicker(
//      context,
//      Strings.GOOGLE_PLACES_API_KEY,
////      initialCenter: LatLng(37.7749295, -122.4194155),
//      myLocationButtonEnabled: true,
//      layersButtonEnabled: true,
//    );
//
//    setState(() {
//      selectedAddress = result.address;
//      challengeParams["location"] = result.address;
//      challengeParams["latitude"] = result.latLng.latitude.toString();
//      challengeParams["longitude"] = result.latLng.longitude.toString();
//      challengeParams["address"] = result.address;
////      selectedLocation = result.address;
////      lat = result.latLng.latitude.toString();
////      long = result.latLng.longitude.toString();
//    });
//  }
//
//  @override
//  // TODO: implement wantKeepAlive
//  bool get wantKeepAlive {
//    return true;
//  }
//}

//class ChallengeDateScreen extends StatefulWidget {
//  final ValueChanged<String> pageChangeListener;
//
//  const ChallengeDateScreen({Key key, this.pageChangeListener}) : super(key: key);
//
//  @override
//  _ChallengeDateScreenState createState() => _ChallengeDateScreenState();
//}
//
//class _ChallengeDateScreenState extends State<ChallengeDateScreen> {
//  CalendarController _controller = CalendarController();
//  DateTime initialDateTime = DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
//  String selectedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
//  String fromTime, toTime, postFromTime, postToTime;
//
//  bool isLoading = false;
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      width: Get.width,
//      child: Stack(
//        children: [
//          SingleChildScrollView(
//            child: Column(
//              children: [
//                ChallengeTopContainer(),
//                SizedBox(
//                  height: 10,
//                ),
//                ChallengeTitleWidget(),
//                SizedBox(
//                  height: 10,
//                ),
//                Padding(
//                    padding: EdgeInsets.all(10),
//                    child: TableCalendar(
//                      startingDayOfWeek: StartingDayOfWeek.monday,
//                      calendarController: _controller,
//                      initialSelectedDay: initialDateTime,
//                      onDaySelected: (day, events, holidays) {
//                        selectedDate = day.toString().substring(0, 10);
//                      },
//                      calendarStyle: CalendarStyle(
//                        selectedColor: Colors.green[400],
//                        todayColor: Colors.green[200],
//                        markersColor: Colors.brown[700],
//                        outsideDaysVisible: false,
//                      ),
//                      headerStyle: HeaderStyle(
//                        formatButtonVisible: false,
//                      ),
//                    )),
//                Container(
//                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
//                  child: Column(
//                    mainAxisSize: MainAxisSize.min,
//                    children: [
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: [
//                          Text(
//                            'Choose Start Time',
//                            style: TextStyle(color: Colors.black, letterSpacing: 0.3,
//                                fontSize: 18, fontWeight: FontWeight.w600),
//                          ),
//                          InkWell(
//                            onTap: (){
//
//                              openCupertinoTimePicker("from");
//                            },
//                            child: Container(
//                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                              padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
//                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
//                                  color: Colors.green[500]),
//                              child:  Text(fromTime == null ? "Select" : fromTime,
//                                style: TextStyle(
//                                    color: Colors.white,
//                                    letterSpacing: 1.0,
//                                    fontFamily: 'Roboto',
//                                    fontSize: 12,
//                                    fontWeight: FontWeight.w600
//                                ),
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                      SizedBox(height: 20,),
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: [
//                          Text(
//                            'Choose End Time',
//                            style: TextStyle(color: Colors.black, letterSpacing: 0.3,
//                                fontSize: 18, fontWeight: FontWeight.w600),
//                          ),
//                          InkWell(
//                            onTap: (){
//
//                              openCupertinoTimePicker("to");
//                            },
//                            child: Container(
//                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                              padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
//                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
//                                  color: Colors.green[500]),
//                              child:  Text(toTime == null ? "Select" : toTime,
//                                style: TextStyle(
//                                    color: Colors.white,
//                                    letterSpacing: 1.0,
//                                    fontFamily: 'Roboto',
//                                    fontSize: 12,
//                                    fontWeight: FontWeight.w600
//                                ),
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ],
//                  ),
//                ),
//                SizedBox(height: 20,),
//                Padding(
//                  padding: const EdgeInsets.only(left: 40, right: 40),
//                  child: Container(
//                      width: double.infinity,
//                      child: DefaultButton(
//                        text: "Continue",
//                        press: () {
//
//                          if(selectedDate == null){
//                            Config().displaySnackBar("Select Challenge Date", "");
//                            return;
//                          }
//
//                          if(postFromTime == null){
//                            Config().displaySnackBar("Select Start Time", "");
//                            return;
//                          }
//
//                          if(postToTime == null){
//                            Config().displaySnackBar("Select End Time", "");
//                            return;
//                          }
//
//
//
//                          challengeParams["event_date"] = selectedDate;
//                          challengeParams["start_time"] = postFromTime;
//                          challengeParams["end_time"] = postToTime;
//
//
//                          createChallenge();
//                        },
//                      )),
//                ),
//
//              ],
//            ),
//          ),
//          Visibility(
//            visible: isLoading,
//            child: Container(
//              width: Get.width,
//              height: Get.height,
//              color: Colors.white.withOpacity(0.4),
//              child: Center(child: LoadingWidget()),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//
//  void openCupertinoTimePicker(String type) {
//    showModalBottomSheet(
//      context: context,
//      builder: (context) {
//        return TimePickerWidget(
//          selectionListener: (value) {
//            Get.back();
//            if (value == null) {
//              return;
//            }
//
//            if (type == "from") {
//              fromTime = format(value);
//              postFromTime = format(value);
//
//              setState(() {});
//            } else {
//              toTime = format(value);
//              postToTime = format(value);
//
//              setState(() {});
//            }
//
//            FocusScope.of(context).unfocus();
//
//          },
//        );
//      },
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.only(
//          topLeft: Radius.circular(15),
//          topRight: Radius.circular(15),
//        ),
//      ),
//    );
//  }
//
//  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
//
//  void createChallenge(){
//    setState(() {
//      isLoading = true;
//    });
//    challengeParams["event_type"] = "offline";
//    challengeParams["type"] = "challenge";
//    HomeRepo().createChallenge(challengeParams).then((value){
//      setState(() {
//        isLoading = false;
//      });
//      if(value.status){
//        eventId = value.eventId.toString();
//        widget.pageChangeListener("");
//        Config().displaySnackBar(value.message, "");
//      }else{
//        Config().displaySnackBar(value.message, "");
//      }
//    });
//
//  }
//
//}

class ChallengeInviteScreen extends StatefulWidget {
  final ValueChanged<String> pageChangeListener;
  final ValueChanged<String> backListener;
  final bool fromDetailPage;

  const ChallengeInviteScreen({Key key, this.pageChangeListener, this.backListener, this.fromDetailPage}) : super(key: key);

  @override
  _ChallengeInviteScreenState createState() => _ChallengeInviteScreenState();
}

class _ChallengeInviteScreenState extends State<ChallengeInviteScreen> {
  ContactModel contactModel;
  List<PostContactModel> localContactList = [];
  bool inviteLoading = false;
  List<int> selectedUserInvitation = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllContactList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: !widget.fromDetailPage ? Colors.transparent : Colors.white,
      appBar: widget.fromDetailPage?
          AppBar(
              title:  Text('Invite',
                 style: TextStyle(
                  color: Colors.white,
                   letterSpacing: 1.0,
                     fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w600
                                    ),
                                    ),
            backgroundColor: Colors.green,
          )
          :
      PreferredSize(child: Container(), preferredSize: Size(0,0)),
      body: Container(
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(widget.fromDetailPage ? 0:20),topRight: Radius.circular(widget.fromDetailPage ? 0:20),)
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: widget.fromDetailPage ? false :true,
                    child: Text(
                      Strings.invite_friends,
                      style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ),
                  contactModel != null && contactModel.data != null
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            return Container(
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44.0,
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      color: Colors.grey[200],
                                    ),
                                    child: ClipRRect(
                                      child: Image.network(
                                        contactModel.data[i].profileImage ?? '',
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(22)),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                        child: Text(
                                          contactModel.data[i].name,
                                          style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      )),


                                  GestureDetector(
                                    onTap: (){
                                      if(contactModel.data[i].isSelected){
                                        contactModel.data[i].isSelected = false;
                                        selectedUserInvitation.remove(contactModel.data[i].userId);
                                      }else{
                                        contactModel.data[i].isSelected = true;
                                        selectedUserInvitation.add(contactModel.data[i].userId);
                                      }
                                      setState(() {
                                      });
                                    },
                                    child: Container(
                                      width: 26,
                                                        height: 26,
                                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(13)),
                                                          border: Border.all(color: Colors.grey[400],width: 2),
                                                        ),
                                      child:   Visibility(
                                        visible: contactModel.data[i].isSelected,
                                        child: Container(
                                          width: 26,
                                          height: 26,
                                          margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(13)),
                                            color: Colors.green
                                          ),
                                        ),
                                      ),
                                                      ),
                                  )

                                ],
                              ),
                            );
                          },
                          itemCount: contactModel.data.length,
                        )
                      : LoadingWidget()
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                width: double.infinity,
                child: DefaultButton(
                  text: "INVITE",
                  press: () {
                    if (selectedUserInvitation.isNotEmpty) {
                      sendEventInvite();
                    } else {
                      Config().displaySnackBar("Select user", "");
                    }
                  },
                ),
              ),
            ),
            Visibility(
              visible: inviteLoading,
              child: Container(
                width: Get.width,
                height: Get.height,
                color: Colors.white.withOpacity(0.4),
                child: Center(child: LoadingWidget()),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _buildDynamicLink(String number) async {
    setState(() {
      inviteLoading = true;
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://connnect.page.link',
      link: Uri.parse('https://connect.joistic.com?'),
      androidParameters: AndroidParameters(
        packageName: 'com.connect.app',
      ),
      iosParameters: IosParameters(
        bundleId: 'com.connect.app',
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable,
      ),
    );

//    final Uri dynamicUrl = await parameters.buildShortLink();
    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri dynamicUrl = shortDynamicLink.shortUrl;

    print('Dynamiclink: $dynamicUrl');

//   inviteUserViaWhatsApp(number,"Download Connect App - ${dynamicUrl}");
    openShareOption("Download Connect App - ${dynamicUrl}");
//    Share.share('check out my website $dynamicUrl');
  }

  void openShareOption(String content) {
    setState(() {
      inviteLoading = false;
    });
    Share.share(content);
  }

  void sendEventInvite() {
    setState(() {
      inviteLoading = true;
    });
    Map<String, dynamic> params = {"user_id": selectedUserInvitation};
    HomeRepo().sendEventInvite(eventId, params).then((value) {
      setState(() {
        inviteLoading = false;
      });
      widget.backListener("");
      Config().displaySnackBar(value?.message, "");

    });
  }

  void getAllContactList() async {
    Iterable<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);
    for (Contact contact in contacts) {
      if (contact.displayName != null && contact.phones.length > 0) {
        String phoneNumber = contact.phones.toList()[0].value.replaceAll(" ", "");
        if(!phoneNumber.contains("+91")){
          phoneNumber = "+91" + phoneNumber;
        }
        localContactList.add(PostContactModel(phone: phoneNumber, name: contact.displayName));
      }
    }
    postContact();
  }

  void postContact() {
//    if(localContactList.length > 100){
//      localContactList = localContactList.sublist(0,100);
//    }
    Map<String, dynamic> params = {"contacts": jsonEncode(localContactList)};

    HomeRepo().postContact(params).then((value) {
      if (value != null && value.status) {
        getContactList();
      }
    });
  }

  void getContactList() {
    Map<String, String> params = {
    };
      params["event_id"] = eventId;
    HomeRepo().getContactList(params).then((value) {
      if (value != null && value.data != null) {
        setState(() {
          contactModel = value;
        });
      }
    });
  }
}

Map<String, String> challengeParams = {};

String eventId;
