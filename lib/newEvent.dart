import 'dart:convert';

import 'package:c0nnect/HomeScreen.dart';
import 'package:c0nnect/components/default_button.dart';
import 'package:c0nnect/helper/config.dart';
import 'package:c0nnect/helper/strings.dart';
import 'package:c0nnect/model/category_model.dart';
import 'package:c0nnect/model/event_details_model.dart';
import 'package:c0nnect/repository/home_repo.dart';
import 'package:c0nnect/repository/login_repo.dart';
import 'package:c0nnect/widget/LocationPickerWidget.dart';
import 'package:c0nnect/widget/TimePickerWidget.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:share/share.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'model/post_contact_model.dart';
import 'package:c0nnect/model/contact_model.dart';
import 'widget/LoadingWidget.dart';
import 'widget/ChallengeTopContainer.dart';
//import 'package:google_maps_webservice/places.dart';
import 'package:get/get.dart';
import 'globals.dart'as global;


class NewEvent extends StatefulWidget {

  final EventDetailsModel eventDetailsModel;
  final ValueChanged<String> closeCurrentPage;

  const NewEvent({Key key, this.eventDetailsModel, this.closeCurrentPage}) : super(key: key);

  @override
  _NewEventState createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {

  final List<String> emojis = <String>['🏈', '🎉', '🌹', '🍾', '🎂', '🍿'];
  final List<String> emojisImageList = [];
  final List<String> tags = [
    '📌 American Football',
    '🏀 Basketball ',
    '⚽️ European Football',
    "🎾 Tennis",
    "🏒 Hockey"
  ];

  PageController pageController = PageController();


  String selectedCategory;
  String selectedCategoryId;
  String selectedCategoryName;
  String selectedSubCategory;
  List<int> selectedSubCategoryList = [];
  String selectedEmoji;
  CategoryModel categoryModel;
  List<Subcategories> subcategoriesList = [];
  CalendarController _controller;
  List<PostContactModel> localContactList = [];
  String selectedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  DateTime initialDateTime = DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
  ContactModel contactModel;
  String selectedLocation = Strings.location;
  String eventCreateLoading = Strings.continueString;
  String lat,long;
//  GoogleMapsPlaces _places = GoogleMapsPlaces(
//      apiKey: Strings.GOOGLE_PLACES_API_KEY);
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventDescController = TextEditingController();
  TextEditingController onlineEventLink = TextEditingController();
  String fromTime,toTime;
//  String postFromTime,postToTime;
  TimeOfDay _initialTime = TimeOfDay.now().replacing(minute: 30);
  bool iosStyle = true;
  int createdEventId;
  bool inviteLoading = false;
  bool initialCategoryLoaded = false;
  bool isOnlineEvent = false;

  var isStartAmSelected = false.obs;
  var isEndAmSelected = false.obs;

  List<int> selectedUserInvitation = [];

  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();


    getCategory();
//    requestForContactPermission();

    if(widget.eventDetailsModel != null){

      eventNameController.text = widget.eventDetailsModel.data.title;
      eventDescController.text = widget.eventDetailsModel.data.description;

      lat = widget.eventDetailsModel.data.latitude;
      long = widget.eventDetailsModel.data.longitude;

      initialDateTime = DateTime.parse(widget.eventDetailsModel.data.eventDateFormat);
      selectedDate = DateFormat("yyyy-MM-dd").format(initialDateTime);

      fromTime = widget.eventDetailsModel.data.startTimeFormat;
      startTimeController.text = widget.eventDetailsModel.data.startTimeFormat;

      toTime = widget.eventDetailsModel.data.endTimeFormat;
      endTimeController.text = widget.eventDetailsModel.data.endTimeFormat;

      selectedSubCategory = widget.eventDetailsModel.data.subCategory;

    }


  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }



//  void onTimeChanged(TimeOfDay newTime) {
//    setState(() {
//      _time = newTime;
//    });
//  }
//
//  void onEndTimeChanged(TimeOfDay newTime) {
//    setState(() {
//      _timeEnd = newTime;
//    });
//  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:  Colors.black.withOpacity(0.7),
      body: Stack(
        children: [
          InkWell(
            onTap: (){
              if(widget.closeCurrentPage != null){
                widget.closeCurrentPage("");
              }else{
                Get.back();
              }
            },
            child:

            Align(
              alignment: Alignment.topRight,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: Icon(Icons.cancel,size: 38,color:Colors.white),
                          onPressed: (){

                            if(widget.closeCurrentPage != null){
                              widget.closeCurrentPage("");
                            }else{
                              Get.back();
                            }

                            return;

                            if(pageController.page.toInt() + 1 == 5){
                              if(widget.closeCurrentPage != null){
                                widget.closeCurrentPage("");
                              }else{
                                Get.back();
                              }
                              return;
                            }

                            if(pageController.page.toInt() + 1 > 1){
//                            if(pageController.page.toInt() + 1 == 4){
//                              if(isOnlineEvent){
//                                pageController.jumpToPage(2);
//                              }
//                            }
                              pageController.previousPage(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeIn);

                            }else{
                              if(widget.closeCurrentPage != null){
                                widget.closeCurrentPage("");
                              }else{
                                Get.back();
                              }
                            }
                          }),
//                    Text(
//                      "New Event",
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 20,
//                          fontWeight: FontWeight.bold),
//                    ),
                    ],
                  ),
                ),
              ),
            ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(60),topLeft: Radius.circular(60))
              ),
              height: MediaQuery.of(context).size.height * 0.85,
              alignment: Alignment.bottomCenter,
              child: PageView(
                controller: pageController,
                onPageChanged: (index){

                },
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(
                    child: Container(
                      height: Get.height,
                      child: Column(
                          children: [
                            ChallengeTopContainer(),

                            Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Let's start \nwith the basics!",
                                  style: TextStyle(color: mainColor, fontSize: 30),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30, left: 40.0, right: 40),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.green, width: 3)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Container(
                                        width: 75,
                                        height: 75,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://cdn.dribbble.com/users/1593845/screenshots/12080942/media/d109daedaf5d0c4881e39da475af701d.gif"),
                                                fit: BoxFit.cover)),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                      child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                        "Choose an emoji that best describes your event below."),
                                  ))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              height: 15,
                              width: 0.3,
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: 10,
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
                                      selectedEmoji = e.icon;
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
                                      for(int i=0;i<subcategoriesList.length;i++){
                                        subcategoriesList[i].isSelected = false;
                                      }

                                      if (e.isSelected) {
                                        setState(() {
                                          e.isSelected = false;
                                          selectedSubCategoryList.remove(e.id);
                                        });
                                      } else {
                                        setState(() {
                                          e.isSelected = true;
                                          selectedSubCategoryList.add(e.id);
                                        });
                                      }
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

