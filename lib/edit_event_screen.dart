import 'package:c0nnect/repository/home_repo.dart';
import 'package:c0nnect/widget/EditEventFieldWidget.dart';
import 'package:c0nnect/widget/LocationPickerWidget.dart';
import 'package:c0nnect/widget/TimePickerWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'components/default_button.dart';
import 'helper/config.dart';
import 'helper/strings.dart';
import 'model/event_details_model.dart';

class EditEventScreen extends StatefulWidget {

  final EventDetailsModel eventDetailsModel;
  final bool isChallenge;

  const EditEventScreen({Key key, this.eventDetailsModel, this.isChallenge}) : super(key: key);


  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventDescController = TextEditingController();
  TextEditingController onlineEventLinkController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  bool isOnlineEvent = false;
  DateTime selectedDate;
  String selectedDateStr;
//  String postFromTime,postToTime;
  DateTime initialDateTime = DateTime.now();
  String lat,long;

  String eventCreateLoading = Strings.continueString;
  String selectedSubCategory;

  var isStartAmSelected = false.obs;
  var isEndAmSelected = false.obs;

  @override
  void initState() {
    super.initState();

    eventNameController.text= widget.eventDetailsModel.data.title;
    eventDescController.text= widget.eventDetailsModel.data.description;



    initialDateTime = DateTime.parse(widget.eventDetailsModel.data.eventDateFormat);
    selectedDateStr = DateFormat("yyyy-MM-dd").format(initialDateTime);
    dateController.text = selectedDateStr;

    startTimeController.text = widget.eventDetailsModel.data.startTime?.split(" ")[0];
    isStartAmSelected.value = widget.eventDetailsModel.data.startTime?.split(" ")[1].toLowerCase() == "am" ? true : false;
//    postFromTime = widget.eventDetailsModel.data.startTimeFormat;

    endTimeController.text = widget.eventDetailsModel.data.endTime?.split(" ")[0];
    isEndAmSelected.value = widget.eventDetailsModel.data.endTime?.split(" ")[1].toLowerCase() == "am" ? true : false;
//    postToTime = widget.eventDetailsModel.data.endTimeFormat;

    selectedSubCategory = widget.eventDetailsModel.data.categoryId.toString();

    if(widget.eventDetailsModel.data.eventType == "online"){
      isOnlineEvent = true;
      onlineEventLinkController.text = widget.eventDetailsModel.data.eventLink;
    }else{
      isOnlineEvent = false;
      if(widget.eventDetailsModel.data.address != null){
        locationController.text= widget.eventDetailsModel.data.address;
        lat = widget.eventDetailsModel.data.latitude;
        long = widget.eventDetailsModel.data.longitude;
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        Get.back();
                      },
                        child: Icon(Icons.arrow_back_ios,color: Colors.black,size: 22,)
                    ),
                    SizedBox(width: 10,),

                    Text(
                      widget.isChallenge?'Edit Challenge':'Edit Event',
                      style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 26, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                EditEventFieldWidget(
                  controller: eventNameController,
                  label: "Event Name",
                  minLine: 1,
                  maxLine: 1,
                ),
                EditEventFieldWidget(
                  controller: eventDescController,
                  label: "Event Description",
                  minLine: 3,
                  maxLine: 4,
                ),
//                SizedBox(height: 20,),
                Visibility(
                  visible:  widget.isChallenge?false:true,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Text(
                      'Location Details',
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Visibility(
                  visible:  widget.isChallenge?false:true,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
                    child: CheckboxListTile(
                      title: Text("ONLINE EVENT"),
                      value: isOnlineEvent,
                      onChanged: (newValue) {
                        setState(() {
                          isOnlineEvent = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                    ),
                  ),
                ),
                isOnlineEvent
                    ? EditEventFieldWidget(
                        controller: onlineEventLinkController,
                        label: "Event Link",
                        minLine: 1,
                        maxLine: 1,
                      )
                    :


                Visibility(
                  visible:  widget.isChallenge?false:true,
                  child: InkWell(
                    onTap: (){
                      Get.dialog( Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                      onTap: (){
                                        Get.back();
                                      },
                                      child: Icon(Icons.cancel, size: 40, color: Colors.white,)),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: Colors.grey[300]
                                ),
                                child: LocationPickerWidget(continueListener: (valueBack){
                                  locationController.text = valueBack['address'];
                                  lat=  valueBack['lat'];
                                  long= valueBack['lng'];
                                  Get.back();
                                },),
                              ),
                            ],
                          )
                        ),
                      ),);
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: EditEventFieldWidget(
                              controller: locationController,
                              label: "Event Location",
                              minLine: 1,
                              maxLine: 2,
                            ),
                    ),
                  ),
                ),



                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    'Event Date and Time Details',
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),

                InkWell(
                  onTap: (){
                    selectDate(context);
                  },
                  child: AbsorbPointer(
                    absorbing: true,
                    child: EditEventFieldWidget(
                      controller: dateController,
                      label: "Event Date",
                      minLine: 1,
                      maxLine: 1,
                    ),
                  ),
                ),

               Visibility(
                 visible: !widget.isChallenge,
                 child: Column(
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(left: 15, right: 15,top: 0,bottom: 30),
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
                                         temp = '${temp.substring(0,2)}:${temp.substring(2,startTimeController.text.length)}';
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
                       padding: const EdgeInsets.only(left: 15, right: 15,top: 0,bottom: 30),
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
                                         temp = '${temp.substring(0,2)}:${temp.substring(2,endTimeController.text.length)}';
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
                   ],
                 ),
               ),

                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                        child: Container(
                            width: double.infinity,
                            child: DefaultButton(
                              text: "Cancel Event",
                              press: () {
                                Config().showAlertDialog(
                                    context: context,
                                    content: "Are you sure you want to cancel this event?",
                                    actionText: "Continue",
                                    title: "CANCEL EVENT",
                                    action: ()async{
                                      Get.back();
                                      cancelEvent();
                                    }
                                );
                              },
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                        child: Container(
                            width: double.infinity,
                            child: DefaultButton(
                              text: eventCreateLoading,
                              press: () {
                                FocusScope.of(context).unfocus();
                                updateEvent();
                              },
                            )),
                      ),
                    ),

                  ],
                )


              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectDate(BuildContext context)async{
    selectedDate  = await
    showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: initialDateTime,
      lastDate: initialDateTime.add(Duration(days: 360)),
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

    selectedDateStr = DateFormat("yyyy-MM-dd").format(selectedDate);

    setState(() {
      dateController.text = Strings.formatDateNew(selectedDateStr);
    });

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

          if(type == "from"){

            startTimeController.text =   format(value);
//            postFromTime = format(value);

            setState(() {
              FocusScope.of(context).unfocus();
            });

          }else{

            endTimeController.text =  format(value);
//            postToTime = format(value);

            setState(() {
              FocusScope.of(context).unfocus();
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


  void updateEvent(){

    Map<String, String> params = {
      "name": eventNameController.text,
      "description": eventDescController.text,
      "category_id": selectedSubCategory,
//      "category_id": selectedSubCategoryList[0].toString(),
      "event_date": selectedDateStr,
      "start_time": '${startTimeController.text} ${isStartAmSelected.value ? "am" :"pm"}',
      "end_time": '${endTimeController.text} ${isEndAmSelected.value ? "am" :"pm"}',
      "type": widget.isChallenge?'challenge':'event',
      "public": '1',
      "status": '1',
      "event_type": isOnlineEvent ? "online" : "offline",
    };

    if(!isOnlineEvent){
      params["address"] = locationController.text;
      params["latitude"] = lat;
      params["longitude"] = long;

    }else{
      params["event_link"] = onlineEventLinkController.text;
    }

    setState(() {
      eventCreateLoading = Strings.pleaseWait;
    });

    HomeRepo().updateEvent(params,widget.eventDetailsModel.data.id.toString()).then((value) {

      if(value != null && value.status){

        Get.back();
        Config().displaySnackBar(value.message, "");

      }
      else{
        setState(() {
          eventCreateLoading = Strings.continueString;
        });
        Config().displaySnackBar(value.message, "");
      }

    });
  }

  void openGoogleMap()async{
    LocationResult result = await showLocationPicker(
      context, Strings.GOOGLE_PLACES_API_KEY,
      initialCenter: lat != null ? LatLng(double.parse(lat), double.parse(long)) : LatLng(37.7749295, -122.4194155),
      myLocationButtonEnabled: true,
      layersButtonEnabled: true,
    );

    setState(() {
      locationController.text = result.address;
      lat = result.latLng.latitude.toString();
      long = result.latLng.longitude.toString();
    });
  }

  void cancelEvent(){

    HomeRepo().cancelEvent(widget.eventDetailsModel.data.id.toString()).then((value){
      if(value.status){
        Get.back();
      }else{

      }
      Config().displaySnackBar(value.message, "");
    });

  }

}
