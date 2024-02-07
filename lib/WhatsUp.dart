import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui';

import 'package:c0nnect/challenge_details_screen.dart';
import 'package:c0nnect/components/cards.dart';
import 'package:c0nnect/components/constants.dart';
import 'package:c0nnect/model/notification_submit_model.dart' as notiSubmitModel;
import 'package:c0nnect/components/icon_btn_with_counter.dart';
import 'package:c0nnect/helper/shared_prefs.dart';
import 'package:c0nnect/helper/strings.dart';
import 'package:c0nnect/model/events_model.dart';
import 'package:c0nnect/newEvent.dart';
import 'package:c0nnect/profile.dart';
import 'package:c0nnect/repository/home_repo.dart';
import 'package:c0nnect/widget/LoadingWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

import 'components/default_button.dart';
import 'event_details_screen.dart';
import 'helper/config.dart';
import 'model/friend_request_model.dart';
import 'model/map_model.dart';
import 'model/option_selection_model.dart';

class MapScreen extends StatefulWidget {

  final ValueChanged<String> openCreateEvent;

  const MapScreen({Key key, this.openCreateEvent}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with AutomaticKeepAliveClientMixin<MapScreen> {
  int activeMenu = 0;
  List menu = ["Upcoming", "Invitations", "timeline"];

  bool isUpcomingSelected = true;
  bool isInvitationSelected = false;
  bool isTimelineSelected = false;

  EventsModel upcomingEventModel;
  EventsModel timelineModel;
  EventsModel invitationModel;

  FriendRequestModel friendRequestModel;

  List<MapData> mapEventList = [];

  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = Map<MarkerId, Marker>().obs;
  LocationData _position;
  bool _serviceEnabled;
  Location location = new Location();
  PermissionStatus _permissionGranted;
  double initialLat, initialLng;

  List<OptionSelectionModel> privacySettingDataList = [];


  @override
  void initState() {
    super.initState();

    print(UserPreferences().get(UserPreferences.SHARED_USER_TOKEN));

    getUpcomingEventData();
    getTimelineData();
    getInvitationData();
    getFriendInvitation();
    getPrivacySetting();

//    getLocation();
    
    Future.delayed(Duration(milliseconds: 1000),()async{
      _serviceEnabled = await location.serviceEnabled();
      print("Checking permission status ---- ${_serviceEnabled}");
      if(!_serviceEnabled){
        locationPermissionDialog();
      }else{
        getLocation();
      }
    });


  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: ()async{
        getUpcomingEventData();
        getTimelineData();
        getInvitationData();
        getFriendInvitation();
        getLocation();

      },
      child: Scaffold(
          backgroundColor: Colors.green,
          body: Stack(
            children: [
              CustomScrollView(
                // controller: _scrollViewController,

                slivers: [
                  SliverAppBar(
                    shadowColor: Colors.transparent,
                    onStretchTrigger: () {
                      HapticFeedback.heavyImpact();
                      return;
                    },
                    expandedHeight: 150.0,
                    floating: false,
                    pinned: true,
                    snap: false,
                    stretch: true,
                    backgroundColor: Colors.green.withOpacity(.9),
                    leading: Row(
                      children: [
//                      SizedBox(
//                        width: 15,
//                      ),
//                      IconBtnWithCounter(
//                        svgSrc: "assets/icons/Bell.svg",
//                        press: () => HapticFeedback.heavyImpact(),
//                        numOfitem: 9,
//                      ),
                      ],
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: false,
                      title: Text(
                        'your events',
                        style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w200),
                      ),
                      background: Container(color: Colors.green),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 10, 15, 10),
                        child: RaisedButton.icon(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
//                            Get.to(NewEvent());
                          widget.openCreateEvent("");
                          },
                          icon: Icon(Icons.add),
                          color: Colors.grey.shade100,
                          label: Text(
                            "add event",
                            style: TextStyle(color: Colors.black),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(0),
                            ),
                            color: kBackgroundColor,
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(menu.length, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          filterSelection(menu[index]);
                                          activeMenu = index;
                                          HapticFeedback.mediumImpact();
                                        });
                                      },
                                      child: activeMenu == index
                                          ? ElasticIn(
                                              child: Container(
                                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(30)),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        menu[index],
                                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(30)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      menu[index],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                    );
                                  }),
                                ),
                              ),

                              //Invitation
                              Visibility(
                                visible: isInvitationSelected,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "new invitations",
                                                style: TextStyle(color: primaryTextColor),
                                              ),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                color: kBackgroundColor,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 1,
                                            width: double.infinity,
                                            color: Colors.grey.withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                    invitationModel != null && invitationModel.data != null
                                        ? invitationModel.data.length > 0
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, i) {
                                                  return Padding(
                                                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                                    child: GestureDetector(
                                                      onTap: () {

                                                        if(invitationModel.data[i].type.toLowerCase() == "event"){
                                                          Get.to(EventDetailsScreen(
                                                            eventId: invitationModel.data[i].id.toString(),
                                                          ));
                                                        }else if(invitationModel.data[i].type.toLowerCase() == "challenge"){
                                                          Get.to(ChallengeDetailsScreen(
                                                            eventId: invitationModel.data[i].id.toString(),
                                                          ));
                                                        }

                                                      },
                                                      child: EventNotification(
                                                        time: invitationModel.data[i].startTime,
                                                        day: invitationModel.data[i].day,
                                                        title: invitationModel.data[i].title,
                                                        desc: invitationModel.data[i].description,
                                                        profile: invitationModel.data[i].creator.profileImage,
                                                        actionListener: (value) {
                                                          if (value == "accept") {
                                                            acceptInvitation(invitationModel.data[i].id.toString());
                                                          } else if (value == "decline") {
                                                            rejectInvitation(invitationModel.data[i].id.toString());
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                                itemCount: invitationModel.data.length,
                                              )
                                            : Container(
                                                width: Get.width,
                                                height: 50,
                                                child: Center(
                                                  child: Text(
                                                    Strings.noInvitation,
                                                    style: TextStyle(color: Colors.grey[400], letterSpacing: 1.0, fontSize: 18, fontWeight: FontWeight.w600),
                                                  ),
                                                ),
                                              )
                                        : LoadingWidget(),

                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Friend request",
                                                style: TextStyle(color: primaryTextColor),
                                              ),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                color: kBackgroundColor,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 1,
                                            width: double.infinity,
                                            color: Colors.grey.withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                    ),

                                    friendRequestModel != null && friendRequestModel.data != null
                                        ? friendRequestModel.data.length > 0
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, i) {
                                                  return Padding(
                                                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        HapticFeedback.mediumImpact();

                                                      },
                                                      child: FriendRequestWidget(
                                                        time: friendRequestModel.data[i].createdAt,
                                                        title: friendRequestModel.data[i].user.name,
                                                        profile: friendRequestModel.data[i].user.profileImage,
                                                        actionListener: (value) {
                                                          if (value == "accept") {
                                                            acceptRejectFriendRequest(friendRequestModel.data[i].id.toString(),"accepted");
                                                          } else if (value == "decline") {
                                                            acceptRejectFriendRequest(friendRequestModel.data[i].id.toString(),"rejected");
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                                itemCount: friendRequestModel.data.length,
                                              )
                                            : Container(
                                      width: Get.width,
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          Strings.noFriendRequest,
                                          style: TextStyle(color: Colors.grey[400], letterSpacing: 1.0, fontSize: 18, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    )
                                        : LoadingWidget(),


                                  ],
                                ),
                              ),

                              //Upcoming
                              Visibility(
                                visible: isUpcomingSelected,
                                child: Column(
                                  children: [
                                    upcomingEventModel != null && upcomingEventModel.data != null
                                        ? upcomingEventModel.data.length > 0
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, i) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      if(upcomingEventModel.data[i].type.toLowerCase() == "event"){
                                                        Get.to(EventDetailsScreen(
                                                          eventId: upcomingEventModel.data[i].id.toString(),
                                                        ));
                                                      }else if(upcomingEventModel.data[i].type.toLowerCase() == "challenge"){
                                                        Get.to(ChallengeDetailsScreen(
                                                          eventId: upcomingEventModel.data[i].id.toString(),
                                                        ));
                                                      }

                                                    },
                                                    child: BuildEventCard(
                                                      time: upcomingEventModel.data[i].day ?? "",
                                                      amORpm: upcomingEventModel.data[i].startTime ?? "",
                                                      duration: upcomingEventModel.data[i].duration ?? "",
                                                      header: upcomingEventModel.data[i].title ?? "",
                                                      subtitle: upcomingEventModel.data[i].description ?? "",
                                                      avatarOfPerson: upcomingEventModel.data[i].creator.profileImage ?? "",
                                                      person: upcomingEventModel.data[i].creator.name ?? "",
                                                      location: upcomingEventModel.data[i].address ?? "",
                                                      exactLocation: "",
                                                      type: upcomingEventModel.data[i].type ?? "",
                                                    ),
                                                  );
                                                },
                                                itemCount: upcomingEventModel.data.length,
                                              )
                                            : Container(
                                                width: Get.width,
                                                height: Get.height,
                                                child: Align(
                                                  alignment: Alignment.topCenter,
                                                  child: Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                                                    child:
                                                    Text( Strings.noUpcomingEvents,
                                                      style: TextStyle(
                                                          color: Colors.grey[300],
                                                          letterSpacing: 1.0,
                                                          fontFamily: 'Roboto',
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                        : LoadingWidget(),
                                  ],
                                ),
                              ),

                              //timeline
                              Visibility(
                                visible: isTimelineSelected,
                                child: Column(
                                  children: [
                                    timelineModel != null && timelineModel.data != null
                                        ? timelineModel.data.length > 0
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, i) {
                                                  return GestureDetector(
                                                    onTap: (){

                                                      if(timelineModel.data[i].type.toLowerCase() == "event"){
                                                        Get.to(EventDetailsScreen(
                                                          eventId: timelineModel.data[i].id.toString(),
                                                        ));
                                                      }else{
                                                        Get.to(ChallengeDetailsScreen(
                                                          eventId: timelineModel.data[i].id.toString(),
                                                        ));
                                                      }

                                                    },
                                                    child: BuildEventCard(
                                                      time: timelineModel.data[i].day,
                                                      amORpm: timelineModel.data[i].startTime,
                                                      duration: timelineModel.data[i].duration ?? "",
                                                      header: timelineModel.data[i].title,
                                                      subtitle: timelineModel.data[i].description,
                                                      avatarOfPerson: timelineModel.data[i].creator.profileImage,
                                                      person: timelineModel.data[i].creator.name,
                                                      location: timelineModel.data[i].address ?? "",
                                                      exactLocation: "",
                                                    ),
                                                  );
                                                },
                                                itemCount: timelineModel.data.length,
                                              )
                                            : Container(
                                                width: Get.width,
                                                height: Get.height,
                                                child: Align(
                                                  alignment: Alignment.topCenter,
                                                  child: Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                                                    child: Text(
                                                      Strings.noData,
                                                      style: TextStyle(color: Colors.grey[400], letterSpacing: 1.0, fontSize: 20, fontWeight: FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                              )
                                        : LoadingWidget()
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: Get.height / 2,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              DraggableScrollableSheet(
                  maxChildSize: 0.8,
                  minChildSize: 0.25,
                  initialChildSize: 0.25,
                  builder: (context, scrollableController) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      controller: scrollableController,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                        child: Container(
                            height: height * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(60),
                              ),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Stack(
                                children: <Widget>[
                                  initialLat != null
                                      ? Positioned.fill(
                                          child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Container(
                                            width: Get.width,
                                            margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
                                            child: GoogleMap(
                                                zoomControlsEnabled: true,
                                                initialCameraPosition: CameraPosition(target: LatLng(initialLat, initialLng), zoom: 15),
                                                myLocationEnabled: true,
                                                tiltGesturesEnabled: true,
                                                compassEnabled: true,
                                                scrollGesturesEnabled: true,
                                                myLocationButtonEnabled: true,
                                                zoomGesturesEnabled: true,

                                                onMapCreated: onMapCreated,
                                                markers: Set<Marker>.of(markers.values),
                                                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                                                  new Factory<OneSequenceGestureRecognizer>(
                                                    () => new EagerGestureRecognizer(),
                                                  ),
                                                ].toSet()),
                                          ),
                                        ))
                                      : Container(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: ResponsiveContainer(
                                        widthPercent: 12.0,
                                        heightPercent: 0.6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30.0),
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        InkWell(
                                            onTap: (){
//                                              locationPermissionDialog();
                                            },
                                            child: Text("Whats up ", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30.0))),
                                     Row(
                                       children: [
                                         InkWell(
                                           onTap: (){
                                             _showPrivacySettingSheet();
                                           },
                                             child: Image.asset("assets/images/ghost.png",width: 30,height: 30,)),

                                         SizedBox(width: 20,),

                                         Icon(
                                           Icons.arrow_upward,
                                           color: Colors.black,
                                           size: 30.0,
                                         ),

                                       ],
                                     )
                                      ],
                                    ),
                                  ),
                                  mapEventList != null && mapEventList.length > 0
                                      ? Positioned(
                                          bottom: 120,
                                          child: Container(
                                            width: Get.width,
                                            constraints: BoxConstraints(minHeight: 80, maxHeight: 100),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, i) {
                                                return InkWell(
                                                  onTap: (){
                                                    if(mapEventList[i].latitude != null){
                                                      var newPosition = LatLng(double.parse(mapEventList[i].latitude), double.parse(mapEventList[i].longitude));
                                                      CameraPosition newCameraPosition =
                                                      CameraPosition(target: newPosition, zoom: 15);
                                                      mapController.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                    padding: EdgeInsets.fromLTRB(10, 10, 25, 10),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), color: Colors.white),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          width: 60,
                                                          height: 60,
                                                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(10),
                                                            child: Image.network(
                                                              mapEventList[i].image ?? "",
                                                              width: 60,
                                                              height: 60,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 12,
                                                        ),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              mapEventList[i].name,
                                                              style: TextStyle(color: Colors.black,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w400),
                                                            ),
                                                            SizedBox(height: 5,),

                                                            Visibility(
                                                              visible: mapEventList[i].date != null ? true : false,
                                                              child: Text(
                                                                "Date : ${mapEventList[i].date != null ? Strings.formatDateNew(mapEventList[i].date) : ""}",
                                                                style: TextStyle(color: Colors.grey[400],
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w400),
                                                              ),
                                                            ),

                                                            InkWell(
                                                              onTap: (){
                                                                openMap(double.parse(mapEventList[i].latitude),double.parse(mapEventList[i].longitude));
                                                              },
                                                              child: Container(
                                                                width: 80,
                                                                                  margin: EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                                                                    color: Colors.green
                                                                                  ),
                                                                child:  Center(
                                                                  child: Text('Navigate',
                                                                         style: TextStyle(
                                                                          color: Colors.white,
                                                                           letterSpacing: 1.0,
                                                                             fontFamily: 'Roboto',
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w600
                                                                                            ),
                                                                                            ),
                                                                ),
                                                                                ),
                                                            ),

                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              itemCount: mapEventList.length,
                                            ),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            )),
                      ),
                    );
                  }),
            ],
          )),
    );
  }

  Widget event(String image, String name, String doing) {
    return AspectRatio(
      aspectRatio: 1.7 / 2,
      child: Container(
        margin: EdgeInsets.only(right: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 70,
                  height: 60,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              name,
              style: TextStyle(color: Colors.grey[800], fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              doing,
              style: TextStyle(color: Colors.grey[300], fontSize: 15),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.grey[200]),
                    child: Text(
                      '6PM',
                      style: TextStyle(color: Colors.grey[500]),
                    )),
                _iconBuilder(Icons.check_circle),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget friend(String image, String name, String doing) {
    return AspectRatio(
      aspectRatio: 1.7 / 2,
      child: Container(
        margin: EdgeInsets.only(right: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 70,
                  height: 60,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              name,
              style: TextStyle(color: Colors.grey[800], fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              doing,
              style: TextStyle(color: Colors.grey[300], fontSize: 15),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _iconBuilder(Icons.phone),
                _iconBuilder(Icons.chat),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget bunchOfGuys(String image, String name, String secondImage, String secondName, String doing) {
    return AspectRatio(
      aspectRatio: 1.7 / 2,
      child: Container(
        margin: EdgeInsets.only(right: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), image: DecorationImage(image: AssetImage(secondImage), fit: BoxFit.cover)),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              name,
              style: TextStyle(color: Colors.grey[800], fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              secondName,
              style: TextStyle(color: Colors.grey[800], fontSize: 13, fontWeight: FontWeight.bold),
            ),
            Text(
              doing,
              style: TextStyle(color: Colors.grey[300], fontSize: 15),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _iconBuilder(Icons.phone),
                  _iconBuilder(Icons.chat_bubble_outline),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Column _iconBuilder(icon) {
    return Column(
      children: <Widget>[
        Icon(
          icon,
          size: 28,
          color: Colors.black,
        ),
      ],
    );
  }

  void filterSelection(String type) {
    if (type.toLowerCase() == "upcoming") {
      isUpcomingSelected = true;
      isTimelineSelected = false;
      isInvitationSelected = false;
    }

    if (type.toLowerCase().contains("invitations")) {
      isUpcomingSelected = false;
      isTimelineSelected = false;
      isInvitationSelected = true;
    }

    if (type.toLowerCase() == "timeline") {
      isUpcomingSelected = false;
      isTimelineSelected = true;
      isInvitationSelected = false;
    }

    setState(() {});
  }

  void getUpcomingEventData() {
    Map<String, String> params = {"type": "upcoming"};
    HomeRepo().getEventsList(params).then((value) {
      if (value != null && value.data != null) {
        setState(() {
          upcomingEventModel = value;
        });
      }
    });
  }

  void getTimelineData() {
    Map<String, String> params = {"type": "timeline"};
    HomeRepo().getEventsList(params).then((value) {
      if (value != null && value.data != null) {
        setState(() {
          timelineModel = value;
        });
      }
    });
  }

  void getInvitationData() {
    Map<String, String> params = {"type": "invitations"};
    HomeRepo().getEventsList(params).then((value) {
      if (value != null && value.data != null) {
        setState(() {
          invitationModel = value;

          menu[1] = "Invitations (${invitationModel.data.length})";
        });
      }
    });
  }

  void getFriendInvitation() {
    HomeRepo().getFriendRequest().then((value) {
      if (value != null && value.data != null) {
        setState(() {
          friendRequestModel = value;
        });
      }
    });
  }

  void acceptInvitation(String eventId) {
    HomeRepo().acceptInvitation(eventId).then((value) {
      Config().displaySnackBar(value?.message, "");
      if (value != null && value.status) {
        getInvitationData();
      }
    });
  }

  void rejectInvitation(String eventId) {
    Map<String, String> params = {"type": "reject"};
    HomeRepo().rejectInvitation(eventId, params).then((value) {
      Config().displaySnackBar(value?.message, "");
      if (value != null && value.status) {
        getInvitationData();
      }
    });
  }

  void acceptRejectFriendRequest(String requestId,String type){
    showLoader();
    Map<String, String> params = {"acknowledge": type};
    HomeRepo().acceptRejectFriendRequest(requestId, params).then((value) {
      Get.back();
      Config().displaySnackBar(value?.message, "");
      if (value != null && value.status) {
        getFriendInvitation();
      }
    });
  }

  void showLoader(){
    Future.delayed(
        Duration.zero,
            () => Get.dialog(
            Container(
              width: Get.width,
              height: Get.width,
              color: Colors.white.withOpacity(0.3),
              child: Center(
                  child: LoadingWidget()),
            ),
            barrierDismissible: false));
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive {
    return true;
  }

  //Map Functins
  void onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  void getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }else{
      }
    }


    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }else{
    }

    print("Check User location init");

    _position = await location.getLocation();

    print("Check User location ${_position.latitude} : ${_position.longitude}");

    setState(() {
      initialLat = _position.latitude;
      initialLng = _position.longitude;
    });

    getMapData();


    Map<String,String> params = {
      "lat" : _position.latitude.toString(),
      "long" : _position.longitude.toString(),
    };
    HomeRepo().updateUserLocation(params).then((value) {

    });

//    populatingMarker();
  }


  void getMapData(){

    HomeRepo().getMapData().then((value){
      if(value.data != null){
        mapEventList.addAll(value.data);
        populatingMarker();
      }
    });

  }


  void populatingMarker() async {
    for (int i = 0; i < mapEventList.length; i++) {
      final http.Response response = await http.get(mapEventList[i].image);
//      BitmapDescriptor markerImage = BitmapDescriptor.fromBytes(response.bodyBytes);

      //New code
      final Codec markerImageCodec = await instantiateImageCodec(
        response.bodyBytes,
        targetWidth: 140,
      );
      final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
      final ByteData byteData = await frameInfo.image.toByteData(
        format: ImageByteFormat.png,
      );
      final Uint8List resizedMarkerImageBytes = byteData.buffer.asUint8List();
      BitmapDescriptor markerImage = BitmapDescriptor.fromBytes(resizedMarkerImageBytes);

//      final Uint8List markerIcond = await getBytesFromCanvas(80, 98, upcomingEventModel.data[i].creator.profileImage);
//      BitmapDescriptor markerImage = BitmapDescriptor.fromBytes(markerIcond);

      VoidCallback callBack = (){
        if(mapEventList[i].type == "user"){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Profile(
                userId: mapEventList[i].id.toString(),
//                roomId: friendsModel.data[i].chatId,
              )));
        }else if(mapEventList[i].type == "event"){
          Get.to(EventDetailsScreen(
            eventId: mapEventList[i].id.toString(),
          ));
        }else if(mapEventList[i].type == "challenge"){
          Get.to(ChallengeDetailsScreen(
            eventId: mapEventList[i].id.toString(),
          ));
        }


      };

      InfoWindow infoWindow = new InfoWindow(title: mapEventList[i].name,onTap: callBack);

      if (mapEventList[i].latitude != null) {
        addMarker(LatLng(double.parse(mapEventList[i].latitude), double.parse(mapEventList[i].longitude)), markerImage, mapEventList[i].name, infoWindow);
      }
    }

    setState(() {});
  }


  addMarker(LatLng position, BitmapDescriptor descriptor, String label, InfoWindow infoWindow) {
    MarkerId markerId = MarkerId(label);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position, infoWindow: infoWindow);

    markers[markerId] = marker;
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Future<Uint8List> getBytesFromCanvas(int width, int height, urlAsset) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.transparent;
    final Radius radius = Radius.circular(20.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);

//    final ByteData datai = await rootBundle.load(urlAsset);
    http.Response datai = await http.get(urlAsset);

    var imaged = await loadImage(new Uint8List.view(datai.bodyBytes.buffer));

    canvas.drawImage(imaged, new Offset(0, 0), new Paint());

    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data.buffer.asUint8List();
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  void getPrivacySetting(){

    Map<String,String> params = {
      "type" : "privacy"
    };
    HomeRepo().getNotificationSetting(params).then((value){
      for(int i=0;i<value.data.length;i++){
        OptionSelectionModel optionSelectionModel = OptionSelectionModel();
        optionSelectionModel.name = value.data[i].name;
        optionSelectionModel.iconData = Icons.notifications;
        optionSelectionModel.id = value.data[i].key;
        optionSelectionModel.selected.value = value.data[i].value == "1" ? true : false;
        privacySettingDataList.add(optionSelectionModel);
      }
    });

  }

  void submitPrivacyNotification(){

    List<notiSubmitModel.Data> submitList = [];

    for(int i=0;i<privacySettingDataList.length;i++){
      submitList.add(notiSubmitModel.Data(value: privacySettingDataList[i].selected.value ? "1" : "0",
          key: privacySettingDataList[i].id));
    }


    Map<String,dynamic> params = {
      "type" : "privacy",
      "settings" : submitList.map((v) => v.toJson()).toList()
    };

    HomeRepo().notificationSetting(params).then((value){
      if(value.status){
        Get.back();
      }
      Config().displaySnackBar(value.message, "");
    });

  }

  void _showPrivacySettingSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(65.0))),
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0, left: 5),
                            child: Text(
                              "Privacy",
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context,i){
                              return Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: FlatButton(
                                  padding: EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  color: Color(0xFFF5F6F9),
                                  onPressed: () {
                                    HapticFeedback.mediumImpact();
                                    setState(() {
                                      privacySettingDataList[i].selected.value = !privacySettingDataList[i].selected.value;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        privacySettingDataList[i].iconData,
                                        color: Colors.green.shade300,
                                        size: 22.0,
                                        semanticLabel: 'Text to announce in accessibility modes',
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(child: Text(privacySettingDataList[i].name)),

                                      Obx(()=>  Switch(
                                          value: privacySettingDataList[i].selected.value,
                                          onChanged: (value){
                                            setState(() {
                                              privacySettingDataList[i].selected.value = value;
                                            });
                                          }
                                      ))

                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: privacySettingDataList.length,
                          ),

                          Container(
                            padding: const EdgeInsets.only(left: 40, right: 40),
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            width: Get.width,
                            child: DefaultButton(
                              text: "SUBMIT",
                              press: () {
                                submitPrivacyNotification();
                              },
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }



  void locationPermissionDialog(){
    Get.dialog(
      Scaffold(
        backgroundColor: Colors.black.withOpacity(0.4),

        body: Stack(
          children: [
            InkWell(
              onTap:(){
                Get.back();
      },
              child: Container(
                width: Get.width,
                height: Get.height,
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Text('Allow your location',
                      style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 1.0,
                          fontFamily: 'Roboto',
                          fontSize: 22,
                          fontWeight: FontWeight.w600
                      ),
                    ),

                    SizedBox(height: 10,),

                    Image.asset("assets/images/map.png"),

                    SizedBox(height: 20,),

                    Text('If you enable Location Service, we can show you nearby events and friends',
                      style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 1.0,
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w400
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        width: double.infinity,
                        child: DefaultButton(
                          text: "ENABLE LOCATION",
                          press: () async {
                            Get.back();
                            getLocation();
                          },
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

}