//                        if (categoryModel != null && categoryModel.data != null)
//                          Expanded(
//                            child: Center(
//                              child: ScrollSnapList(
//                                onItemFocus: (index) {
//                                  categoryChangeListener(index);
//                                },
//                                itemSize: 70,
//                                initialIndex: widget.eventDetailsModel != null ? getSelectedCategoryIndex() : 0,
//                                itemBuilder: (BuildContext context, int index) {
//                                  return Padding(
//                                      padding: const EdgeInsets.only(
//                                          left: 10.0, right: 10),
//                                      child: Container(
//                                          height: 60,
//                                          width: 60,
//                                          child: Image.network(categoryModel.data[index].icon)));
//                                },
//                                itemCount: categoryModel.data.length,
//                                dynamicItemSize: true,
//                                duration: 700,
//                                reverse: false,
//                              ),
//                            ),
//                          ),
//                        if (subcategoriesList != null &&
//                            subcategoriesList.length > 0)
//                          Container(
//                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                            child: Wrap(
//                              children: subcategoriesList.map((e) {
//                                return InkWell(
//                                  onTap: () {
//
//                                    for(int i=0;i<subcategoriesList.length;i++){
//                                      subcategoriesList[i].isSelected = false;
//                                    }
//
//                                    if (e.isSelected) {
//                                      setState(() {
//                                        e.isSelected = false;
//                                        selectedSubCategoryList.remove(e.id);
//                                      });
//                                    } else {
//                                      setState(() {
//                                        e.isSelected = true;
//                                        selectedSubCategoryList.add(e.id);
//                                      });
//                                    }
//                                  },
//                                  child: Container(
//                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
//                                    decoration: BoxDecoration(
//                                        color: e.isSelected
//                                            ? Colors.green.withOpacity(0.4)
//                                            : Colors.grey.withOpacity(0.1),
//                                        borderRadius: BorderRadius.all(
//                                            Radius.circular(22))),
//                                    child: Padding(
//                                      padding:
//                                          EdgeInsets.fromLTRB(30, 10, 30, 10),
//                                      child: Text(
//                                        e.name,
//                                        style: TextStyle(fontSize: 12),
//                                      ),
//                                    ),
//                                  ),
//                                );
//                              }).toList(),
//                            ),
//                          ),
//

