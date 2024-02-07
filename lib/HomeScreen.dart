import 'dart:io';
import 'dart:ui';
import 'package:c0nnect/components/icon_btn_with_counter.dart';
import 'package:c0nnect/components/cards.dart';
import 'package:c0nnect/event_details_screen.dart';
import 'package:c0nnect/model/events_model.dart';
import 'package:c0nnect/model/memories_model.dart'as memories;
import 'package:c0nnect/profile.dart';
import 'package:c0nnect/repository/home_repo.dart';
import 'package:c0nnect/widget/HomeFriendsWidget.dart';
import 'package:c0nnect/widget/LoadingWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'challenge_details_screen.dart';
import 'components/constants.dart';
import 'components/data.dart';
import 'create_challenge_screen.dart';
import 'edit_event_screen.dart';
import 'globals.dart' as globals;
import 'package:get/get.dart';

import 'helper/shared_prefs.dart';
import 'model/friends_model.dart'as friends;
import 'newEvent.dart';

//import 'listEvents.dart' as Event;

Color mainColor = Color(0xff774a63);
Color secondColor = Colors.grey;

class HomeScreen extends StatefulWidget {
  final ValueChanged<String> switchTab;
  final ValueChanged<String> openBottomBar;

  const HomeScreen({Key key, this.switchTab, this.openBottomBar}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin<HomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    configureFirebase();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                      height: 80,
                      child: Chats()),
                  NextUp(
                    switchTab: (value) {
                      widget.switchTab(value);
                    },
                  ),
                  PostFeed(),
                ],
              ),
            ),
          ),
          Container(
              child: Text(
            "c0nnect",
            style: TextStyle(fontSize: 60),
          )),
          Header(
            openBottomBar: (value){
              widget.openBottomBar('');
            },
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive {
    return true;
  }


  void configureFirebase(){
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        if(Platform.isAndroid){
//          renderNotificationType(message);

        }else{
//          renderNotificationTypeios(message);
        }
        print("firebase onMessage: $message");

      },
      onLaunch: (Map<String, dynamic> message) async {
        print("firebase onLaunch: $message");
        if(Platform.isAndroid){
          //   renderNotificationType(message);

        }else{
          // renderNotificationTypeios(message);
        }

      },
      onResume: (Map<String, dynamic> message) async {
        print("firebase onResume: ${message}");
        print("firebase onResume: ${message["aps"]["alert"]["title"]}");
        print("firebase onResume: ${message["aps"]["alert"]["body"]}");
        print("firebase onResume: ${message["section"]}");
        // print("firebase onResume: ${message["aps"]["alert"]["section"]}");

        if(Platform.isAndroid){
          //renderNotificationType(message);

        }else{
          //  renderNotificationTypeios(message);
        }


      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }


}

class Header extends StatelessWidget {

  final ValueChanged<String> openBottomBar;

