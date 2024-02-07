import 'package:c0nnect/EventScreen.dart';
import 'package:c0nnect/HomeScreen.dart';
import 'package:c0nnect/helper/shared_prefs.dart';
import 'package:c0nnect/model/chat_model.dart' as chat;
import 'package:c0nnect/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class NextUpCard extends StatelessWidget {
  const NextUpCard({
    Key key,
    this.time,
    this.day,
    this.header,
    this.location,
    this.avatarOfPerson,
    this.person,
  }) : super(key: key);
  final String time;
  final String day;
  final String header;
  final String location;
  final String avatarOfPerson;
  final String person;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                SizedBox(height: 5,),
                Text(
                  day,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            width: 1,
            color: Colors.grey.withOpacity(0.5),
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          ),
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 15,),
                Container(
                  width: MediaQuery.of(context).size.width - 160,
                  child: Text(
                    header,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                Visibility(
                  visible: location==''?false:true,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              location,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5,),

                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(avatarOfPerson),
                      radius: 8,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      person,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BuildEventCard extends StatelessWidget {
  const BuildEventCard({
    Key key,
    this.time,
    this.amORpm,
    this.subtitle,
    this.header,
    this.location,
    this.exactLocation,
    this.avatarOfPerson,
    this.person,
    this.duration,
    this.type,
  }) : super(key: key);
  final String time;

  final String header;
  final String amORpm;
  final String location;
  final String avatarOfPerson;
  final String person;
  final String duration;
  final String subtitle;
  final String exactLocation;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 15,
                height: 10,
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(5),
                    )),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: '${time} ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: amORpm,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            )
                          ]),
                    ),
                    Text(
                      duration,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: 220, minHeight: 180),
            decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey[300]), borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.only(right: 10, left: 30),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    padding: EdgeInsets.fromLTRB(22, 5, 22, 5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.green),
                    child: Text(
                      type?.toUpperCase() ?? "",
                      style: TextStyle(color: Colors.white, letterSpacing: 1.0, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Text(
                  header,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 9,
                      backgroundImage: NetworkImage(avatarOfPerson),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          person,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "click for pofile info",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Visibility(
                  visible: location != "" ? true : false,
                  child: Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                location,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                child: Text(
                                  exactLocation,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContactsCard extends StatefulWidget {
  const ContactsCard({
    Key key,
    this.imgPath,
    this.contactName,
    this.contactBiography,
    this.chatId,
    this.unreadCount, this.timeAgo,
  }) : super(key: key);
  final String imgPath;
  final String contactName;
  final String contactBiography;
  final String chatId;
  final String timeAgo;
  final int unreadCount;

  @override
  _ContactsCardState createState() => _ContactsCardState();
}

class _ContactsCardState extends State<ContactsCard> {
  String latestMessage = "";
  CollectionReference collectionReference = Firestore.instance.collection("ChatRoom");
  DocumentReference documentReference;
  List<chat.Chats> chatList = [];

  var isOnline = false.obs;

  @override
  void initState() {
    super.initState();

    getLatestMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                  child: Row(children: [
                   Stack(
                     children: [
                       Container(
                         width: 70,
                         height: 70,
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(35),
                             color: Colors.grey[200]
                         ),
                         child: ClipRRect(
                           borderRadius: BorderRadius.circular(35),
                           child: Image.network(
                             widget.imgPath ?? "",
                             fit: BoxFit.cover,),
                         ),
                       ),
                       Obx(()=>
                           Positioned(
                             bottom: 0,
                             right: 6,
                             child: Visibility(
                               visible: isOnline.value,
                               child: Container(
                                 width: 20,
                                 height: 20,
                                 decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
                               ),
                             ),
                           ),
                       )

                     ],
                   ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(widget.contactName, style: TextStyle(fontFamily: 'Montserrat', fontSize: 17.0, fontWeight: FontWeight.bold)),
                   SizedBox(height: 5,),
                    Text(widget.contactBiography,overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontFamily: 'Montserrat', fontSize: 15.0, color: Colors.grey))
                  ]),
                )
              ])),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                Visibility(
                  visible: widget.unreadCount != 0 ? true : false,
                  child: Container(
                    width: 26,
                    height: 26,
                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.green),
                    child:  Center(
                      child: Text(widget.unreadCount.toString(),
                             style: TextStyle(
                              color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600
                                                ),
                                                ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       Text(widget.timeAgo ?? "",
                              style: TextStyle(
                               color: Colors.black,
                                  fontFamily: 'Roboto',
                             fontSize: 12,
                             fontWeight: FontWeight.w600
                                                 ),
                                                 ),
//                      Icon(Icons.arrow_right)
                    ],
                  ),
                )
              ],
            )
          ],
        ));
  }

  void getLatestMessage() {
    collectionReference.doc(widget.chatId).get().then((value) {
      if (value.exists) {
        documentReference = collectionReference.doc(widget.chatId);
//        refresh();
        fetchChatData();
      }
    });
  }

  void fetchChatData() {
    documentReference.snapshots().listen((event) {
//      print("Checking chat room id -- ${event.documents[0].id}");

      //Converting data into model
      if (event.data().isNotEmpty) {
        chat.ChatModel chatModel = chat.ChatModel.fromJson(event.data());

        //set to local list
//        setState(() {
//          chatList = chatModel.chats;
//          if (chatList.isNotEmpty) {
//            latestMessage = chatList[chatList.length - 1].text;
//          }
//        });

        if(UserPreferences().get(UserPreferences.SHARED_USER_ID) != chatModel.users[0].id.toString()){
          isOnline.value = chatModel.users[0].isOnline;
        }

        if(UserPreferences().get(UserPreferences.SHARED_USER_ID) != chatModel.users[1].id.toString()){
          isOnline.value = chatModel.users[1].isOnline;
        }



      }
    });
  }
}