//                            Expanded(child: SizedBox()),
                            SizedBox(height: 50,),

                            selectedSubCategoryList.length > 0 ?

                            Padding(
                              padding: const EdgeInsets.only(left: 40, right: 40),
                              child: Container(
                                  width: double.infinity,
                                  child: DefaultButton(
                                    text: "Continue",
                                    press: () {
                                      FocusScope.of(context).unfocus();

                                      if(selectedSubCategoryList.length <=0){
                                        global.showToast(Strings.selectCategory);
                                        return;
                                      }
                                      pageController.animateToPage(
                                          pageController.page.toInt() + 1,
                                          duration: Duration(milliseconds: 400),
                                          curve: Curves.easeIn);
                                    },
                                  )),
                            )
                            :
                                Container(),
                            SizedBox(
                              height: 50,
                            )
                          ]),
                    ),
                  ),

                  SingleChildScrollView(
                    child: Column(
                      children: [

                        ChallengeTopContainer(),
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "What is your\nevent about?",
                              style: TextStyle(color: mainColor, fontSize: 30),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.network(
                                selectedEmoji ?? '',
                                width: 35,
                                height: 35,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Flexible(
                                  child: Text(
                                'You chose ${selectedCategoryName ?? ""} as best fitting',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40.0, 20, 40, 0),
                          child: TextFormField(
                            controller: eventNameController,
                            onEditingComplete: (){
                            },
                            decoration: InputDecoration(
                                labelText: 'Name your Event',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat', //First Name
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: TextField(
                            controller: eventDescController,
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
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green))),
                          ),
                        ),


                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 40, right: 40),
                              child: Container(
                                  width: double.infinity,
                                  child: DefaultButton(
                                    text: "Continue",
                                    press: () {

                                      if(eventNameController.text.length <= 0){
                                        global.showToast(Strings.enterEventName);
                                        return;
                                      }

                                      if(eventDescController.text.length <= 0){
                                        global.showToast(Strings.enterEventDesc);
                                        return;
                                      }

//                                      if(isOnlineEvent){
//                                        if(onlineEventLink.text.length <= 0){
//                                          global.showToast(Strings.enterEventLink);
//                                          return;
//                                        }
//                                      }

                                      FocusScope.of(context).unfocus();

//                                      if(isOnlineEvent){
////                                        pageController.nextPage(duration: Duration(milliseconds: 300),curve: Curves.easeIn);
//                                        pageController.jumpToPage(pageController.page.toInt()+2);
//                                      }else{
                                        pageController.nextPage(duration: Duration(milliseconds: 300),curve: Curves.easeIn);
//                                      }
                                    },
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Map screen
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ChallengeTopContainer(),

                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Select Location",
                              style: TextStyle(color: mainColor, fontSize: 30),
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: SwitchListTile(
                            title: const Text('ONLINE EVENT'),
                            value: isOnlineEvent,
                            onChanged: (bool value) {
                              setState(() {
                                isOnlineEvent = value;
                              });
                            },
                          ),
                        ),

                        isOnlineEvent ?

                        Padding(
                          padding: const EdgeInsets.fromLTRB(40.0, 20, 40, 0),
                          child: TextFormField(
                            controller: onlineEventLink,
                            decoration: InputDecoration(
                                labelText: 'Online event link',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat', //First Name
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green))),
                          ),
                        )

                        :

                        LocationPickerWidget(continueListener: (valueBack){
                          selectedLocation = valueBack['address'];
                          lat=  valueBack['lat'];
                          long= valueBack['lng'];
                         pageController.nextPage(duration: Duration(milliseconds: 300),curve: Curves.easeIn);

                        },),


                        Visibility(
                          visible: isOnlineEvent,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                            padding: const EdgeInsets.only(left: 40, right: 40),
                            child: Container(
                                width: double.infinity,
                                child: DefaultButton(
                                  text: "Continue",
                                  press: () {
                                    FocusScope.of(context).unfocus();

                                    if(onlineEventLink.text.length <= 0){
                                          global.showToast(Strings.enterEventLink);
                                          return;
                                        }
                                    pageController.animateToPage(
                                        pageController.page.toInt() + 1,
                                        duration: Duration(milliseconds: 400),
                                        curve: Curves.easeIn);
                                  },
                                )),
                          ),
                        ),


                      ],
                    ),
                  ),


                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ChallengeTopContainer(),

                        Padding(
                          padding: EdgeInsets.fromLTRB(40, 20, 40, 30),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "When does\nyour event occure?",
                              style: TextStyle(color: mainColor, fontSize: 30),
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: TableCalendar(
                              startingDayOfWeek: StartingDayOfWeek.monday,
                              calendarController: _controller,
                              initialSelectedDay: initialDateTime,
                              onDaySelected: (day, events, holidays) {
                                selectedDate = day.toString().substring(0, 10);
                              },
                              calendarStyle: CalendarStyle(
                                selectedColor: Colors.green[400],
                                todayColor: Colors.green[200],
                                markersColor: Colors.brown[700],
                                outsideDaysVisible: false,
                              ),
                              headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                              ),
                            )),

                        Padding(
                          padding: const EdgeInsets.only(left: 40, right: 40,top: 0,bottom: 30),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Start Time ',
                                  style: TextStyle(color: Colors.black,
                                      fontSize: 16, fontWeight: FontWeight.w400),
                                ),
                              ),

                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    height: 50,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius:  BorderRadius.circular(10),
                                    ),
                                    child: TextField(
                                      controller: startTimeController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                                        hintText: '',
                                        counterText: "",
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      ),
                                      maxLength: 5,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                                      onChanged: (val){

                                        if(startTimeController.text.length >= 3){
                                          if(!startTimeController.text.contains(":")){
                                            String temp = startTimeController.text;


                                            if(int.parse(temp.substring(0,2)) > 12){
                                              temp = "0${temp.substring(1,2)}:${temp.substring(2,startTimeController.text.length)}";
                                            }else{
                                              temp = '${temp.substring(0,2)}:${temp.substring(2,startTimeController.text.length)}';
                                            }

                                            startTimeController.text = temp;
                                            startTimeController.selection = TextSelection.fromPosition(TextPosition(offset: startTimeController.text.length));
                                          }
                                       }else{
                                        }
                                      },
                                    ),
                                  ),

                                 Container(
                                   height: 50,
                                                     margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                     padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                                     decoration: BoxDecoration(
                                                       borderRadius: BorderRadius.all(Radius.circular(10)),
                                                       color: Colors.grey[200]
                                                     ),
                                   child: Obx(()=>Row(
                                     mainAxisSize: MainAxisSize.min,
                                     children: [
                                       InkWell(
                                         onTap: (){
                                           isStartAmSelected.value = true;
                                         },
                                         child: Container(
                                           width: 50,
                                           height: 40,
                                           margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                           padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                           decoration: BoxDecoration(
                                               borderRadius: BorderRadius.all(Radius.circular(10)),
                                               color: isStartAmSelected.value ? Colors.white : Colors.grey[200]
                                           ),
                                           child:  Center(
                                             child: Text('AM',
                                               style: TextStyle(
                                                   color: Colors.black,
                                                   fontFamily: 'Roboto',
                                                   fontSize: 14,
                                                   fontWeight: FontWeight.w600
                                               ),
                                             ),
                                           ),
                                         ),
                                       ),
                                       InkWell(
                                         onTap: (){
                                           isStartAmSelected.value = false;

                                         },
                                         child: Container(
                                           width: 50,
                                           height: 40,
                                           margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                           padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                           decoration: BoxDecoration(
                                               borderRadius: BorderRadius.all(Radius.circular(10)),
                                               color: !isStartAmSelected.value ? Colors.white : Colors.grey[200]
                                           ),
                                           child:  Center(
                                             child: Text('PM',
                                               style: TextStyle(
                                                   color: Colors.black,
                                                   fontFamily: 'Roboto',
                                                   fontSize: 14,
                                                   fontWeight: FontWeight.w600
                                               ),
                                             ),
                                           ),
                                         ),
                                       ),
                                     ],
                                   )),
                                                   ),

                                ],
                              )

                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40, right: 40,top: 0,bottom: 30),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'End Time ',
                                  style: TextStyle(color: Colors.black,
                                      fontSize: 16, fontWeight: FontWeight.w400),
                                ),
                              ),

                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    height: 50,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius:  BorderRadius.circular(10),
                                    ),
                                    child: TextField(
                                      controller: endTimeController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                                        hintText: '',
                                        counterText: "",
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      ),
                                      maxLength: 5,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                                      onChanged: (val){
                                        if(endTimeController.text.length >= 3){
                                          if(!endTimeController.text.contains(":")){
                                            String temp = endTimeController.text;

                                            if(int.parse(temp.substring(0,2)) > 12){
                                              temp = "0${temp.substring(1,2)}:${temp.substring(2,endTimeController.text.length)}";
                                            }else{
                                              temp = '${temp.substring(0,2)}:${temp.substring(2,endTimeController.text.length)}';
                                            }

                                            endTimeController.text = temp;
                                            endTimeController.selection = TextSelection.fromPosition(TextPosition(offset: endTimeController.text.length));
                                          }
                                       }else{
                                        }
                                      },
                                    ),
                                  ),

                                 Container(
                                   height: 50,
                                                     margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                     padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                                     decoration: BoxDecoration(
                                                       borderRadius: BorderRadius.all(Radius.circular(10)),
                                                       color: Colors.grey[200]
                                                     ),
                                   child: Obx(()=>Row(
                                     mainAxisSize: MainAxisSize.min,
                                     children: [
                                       InkWell(
                                         onTap: (){
                                           isEndAmSelected.value = true;
                                         },
                                         child: Container(
                                           width: 50,
                                           height: 40,
                                           margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                           padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                           decoration: BoxDecoration(
                                               borderRadius: BorderRadius.all(Radius.circular(10)),
                                               color: isEndAmSelected.value ? Colors.white : Colors.grey[200]
                                           ),
                                           child:  Center(
                                             child: Text('AM',
                                               style: TextStyle(
                                                   color: Colors.black,
                                                   fontFamily: 'Roboto',
                                                   fontSize: 14,
                                                   fontWeight: FontWeight.w600
                                               ),
                                             ),
                                           ),
                                         ),
                                       ),
                                       InkWell(
                                         onTap: (){
                                           isEndAmSelected.value = false;

                                         },
                                         child: Container(
                                           width: 50,
                                           height: 40,
                                           margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                           padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                           decoration: BoxDecoration(
                                               borderRadius: BorderRadius.all(Radius.circular(10)),
                                               color: !isEndAmSelected.value ? Colors.white : Colors.grey[200]
                                           ),
                                           child:  Center(
                                             child: Text('PM',
                                               style: TextStyle(
                                                   color: Colors.black,
                                                   fontFamily: 'Roboto',
                                                   fontSize: 14,
                                                   fontWeight: FontWeight.w600
                                               ),
                                             ),
                                           ),
                                         ),
                                       ),
                                     ],
                                   )),
                                                   ),

                                ],
                              )

                            ],
                          ),
                        ),