  const Header({
    Key key, this.openBottomBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return new ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
        child: Container(
          color: kBackgroundColor.withOpacity(.9),
          height: 130,
          padding: EdgeInsets.fromLTRB(width * 0.05, height * 0.07, width * 0.05, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Welcome back,',
                    style: TextStyle(color: secondColor, fontSize: 20),
                  ),
                  Text(
                    UserPreferences().get(UserPreferences.SHARED_USER_NAME)?.split(" ")[0],
                    style: TextStyle(color: mainColor, fontSize: 30),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    IconBtnWithCounter(
                      svgSrc: "assets/icons/plus.svg",
                      press: () {
                        HapticFeedback.heavyImpact();
                        openBottomBar('');
                        //_showSearch(context);
//                        Get.to(NewEvent());
                      },
                    ),
//                    SizedBox(
//                      width: 15,
//                    ),
//                    IconBtnWithCounter(
//                      svgSrc: "assets/icons/Bell.svg",
//                      press: () => HapticFeedback.heavyImpact(),
//                      numOfitem: 9,
//                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Chats extends StatefulWidget {

  final String chatId;

  const Chats({
    Key key, this.chatId,
  }) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  friends.FriendsModel friendsModel = friends.FriendsModel();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFriendsList();
  }

  @override
  Widget build(BuildContext context) {
    return friendsModel != null && friendsModel.data != null
        ? ListView.builder(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: friendsModel.data.length,
            itemBuilder: (context, i) {
              return HomeFriendsWidget(data: friendsModel.data[i],);
            })
        :

//      Row(
//          children: List.generate(friendsModel.data.length, (index) {
//            return Padding(
//              padding: const EdgeInsets.only(right: 20),
//              child: Column(
//                children: <Widget>[
//                  Container(
//                    width: 75,
//                    height: 75,
//                    child: GestureDetector(
//                      onTap: () {
//                        Navigator.of(context).push(MaterialPageRoute(
//                            builder: (context) => Profile(
//                              userId: friendsModel.data[index].id.toString(),
//                              roomId: friendsModel.data[index].chatId,
//                            )));
//                        HapticFeedback.mediumImpact();
//                      },
//                      child: Stack(
//                        children: <Widget>[
//                          friendsModel.data[index].ring
//                              ?
//                          Container(
//                            decoration: BoxDecoration(
//                                shape: BoxShape.circle,
//                                border: Border.all(
//                                    color: Colors.green, width: 3)),
//                            child: Padding(
//                              padding: const EdgeInsets.all(3.0),
//                              child: Container(
//                                width: 75,
//                                height: 75,
//                                decoration: BoxDecoration(
//                                    shape: BoxShape.circle,
//                                    image: DecorationImage(
//                                        image: NetworkImage(
//                                            friendsModel.data[index].profileImage),
//                                        fit: BoxFit.cover)),
//                              ),
//                            ),
//                          )
//                              :
//                          Container(
//                            width: 70,
//                            height: 70,
//                            decoration: BoxDecoration(
//                                shape: BoxShape.circle,
//                                image: DecorationImage(
//                                    image: NetworkImage(
//                                        friendsModel.data[index].profileImage),
//                                    fit: BoxFit.cover)),
//                          ),
//                          friendsModel.data[index].online
//                              ? Positioned(
//                            top: 48,
//                            left: 52,
//                            child: Container(
//                              width: 20,
//                              height: 20,
//                              decoration: BoxDecoration(
//                                  color: online,
//                                  shape: BoxShape.circle,
//                                  border:
//                                  Border.all(color: white, width: 3)),
//                            ),
//                          )
//                              : Container()
//                        ],
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            );
//          }))
        //:
        Container();
  }

  void getFriendsList() {
    HomeRepo().getFriendsList().then((value) {
      if (value != null && value.data != null) {
        setState(() {
          List<friends.Data> friendsList = [];
          for(int i=0;i<value.data.length;i++){
            if(value.data[i].chatType == "single"){
              friendsList.add(value.data[i]);
            }
          }
          friendsModel.data = friendsList;
        });
      }
    });
  }


}

class NextUp extends StatefulWidget {
  final ValueChanged<String> switchTab;

  const NextUp({
    Key key,
    this.switchTab,
  }) : super(key: key);

  @override
  _NextUpState createState() => _NextUpState();
}

class _NextUpState extends State<NextUp> {
  EventsModel eventsModel = EventsModel();
  EventsModel challengeModel = EventsModel();

  @override
  void initState() {
    super.initState();
    getEventData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(text: "upcoming", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold), children: [
                    TextSpan(
                      text: "events",
                      style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.normal),
                    ),
                  ]),
                ),
                GestureDetector(
                  onTap: () {
                    widget.switchTab("");
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          eventsModel != null && eventsModel.data != null ?
              eventsModel.data.length > 0 ?
            ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onTap: () {
                        if(eventsModel.data[i].type.toLowerCase() == "event"){
                          Get.to(EventDetailsScreen(
                            eventId: eventsModel.data[i].id.toString(),
                          ));
                        }else if(eventsModel.data[i].type.toLowerCase() == "challenge"){
                          Get.to(ChallengeDetailsScreen(
                            eventId: eventsModel.data[i].id.toString(),
                          ));
                        }
                      },
                      child: NextUpCard(
                        time: eventsModel.data[i].startTime,
                        day: eventsModel.data[i].eventDate,
                        header: eventsModel.data[i].title,
                        location: eventsModel.data[i].address ?? "",
                        avatarOfPerson: eventsModel.data[i].creator.profileImage,
                        person: eventsModel.data[i].creator.name,
                      ),
                    );
                  },
                  itemCount: eventsModel.data.length >= 3 ? 3 : eventsModel.data.length,
                )
             :
              Container(
                width: Get.width,
                height: 180,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       Text('NO EVENTS FOUND',
                              style: TextStyle(
                               color: Colors.grey[300],
                                letterSpacing: 1.0,
                                  fontFamily: 'Roboto',
                             fontSize: 14,
                             fontWeight: FontWeight.w500
                                                 ),
                                                 ),
                      SizedBox(height: 20,),
                      InkWell(
                        onTap: (){
                          Get.to(NewEvent());
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 250,
                                            height: 50,
                                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(30)),
                                              color: Colors.green
                                            ),
                          child:  Text('CREATE EVENT',
                                 style: TextStyle(
                                  color: Colors.white,
                                     fontFamily: 'Roboto',
                                fontSize: 16,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w400
                                                    ),
                                                    ),
                                          ),
                      ),
                    ],
                  ),
                ),
              )
              :
            LoadingWidget(),


          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(text: "upcoming", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold), children: [
                    TextSpan(
                      text: "challenge",
                      style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.normal),
                    ),
                  ]),
                ),
                GestureDetector(
                  onTap: () {
                    widget.switchTab("");
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          challengeModel != null && challengeModel.data != null ?
          challengeModel.data.length > 0 ?
          ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () {
                  if(challengeModel.data[i].type.toLowerCase() == "event"){
                    Get.to(EventDetailsScreen(
                      eventId: challengeModel.data[i].id.toString(),
                    ));
                  }else if(challengeModel.data[i].type.toLowerCase() == "challenge"){
                    Get.to(ChallengeDetailsScreen(
                      eventId: challengeModel.data[i].id.toString(),
                    ));
                  }
                },
                child: NextUpCard(
                  time: challengeModel.data[i].startTime??'',
                  day: challengeModel.data[i].eventDate??'',
                  header: challengeModel.data[i].title??'',
                  location: challengeModel.data[i].address??'',
                  avatarOfPerson: challengeModel.data[i].creator.profileImage??'',
                  person: challengeModel.data[i].creator.name??'',
                ),
              );
            },
            itemCount: challengeModel.data.length >= 3 ? 3 : challengeModel.data.length,
          )
              :
          Container(
            width: Get.width,
            height: 180,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text('NO CHALLENGES FOUND',
                    style: TextStyle(
                        color: Colors.grey[300],
                        letterSpacing: 1.0,
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: (){
                      widget.switchTab("challenge");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 250,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Colors.green
                      ),
                      child:  Text('CREATE CHALLENGE',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          )
              :
          LoadingWidget(),


        ],
      ),
    );
  }

  void getEventData() {
    Map<String, String> params = {"type": "upcoming"};
    HomeRepo().getEventsList(params).then((value) {
      if (value != null && value.data != null) {
        setState(() {

          List<Data> eventDataList = [];
          for(int i=0;i<value.data.length;i++){
            if(value.data[i].type.toLowerCase() == "event"){
              eventDataList.add(value.data[i]);
            }
          }
          eventsModel.data = eventDataList;


          List<Data> challengeDataList = [];
          for(int i=0;i<value.data.length;i++){
            if(value.data[i].type.toLowerCase() == "challenge"){
              challengeDataList.add(value.data[i]);
            }
          }
          challengeModel.data = challengeDataList;

        });
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class PostFeed extends StatefulWidget {
  const PostFeed({
    Key key,
  }) : super(key: key);

  @override
  _PostFeedState createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> {
  memories.MemoriesModel memoriesModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMemories();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[

        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(text: "event", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold), children: [
                  TextSpan(
                    text: "memories",
                    style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.normal),
                  ),
                ]),
              ),

            ],
          ),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 80),
            child: memoriesModel != null && memoriesModel.data != null
                ? memoriesModel.data.length > 0
                ? ListView.builder(
              shrinkWrap: true,
              itemCount: memoriesModel.data.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var currentIndex = 1.obs;
                return GestureDetector(
                  onTap: (){
                    if(memoriesModel.data[index].type == "event"){
                      Get.to(EventDetailsScreen(
                        eventId: memoriesModel.data[index].eventId.toString(),
                      ));
                    }
                    else if(memoriesModel.data[index].type == "challenge"){
                      Get.to(ChallengeDetailsScreen(
                        eventId: memoriesModel.data[index].eventId.toString(),
                      ));
                    }

                  },
                  child: Container(
                    height: 330,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Stack(
                      children: [





                        PageView(
                          children: memoriesModel.data[index].media.map((e){
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.grey[200],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child:
                                CachedNetworkImage(
                                  imageUrl: e.isNotEmpty ? e : "",
                                  errorWidget: (context, url, error) => Icon(Icons.error,color: Colors.transparent,),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }).toList(),
                          onPageChanged: (value){
                            currentIndex.value = value+1;
                          },
                        ),

                        Obx(()=>
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.green[500]
                                ),
                                child: Text('Showing ${currentIndex} of ${memoriesModel.data[index].media.length}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            ),
                        ),

                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 20,
                                  color: secondColor.withOpacity(0.25),
                                ),
                              ],
                            ),
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                    memoriesModel.data[index]?.creator?.profileImage ?? "",
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        memoriesModel.data[index]?.creator?.name,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: mainColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "${memoriesModel.data[index].name} at ${memoriesModel.data[index].address ?? ""}",
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: secondColor,
                                          ),
                                          maxLines:2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
//                  Spacer(),
//                  Icon(
//                    Icons.more_vert,
//                    color: mainColor,
//                    size: 30,
//                  ),
                              ],
                            ),
                          ),
                        )



                      ],
                    ),
                  ),
                );
              },
            )
                : Container(
              width: Get.width,
              height: 200,
              child: Center(
                child:   Text('NO EVENT MEMORIES',
                  style: TextStyle(
                      color: Colors.grey[400],
                      letterSpacing: 1.0,
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w700
                  ),
                ),

              ),
            )
                : LoadingWidget()),

      ]
    );
  }

  void getMemories() {
    HomeRepo().getMemories().then((value) {
      if (value.data != null) {
        setState(() {
          memoriesModel = value;
        });
      }
    });
  }
}
