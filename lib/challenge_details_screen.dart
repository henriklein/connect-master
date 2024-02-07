import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:c0nnect/create_challenge_screen.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:c0nnect/helper/shared_prefs.dart';
import 'package:c0nnect/model/event_details_model.dart';
import 'package:c0nnect/model/participant_model.dart';
import 'package:c0nnect/newEvent.dart';
import 'package:c0nnect/profile.dart';
import 'package:c0nnect/repository/home_repo.dart';
import 'package:c0nnect/widget/CarouselImageWidget.dart';
import 'package:c0nnect/widget/LoadingWidget.dart';
import 'package:c0nnect/widget/MediaSelectionBSWidget.dart';
import 'package:c0nnect/widget/ParticipantBSWidget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_compress/video_compress.dart';
import 'ChatSystem.dart';
import 'edit_event_screen.dart';
import 'helper/config.dart';
import 'helper/strings.dart';
import 'memories_slide_show_screen.dart';
import 'model/chat_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:video_thumbnail/video_thumbnail.dart';

class ChallengeDetailsScreen extends StatefulWidget {
  final String eventId;

  const ChallengeDetailsScreen({Key key, this.eventId}) : super(key: key);

  @override
  _ChallengeDetailsScreenState createState() => _ChallengeDetailsScreenState();
}

class _ChallengeDetailsScreenState extends State<ChallengeDetailsScreen> {
  EventDetailsModel eventDetailsModel;
  ParticipantModel participantModel;

  var currentCarouselIndex = 0.obs;

  CarouselController carouselController = CarouselController();
  List<String> eventImageList = [];
  List<Asset> multiImageList = <Asset>[];
  List<String> selectedImageList = [];

  CameraPosition _kGooglePlex;
  List<Marker> _markers = [];
  Completer<GoogleMapController> _controller = Completer();
  bool isLoading = false;
  double userImageCardWidth = 0;
  List<Invited_users> invitedUserImageList = [];
  int endTime = DateTime.now().millisecondsSinceEpoch + 10000 * 30;