//                        InkWell(
//                          onTap: ()async{
////                            timePicker("from");
//                            openCupertinoTimePicker("from");
//
////                            Navigator.of(context).push(
////                              showPicker(
////                                context: context,
////                                value: _initialTime,
////                                onChange: onTimeChanged,
////                                is24HrFormat: true,
////                                accentColor: Colors.green,
////                                cancelText: "Cancel",
////                                okText: "Confirm",
////                                borderRadius: 30,
////                                barrierDismissible: false,
////                                iosStylePicker: false,
////                              ),
////                            );
//                          },
//                          child: Container(
//                            margin: EdgeInsets.fromLTRB(40, 20, 40, 20),
//                            child: Column(
//                              mainAxisSize: MainAxisSize.min,
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: [
//                                Text(
//                                  Strings.startTime,
//                                  style: TextStyle(
//                                      color: Colors.grey,
//                                      letterSpacing: 1.0,
//                                      fontSize: 12,
//                                      fontWeight: FontWeight.w800),
//                                ),
//                                SizedBox(height: 10,),
//                                Text(
//                                 fromTime == null ? Strings.selectStartTime : fromTime,
//                                  style: TextStyle(
//                                      color: Colors.grey,
//                                      letterSpacing: 1.0,
//                                      fontSize: 18,
//                                      fontWeight: FontWeight.w800),
//                                ),
//                                Container(
//                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
//                                  width: MediaQuery.of(context).size.width,
//                                  height: 1,
//                                  color: Colors.grey,
//                                )
//                              ],
//                            ),
//                          ),
//                        ),
//
//                        InkWell(
//                          onTap: ()async{
////                            Navigator.of(context).push(
////                              showPicker(
////                                context: context,
////                                value: _initialTime,
////                                onChange: onEndTimeChanged,
////                                is24HrFormat: true,
////                                accentColor: Colors.green,
////                                cancelText: "Cancel",
////                                okText: "Confirm",
////                                borderRadius: 30,
////                                barrierDismissible: false,
////                                iosStylePicker: false,
////                              ),
////                            );
////                          timePicker("to");
//                            openCupertinoTimePicker("to");
//
//                          },
//                          child: Container(
//                            margin: EdgeInsets.fromLTRB(40, 20, 40, 20),
//                            child: Column(
//                              mainAxisSize: MainAxisSize.min,
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: [
//                                Text(
//                                  Strings.endTime,
//                                  style: TextStyle(
//                                      color: Colors.grey,
//                                      letterSpacing: 1.0,
//                                      fontSize: 12,
//                                      fontWeight: FontWeight.w800),
//                                ),
//                                SizedBox(height: 10,),
//                                Text(
//                                  toTime == null ? Strings.selectEndTime : toTime,
//                                  style: TextStyle(
//                                      color: Colors.grey,
//                                      letterSpacing: 1.0,
//                                      fontSize: 18,
//                                      fontWeight: FontWeight.w800),
//                                ),
//                                Container(
//                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
//                                  width: MediaQuery.of(context).size.width,
//                                  height: 1,
//                                  color: Colors.grey,
//                                )
//                              ],
//                            ),
//                          ),
//                        ),


                        Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          width: double.infinity,
                          child: DefaultButton(
                            text: eventCreateLoading,
                            press: () {
                              if(startTimeController.text.length != 5){
                                global.showToast(Strings.selectStartTime);
                                return;
                              }
                              if(endTimeController.text.length != 5){
                                global.showToast(Strings.selectEndTime);
                                return;
                              }

                              if(int.parse(startTimeController.text.split(":")[0]) > 12){
                                global.showToast("Start time format is not valid");
                                return;
                              }
                              if(int.parse(startTimeController.text.split(":")[1]) > 60){
                                global.showToast("Start time format is not valid");
                                return;
                              }

                              if(int.parse(endTimeController.text.split(":")[0]) > 12){
                                global.showToast("End time format is not valid");
                                return;
                              }
                              if(int.parse(endTimeController.text.split(":")[1]) > 60){
                                global.showToast("End time format is not valid");
                                return;
                              }

                              FocusScope.of(context).unfocus();

                              if(widget.eventDetailsModel != null){
                                createEvent("update");
                              }else{
                                createEvent("create");
                              }

                            },
                          ),
                        )
                      ],
                    ),
                  ),

                  Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              Strings.invite_friends,
                              style: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: 1.0,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            ),
                            contactModel != null && contactModel.data != null
                                ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, i) {
                                return Container(
                                  padding:
                                  EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44.0,
                                        margin:
                                        EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(22),
                                          color: Colors.grey[200],
                                        ),
                                        child: ClipRRect(
                                          child: Image.network(
                                            contactModel
                                                .data[i].profileImage ??
                                                '',
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(22)),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 4,
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                            child: Text(
                                              contactModel.data[i].name,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  letterSpacing: 1.0,
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.w500),
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
                          padding: EdgeInsets.fromLTRB(20, 10, 20,10),
                          width: double.infinity,
                          child: DefaultButton(
                            text: "INVITE SELECTED USER",
                            press: () {
                            if(selectedUserInvitation.isNotEmpty){
                              sendEventInvite();
                            }else{
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
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void deSelectAllCategory() {
    for (int i = 0; i < categoryModel.data.length; i++) {
      categoryModel.data[i].isSelected = false;
    }
  }

  void getCategory() {
    Map<String,String> params = {

    };
    LoginRepo().getCategoryData(params).then((value) {
      if (value != null && value.data != null && value.data.length > 0) {
        setState(() {
          categoryModel = value;
//          subcategoriesList.addAll(categoryModel.data[0].subcategories);
          selectedEmoji = categoryModel.data[0].icon;
          selectedCategoryId = categoryModel.data[0].id.toString();
          selectedCategoryName = categoryModel.data[0].name;
        });
      }
    });
  }

  void requestForContactPermission() async {
    if (await Permission.contacts.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      getAllContactList();
//    List<Contact> testList = await compute(getAllContactList,"Get Contact");
//    print(testList.length);
    }
  }

  void getAllContactList() async {
    Iterable<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);
    for (Contact contact in contacts) {
      if (contact.displayName != null && contact.phones.length > 0) {
        String phoneNumber = contact.phones.toList()[0].value.replaceAll(" ", "");
        if(!phoneNumber.contains("+91")){
          phoneNumber = "+91" + phoneNumber;
        }
        localContactList.add(
            PostContactModel(phone: phoneNumber, name: contact.displayName));
      }
    }
    postContact();
  }

  void postContact() {
//    if(localContactList.length > 100){
//      localContactList = localContactList.sublist(0,100);
//    }
    Map<String, dynamic> params = {
      "contacts": jsonEncode(localContactList),
    };

    HomeRepo().postContact(params).then((value) {
      if (value != null && value.status) {
        getContactList();
      }
    });
  }

  void getContactList() {
    Map<String, String> params = {
      "event_id" : createdEventId.toString(),
    };
    HomeRepo().getContactList(params).then((value) {
      if (value != null && value.data != null) {
        setState(() {
          contactModel = value;
        });
      }
    });
  }

  void createEvent(String type) {

    Map<String, String> params = {
      "name": eventNameController.text,
      "description": eventDescController.text,
//      "category_id": selectedCategoryId,
      "category_id": selectedSubCategoryList[0].toString(),
      "event_date": selectedDate,
      "start_time": '${startTimeController.text} ${isStartAmSelected.value ? "am" :"pm"}',
      "end_time": '${endTimeController.text} ${isEndAmSelected.value ? "am" :"pm"}',
//      "address": '',
//      "latitude": lat,
//      "longitude": long,
      "public": '1',
      "status": '1',
      "event_type": isOnlineEvent ? "online" : "offline",
    };

    if(isOnlineEvent){
      params["event_link"] = onlineEventLink.text;

    }else{
      params["address"] = selectedLocation;
      params["latitude"] = lat;
      params["longitude"] = long;
    }

    params["type"] = "event";


    setState(() {
      eventCreateLoading = Strings.pleaseWait;
    });


    if(type == "create"){
      HomeRepo().createEvent(params).then((value) {

        if(value != null && value.status){

          Config().displaySnackBar(value.message, "");
          createdEventId = value.eventId;
          setState(() {
            eventCreateLoading = Strings.continueString;
          });

          requestForContactPermission();

          pageController.animateToPage(
              pageController.page.toInt() + 1,
              duration: Duration(milliseconds: 400),
              curve: Curves.easeIn);

        }else{
          setState(() {
            eventCreateLoading = Strings.continueString;
          });
          Config().displaySnackBar(value.message, "");
        }

      });
    }else{
      HomeRepo().updateEvent(params,widget.eventDetailsModel.data.id.toString()).then((value) {

        if(value != null && value.status){

          Config().displaySnackBar(value.message, "");
          createdEventId = value.eventId;
          setState(() {
            eventCreateLoading = Strings.continueString;
          });

          requestForContactPermission();


          pageController.animateToPage(
              pageController.page.toInt() + 1,
              duration: Duration(milliseconds: 400),
              curve: Curves.easeIn);

        }else{
          setState(() {
            eventCreateLoading = Strings.continueString;
          });
          Config().displaySnackBar(value.message, "");
        }

      });
    }







  }

  void sendEventInvite(){
    setState(() {
      inviteLoading = true;
    });
    Map<String,dynamic> params = {
      "user_id" : selectedUserInvitation
    };
    HomeRepo().sendEventInvite(createdEventId.toString(),params).then((value) {
      Config().displaySnackBar(value?.message, "");
      setState(() {
        inviteLoading = false;
      });
      Get.offNamedUntil("/controller", (route) => false);

    });
  }

  void timePicker(String type) async{
    TimeOfDay selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Get.theme.primaryColor,
            accentColor: Get.theme.accentColor,
            colorScheme: ColorScheme.light(primary: Get.theme.primaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );


    //Converting TimeOfDay into DateTime
    DateTime currentTime = DateTime.now();
    DateTime dateTime = DateTime(currentTime.year, currentTime.month, currentTime.day, selectedTime.hour, selectedTime.minute);
    print("Check formatte time -- ${DateFormat('hh:mm').format(dateTime)}");


    String dayPeriod = selectedTime.period == DayPeriod.am ? "AM" : "PM";

    if(type == "from"){


      fromTime = "${DateFormat('hh:mm').format(dateTime)} ${dayPeriod} ";
//      postFromTime = "${selectedTime.hour}:${selectedTime.minute}";

      setState(() {

      });



    }
    else{


      toTime = "${DateFormat('hh:mm').format(dateTime)} ${dayPeriod}";
//      postToTime = "${selectedTime.hour}:${selectedTime.minute}";


      setState(() {

      });
    }


  }

  void openCupertinoTimePicker(String type){
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return TimePickerWidget(selectionListener: (value){
          Get.back();
          if(value == null){
            return;
          }
          print("Checking time --- ${value.inMinutes}");

          if(type == "from"){

            fromTime =   format(value);
//            postFromTime = format(value);

            setState(() {

            });

          }else{

            toTime =  format(value);
//            postToTime = format(value);

            setState(() {

            });
          }

        },);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
    );
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  void categoryChangeListener(int index){
    setState(() {
      selectedCategoryId = categoryModel.data[index].id.toString();
      selectedCategoryName = categoryModel.data[index].name;
      selectedSubCategoryList.clear();
      subcategoriesList.clear();

      //Remove previous selected category
      for(int i = 0;i<categoryModel.data[index].subcategories.length;i++){
        categoryModel.data[index].subcategories[i].isSelected = false;
      }

      subcategoriesList.addAll(categoryModel.data[index].subcategories);
      selectedEmoji = categoryModel.data[index].icon;
    });
  }


  double getSelectedCategoryIndex(){
    for(int i=0;i<categoryModel.data.length;i++){
      if(categoryModel.data[i].name == widget.eventDetailsModel.data.category){
        if(!initialCategoryLoaded){
          categoryChangeListener(i);
            if(selectedSubCategory != null){
              for(int i=0;i<subcategoriesList.length;i++){
                if(subcategoriesList[i].name == selectedSubCategory){
                  subcategoriesList[i].isSelected = true;
                  selectedSubCategoryList.add(subcategoriesList[i].id);
                }
              }
            }

        }
        initialCategoryLoaded = true;
        return i.toDouble();
      }
    }
    return 0;
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

  void openShareOption(String content){
    setState(() {
      inviteLoading = false;
    });
    Share.share(content);

  }





}
