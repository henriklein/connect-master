import 'dart:ui';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/constants.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.green,
        body: Stack(
          children: [
            CustomScrollView(
              // controller: _scrollViewController,

              slivers: [
                SliverAppBar(
                  shadowColor: Colors.green,
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
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    title: Text(
                      'New event Invitation',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w200),
                    ),
                    background: Container(color: Colors.green),
                  ),
                  actions: [
                    IconButton(
                      onPressed: (){},
                        icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    )),
                    IconButton(
                      onPressed: (){},
                        icon: Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    )),
                    SizedBox(
                      width: 15,
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
                            topRight: Radius.circular(60),
                          ),
                          color: kBackgroundColor,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 0, 20),
                                  child: Text(
                                    "My birthday party",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                "MAY",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                "29",
                                                style: TextStyle(fontSize: 20),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Friday"),
                                              Text("10:00-12:00pm")
                                            ]),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            icon: Icon(
                                              Icons.check_box_outlined,
                                              color: Colors.green,
                                            ),
                                            onPressed: null),
                                        IconButton(
                                          icon: Icon(
                                            Icons.cancel_outlined,
                                            color: Colors.orange,
                                          ),
                                          onPressed: null,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Description:",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "This is a event dicription about my awsome party next week. I really dont care about my spelling rn also, this is supposed to be a 3-liner, therefore ...",
                                  maxLines: 3,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "see more",
                                  style: TextStyle(),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    RowSuper(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.green,
                                          backgroundImage: Image.network(
                                                  "https://images.unsplash.com/photo-1519531591569-b84b8174b508?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60")
                                              .image,
                                          radius: 20,
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.green,
                                          backgroundImage: Image.network(
                                                  "https://images.unsplash.com/photo-1519531591569-b84b8174b508?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60")
                                              .image,
                                          radius: 20,
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.green,
                                          backgroundImage: Image.network(
                                                  "https://images.unsplash.com/photo-1536763843054-126cc2d9d3b0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
                                              .image,
                                          radius: 25,
                                        ),
                                      ],
                                      innerDistance: -20.0,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Felix Mayer"),
                                        Text("22 invites send")
                                      ],
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      height: 30,
                                      width: 0.1,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Center(
                                            child: Text(
                                          "See participants",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        )),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Image.asset(
                                  "assets/images/map.png",
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Quickinfo:",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text("Allowed to bring friends"),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.check_box_outlined,
                                      color: Colors.green,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text("Bring Food"),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Comments:",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.green,
                                    backgroundImage: Image.network(
                                            "https://images.unsplash.com/photo-1536763843054-126cc2d9d3b0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
                                        .image,
                                    radius: 25,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                      child: TextFormField(
                                    decoration: InputDecoration(
                                        labelText: 'What do you want to share',
                                        labelStyle: TextStyle(
                                            fontFamily:
                                                'Montserrat', //First Name
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.green))),
                                  ))
                                ]),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Memories:",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Image.asset(
                                  "assets/images/people.jpg",
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Image.asset(
                                  "assets/images/people2.jpg",
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Image.asset(
                                  "assets/images/people3.jpg",
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Image.asset(
                                  "assets/images/people4.jpg",
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Image.asset(
                                  "assets/images/people5.jpg",
                                ),
                                Image.asset(
                                  "assets/images/people3.jpg",
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Image.asset(
                                  "assets/images/people4.jpg",
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.chat_sharp),
                      Icon(Icons.cancel),
                      Icon(Icons.check)
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