  @override
  void initState() {
    super.initState();
    getEventDetails();
    getEventParticipant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: eventDetailsModel != null
              ? Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      size: 25,
                                      color: Colors.black,
                                    )),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Visibility(
                                      visible: UserPreferences().get(UserPreferences.SHARED_USER_ID) == eventDetailsModel.data.creator.id.toString() ? true : false,
                                      child: InkWell(
                                        onTap: () {
//                              Get.to(NewEvent(
//                                eventDetailsModel: eventDetailsModel,
//                              ));
                                          Get.to(EditEventScreen(
                                            eventDetailsModel: eventDetailsModel,
                                            isChallenge : true,
                                          )).then((value) {
                                            invitedUserImageList.clear();
                                            getEventDetails();
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                          child: Text(
                                            Strings.eventEdit,
                                            style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 16, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        eventId = eventDetailsModel.data.id.toString();
                                        Get.to(ChallengeInviteScreen(
                                          backListener: (_) {
                                            Get.back();
                                          },
                                          fromDetailPage: true,
                                        ));
                                      },
                                      child: Text(
                                        Strings.invite,
                                        style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          CarouselSlider(
                            carouselController: carouselController,
                            items: eventImageList.map((media) {
                              return CarouselImageWidget(
                                topLeft: 10,
                                topRight: 10,
                                bottomLeft: 10,
                                bottomRight: 10,
                                media: media,
                              );
                            }).toList(),
                            options: CarouselOptions(
                                autoPlay: false,
                                aspectRatio: 2.0,
                                height: 260,
                                enlargeCenterPage: false,
                                enableInfiniteScroll: false,
                                viewportFraction: 1.0,
                                onPageChanged: (index, reason) {
                                  currentCarouselIndex.value = index;
                                }),
                          ),

                          //Timer Container
                          Container(
                            width: Get.width,
                            padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Time Remaining : ',
                                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                CountdownTimer(
                                  endTime:  eventDetailsModel.data.countDown,
                                  widgetBuilder: (_, CurrentRemainingTime time) {
                                    if (time == null) {
                                      return Container(
                                        child: Text('Challenge Closed',
                                             style: TextStyle(
                                              color: Colors.black,
                                               letterSpacing: 1.0,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      );
                                    }
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.green),
                                          child: Text(
                                            '${ time.hours != null && time.hours < 10 ? '0${time?.hours}' : time?.hours ?? "00"}',
                                            style: TextStyle(color: Colors.white, letterSpacing: 1.0, fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.green),
                                          child: Text(
                                            '${ time.min != null && time.min < 10 ? '0${time?.min}' : time?.min ?? "00"}',
                                            style: TextStyle(color: Colors.white, letterSpacing: 1.0, fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.green),
                                          child: Text(
                                            '${ time.sec != null && time.sec < 10 ? '0${time?.sec}' : time?.sec ?? "00"}',
                                            style: TextStyle(color: Colors.white, letterSpacing: 1.0, fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.w600),
                                          ),
                                        ),

                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          //Event basic details card
                          Container(
                            width: Get.width,
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Text(
                                        eventDetailsModel.data.title ?? "",
                                        style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 26,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),

                                    SizedBox(width: 10,),

                                    eventDetailsModel.data.eventStatus == "cancelled" ?

                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          color: Colors.red[500]
                                      ),
                                      child:  Text('CANCELED',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Roboto',
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    )
                                        :
                                    Container()

                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.green[50]),
                                        child: Icon(
                                          Icons.calendar_today,
                                          size: 25,
                                          color: Colors.green[700],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            eventDetailsModel.data.eventDate,
                                            style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 16, fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '${eventDetailsModel.data.startTime} - ${eventDetailsModel.data.endTime}',
                                            style: TextStyle(color: Colors.grey[500], letterSpacing: 1.0, fontSize: 14, fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.green[50]),
                                        child: Icon(
                                          Icons.confirmation_num,
                                          size: 25,
                                          color: Colors.green[700],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            eventDetailsModel.data.public ? Strings.publicEvent : Strings.privateEvent,
                                            style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 16, fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            eventDetailsModel.data.public ? Strings.publicDesc : Strings.privateDesc,
                                            style: TextStyle(color: Colors.grey[500], letterSpacing: 1.0, fontSize: 14, fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                eventDetailsModel.data != null && eventDetailsModel.data.invitedUsers != null
                                    ? InkWell(
                                        onTap: () {
                                          openParticipantBS();
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                          child: Row(
                                            children: [
                                              Stack(
                                                  children: eventDetailsModel.data.invitedUsers.map((e) {
                                                    if(eventDetailsModel.data.invitedUsers.indexOf(e) != 0){
                                                      userImageCardWidth += 22;
                                                    }
                                                    return Container(
                                                  margin: EdgeInsets.fromLTRB(userImageCardWidth, 0, 0, 0),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(17),
                                                    child: Container(
                                                      width: 34,
                                                      height: 34,
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(17)), color: Colors.grey[300]),
                                                      child: Image.network(
                                                        e.profileImage,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList()),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${eventDetailsModel.data.invitedUsersCount} ${Strings.going}',
                                                style: TextStyle(color: Colors.black, letterSpacing: 0.5, fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w300),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),

                          //Creator Card
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Profile(
                                        userId: eventDetailsModel.data.creator.id.toString(),
                                      )));
                            },
                            child: Container(
                              width: Get.width,
                              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(eventDetailsModel.data.creator.profileImage),
                                      radius: 25,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      eventDetailsModel.data.creator.name,
                                      style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
                                          openGroupChat();
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.green[50]),
                                          child: Center(
                                              child: Icon(
                                            Icons.message,
                                            size: 20,
                                            color: Colors.green[700],
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.green[50]),
                                        child: Center(
                                            child: Icon(
                                          Icons.person,
                                          size: 20,
                                          color: Colors.green[700],
                                        )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //About card
                          Container(
                            width: Get.width,
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Strings.about,
                                  style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  eventDetailsModel.data.description,
                                  style: TextStyle(color: Colors.grey[600], letterSpacing: 1.0, fontSize: 14, fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),

                          //Memories card
                          Container(
                            width: Get.width,
                            padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Strings.challengeMedia,
                                  style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                                eventDetailsModel.data.eventMemories != null && eventDetailsModel.data.eventMemories.length > 0
                                    ? StaggeredGridView.countBuilder(
                                        shrinkWrap: true,
                                        crossAxisCount: 4,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: eventDetailsModel.data.eventMemories.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Get.to(MemoriesSlideShowScreen(
                                                eventDetailsModel: eventDetailsModel,
                                                selectedIndex: index,
                                              ));
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: eventDetailsModel.data.eventMemories[index].contains("mp4")
                                                    ? FutureBuilder(
                                                        future: getVideoThumbnailWidget(eventDetailsModel.data.eventMemories[index]),
                                                        builder: (context, url) {
                                                          if (url.connectionState == ConnectionState.none && url.hasData == null) {
                                                            return Container();
                                                          }
                                                          return Image.file(
                                                            File(url.data ?? ""),
                                                            fit: BoxFit.cover,
                                                          );
                                                        },
                                                      )
                                                    : Image.network(
                                                        eventDetailsModel.data.eventMemories[index],
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            ),
                                          );
                                        },
                                        staggeredTileBuilder: (int index) => new StaggeredTile.count(2, index.isEven ? 2 : 1),
                                        mainAxisSpacing: 4.0,
                                        crossAxisSpacing: 4.0,
                                      )
                                    : Container(),
                                InkWell(
                                  onTap: () {
//                              getMultiImages();
                                    openMediaSelectionBS();
                                  },
                                  child: Container(
                                    width: Get.width,
                                    margin: EdgeInsets.fromLTRB(30, 30, 30, 10),
                                    padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.green),
                                    child: Center(
                                      child: Text(
                                        Strings.addMedia,
                                        style: TextStyle(color: Colors.white, letterSpacing: 1.0, fontSize: 14, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //Accept reject card
                          Visibility(
                            visible: eventDetailsModel.data.status == "pending" ? true : false,
                            child: Container(
                              width: Get.width,
                              padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                              margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        rejectInvitation(eventDetailsModel.data.id.toString(), "reject");
                                      },
                                      child: acceptRejectButton(Colors.black, "No", "assets/images/circle_cross.png")),
                                  InkWell(
                                      onTap: () {
                                        acceptInvitation(eventDetailsModel.data.id.toString());
                                      },
                                      child: acceptRejectButton(Colors.purple[500], "Accept", "assets/images/checkmark.png")),
                                  InkWell(
                                      onTap: () {
                                        rejectInvitation(eventDetailsModel.data.id.toString(), "cant");
                                      },
                                      child: acceptRejectButton(Colors.grey[400], "Cant", "assets/images/cant.png")),
                                ],
                              ),
                            ),
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
                        child: Center(
                          child: LoadingWidget(),
                        ),
                      ),
                    )
                  ],
                )
              : Container(
                  width: Get.width,
                  height: Get.height,
                  child: Center(child: LoadingWidget()),
                )),
    );
  }

  void getEventDetails() {
    HomeRepo().getEventDetails(widget.eventId).then((value) {
      if (value != null && value.data != null) {
        setState(() {
          userImageCardWidth = 0;
          eventDetailsModel = value;
          eventImageList.assignAll(eventDetailsModel.data.media);
          if (eventDetailsModel.data.latitude != null) {
            _kGooglePlex = CameraPosition(
              target: LatLng(double.parse(eventDetailsModel.data.latitude), double.parse(eventDetailsModel.data.longitude)),
              zoom: 14.4746,
            );

            _markers.add(
              Marker(
                markerId: MarkerId("1"),
                position: LatLng(double.parse(eventDetailsModel.data.latitude), double.parse(eventDetailsModel.data.longitude)),
              ),
            );
          }

          if (eventDetailsModel.data.invitedUsers != null && eventDetailsModel.data.invitedUsers.length > 0) {
            if (eventDetailsModel.data.invitedUsers.length > 8) {
              invitedUserImageList = eventDetailsModel.data.invitedUsers.sublist(0, 8);
            } else {
              invitedUserImageList.addAll(eventDetailsModel.data.invitedUsers);
            }
          }
        });
      }
    });
  }

  void getEventParticipant() {
    HomeRepo().getEventParticipant(widget.eventId).then((value) {
      if (value != null) {
        setState(() {
          userImageCardWidth = 0;
          participantModel = value;
        });
      }
    });
  }

  void openParticipantBS() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ParticipantBSWidget(
          inviteUserList: eventDetailsModel.data.invitedUsers,
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Widget acceptRejectButton(Color bgColor, String label, String icon) {
    return Container(
      width: 100,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: bgColor),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              icon,
              width: 30,
              height: 30,
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              label,
              style: TextStyle(color: Colors.white, letterSpacing: 1.0, fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void acceptInvitation(String eventId) {
    setState(() {
      userImageCardWidth = 0;
      isLoading = true;
    });
    HomeRepo().acceptInvitation(eventId).then((value) {
      setState(() {
        userImageCardWidth = 0;

        isLoading = false;
      });
      Config().displaySnackBar(value?.message, "");
      if (value != null && value.status) {
        getEventDetails();
      }
    });
  }

  void rejectInvitation(String eventId, String type) {
    setState(() {
      userImageCardWidth = 0;
      isLoading = true;
    });
    Map<String, String> params = {"type": type};
    HomeRepo().rejectInvitation(eventId, params).then((value) {
      setState(() {
        userImageCardWidth = 0;
        isLoading = false;
      });
      Config().displaySnackBar(value?.message, "");
      if (value != null && value.status) {
        getEventDetails();
      }
    });
  }

  void getMultiImages() async {
    multiImageList.clear();
    selectedImageList.clear();
    try {
      multiImageList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#4CAF50",
          statusBarColor: "#388E3C",
          actionBarTitle: "Connect App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#2196F3",
        ),
      );
    } on Exception catch (e) {}

    if (multiImageList == null && multiImageList.length > 0) {
      return;
    }

    for (int i = 0; i < multiImageList.length; i++) {
      var path = await FlutterAbsolutePath.getAbsolutePath(multiImageList[i].identifier);
      selectedImageList.add(path);
      print("Checking selected image ---- ${selectedImageList[i]}");
    }

    if (selectedImageList.isEmpty) {
      return;
    }

    uploadMemoriesApi();

    setState(() {});
  }

  void uploadMemoriesApi() async {
    isLoading = true;
    List<dio.MultipartFile> fileList = [];
    for (int i = 0; i < selectedImageList.length; i++) {
      String fileName = selectedImageList[i].contains("mp4") ? "video${i}.mp4" : 'image${i}.png';
      fileList.add(await dio.MultipartFile.fromFile(selectedImageList[i], filename: fileName));
    }
    Map<String, dynamic> params = {"event_memories": fileList};
    HomeRepo().uploadMemories(widget.eventId, params).then((value) {
      Config().displaySnackBar(value.message, "");
      setState(() {
        isLoading = false;
      });
      if (value.status) {
        selectedImageList.clear();
        getEventDetails();
      } else {}
    });
  }

  void openGroupChat() {
    if (participantModel != null && participantModel.data != null && participantModel.data.length > 0) {
      List<Users> userList = [];
      for (int i = 0; i < participantModel.data.length; i++) {
        userList.add(
          Users(name: participantModel.data[i].name, id: participantModel.data[i].id, isOnline: false),
        );
      }
      Get.to(
        ChatScreen(
          contactName: eventDetailsModel.data.title,
          chatRoomId: eventDetailsModel.data.id.toString(),
          userList: userList,
          previousPageListener: (_) {},
          isGroupChat: true,
        ),
      );
    }
  }

  Future getVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        isLoading = true;
      });
      String compressVideoPath = await _compressVideo(pickedFile.path);
      selectedImageList.add(compressVideoPath);
      uploadMemoriesApi();
    }
  }

  Future<String> _compressVideo(String filePath) async {
    //Compress file
    final info = await VideoCompress.compressVideo(
      filePath,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    return info.path;
  }

  void openMediaSelectionBS() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return MediaSelectionBSWidget(
          clickListener: (value) {
            Get.back();
            if (value == "image") {
              getMultiImages();
            } else {
              getVideo();
            }
          },
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
    );
  }

  Future<String> getVideoThumbnailWidget(videoUrl) async {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: (await getTemporaryDirectory()).path + "/" + generateRandomString(5) + ".jpg",
      imageFormat: ImageFormat.JPEG,
      maxHeight: 150,
      quality: 75,
    );

    return thumbnailPath;
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  void _launchURL(String url) async => await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}