class EventNotification extends StatelessWidget {
  final String time;
  final String day;
  final String title;
  final String desc;
  final String profile;
  final ValueChanged<String> actionListener;

  const EventNotification({
    Key key,
    this.time,
    this.day,
    this.title,
    this.desc,
    this.profile,
    this.actionListener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(10),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                Text(
                  day,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
            height: 100,
            width: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(profile),
                          radius: 10,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  desc,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Column(
                  children: [
                    IconButton(
                        icon: Icon(Icons.check_box_outlined, color: Colors.green),
                        onPressed: () {
                          actionListener("accept");
                        }),
                    Text(
                      "Accept",
                      style: TextStyle(color: secondColor, fontSize: 8, fontWeight: FontWeight.w200),
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                        icon: Icon(Icons.cancel_outlined, color: Colors.orange),
                        onPressed: () {
                          actionListener("decline");
                        }),
                    Text(
                      "Decline",
                      style: TextStyle(color: secondColor, fontSize: 8, fontWeight: FontWeight.w200),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FriendRequestWidget extends StatelessWidget {
  final String time;
  final String title;
  final String profile;
  final ValueChanged<String> actionListener;

  const FriendRequestWidget({
    Key key,
    this.time,
    this.title,
    this.profile,
    this.actionListener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(10),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
            height: 100,
            width: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(profile),
                        radius: 10,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Column(
                  children: [
                    IconButton(
                        icon: Icon(Icons.check_box_outlined, color: Colors.green),
                        onPressed: () {
                          actionListener("accept");
                        }),
                    Text(
                      "Accept",
                      style: TextStyle(color: secondColor, fontSize: 8, fontWeight: FontWeight.w200),
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                        icon: Icon(Icons.cancel_outlined, color: Colors.orange),
                        onPressed: () {
                          actionListener("decline");
                        }),
                    Text(
                      "Decline",
                      style: TextStyle(color: secondColor, fontSize: 8, fontWeight: FontWeight.w200),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
