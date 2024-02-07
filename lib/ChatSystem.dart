import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:c0nnect/helper/shared_prefs.dart';
import 'package:c0nnect/model/chat_model.dart';
import 'package:c0nnect/repository/home_repo.dart';
import 'package:c0nnect/widget/ImageVideoViewWidget.dart';
import 'package:c0nnect/widget/VideoPlayerWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatefulWidget  {
  final contactName;
  final String chatRoomId;
  List<Users> userList;
  final bool isGroupChat;
  final ValueChanged<String> previousPageListener;

  ChatScreen({this.contactName, this.chatRoomId, this.userList, this.previousPageListener, this.isGroupChat});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  bool _showBottom = false;

  TextEditingController messageController = TextEditingController();
  CollectionReference collectionReference = Firestore.instance.collection("ChatRoom");
  DocumentReference documentReference;

  List<Chats> chatList = [];
  final ScrollController _scrollController = ScrollController();

  List<String> localImagePathList = [];
  List<String> networkImageList = [];

  bool attachmentCardOpen = false;
  bool initialOnlineStatus = false;

  List<Users> userList =[];

  String onlineString="Offline";
  AppLifecycleState _notification;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    userList = widget.userList;

    initialOnlineStatus = false;
    setUserOnlineStatus();
    clearChatCount();
    collectionReference.doc(widget.chatRoomId).get().then((value) {
      if (value.exists) {
        print("exist");
        documentReference = collectionReference.doc(widget.chatRoomId);
        fetchChatData();
//        refresh();
      } else {
        print("not exist");
        //Create new chat room
        createNewChatRoom();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.contactName,
                                  style: Theme.of(context).textTheme.subhead,
                                  overflow: TextOverflow.clip,
                                ),
                                Text(
                                  !widget.isGroupChat ?
                                  onlineString
//                                  ""
                                      :
                                  "${userList.length} Members",
                                  style: Theme.of(context).textTheme.subtitle.apply(
                                        color: myGreen,),
                                )
                              ],
                            ),
                          ),
                          Visibility(
                            visible: widget.isGroupChat?false:true,
                            child: RaisedButton.icon(
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                if(widget.previousPageListener != null){
                                  widget.previousPageListener("");
                                }
                              },
                              icon: Icon(Icons.keyboard_arrow_up),
                              color: Colors.grey.shade100,
                              label: Text(
                                "Profile",
                                style: TextStyle(color: Colors.black),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.drag_indicator)
                        ],
                      ),
                    ),
                    Expanded(
                        child: chatList.length > 0
                            ? ListView.builder(
                                controller: _scrollController,
                                itemBuilder: (ctx, i) {
                                  if (UserPreferences().get(UserPreferences.SHARED_USER_ID) == chatList[i].senderId) {
                                    return SentMessageWidget(
                                      i: i,
                                      data: chatList[i],
                                    );
                                  } else {
                                    return ReceivedMessagesWidget(
                                      i: i,
                                      data: chatList[i],
                                      userList: userList,
                                    );
                                  }
                                },
                                itemCount: chatList.length,
                              )
                            : Container()),
                    Container(
                      margin: EdgeInsets.only(left: 15.0, right: 15,bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(35.0),
                                boxShadow: [BoxShadow(offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)],
                              ),
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.attach_file),
                                    onPressed: () {
                                      setState(() {
                                        attachmentCardOpen = !attachmentCardOpen;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.photo_camera),
                                    onPressed: () {
                                      getImage("camera");
                                    },
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: messageController,
                                      minLines: 1,
                                      maxLines: 4,
                                        textInputAction: TextInputAction.send,
                                        onSubmitted: (value){
                                          if (messageController.text.length > 0) {
                                            sendMessage();
                                          }
                                        },
                                        decoration: InputDecoration(hintText: "Type Something...", border: InputBorder.none),
                                      onChanged: (val){

                                        EasyDebounce.debounce(
                                            'typing-status',
                                            Duration(milliseconds: 1000),
                                                () {
                                              print("Typing-------------");
                                                }
                                        );


                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              if (messageController.text.length > 0) {
                                sendMessage();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(color: myGreen, shape: BoxShape.circle),
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 70,
                right: 0,
                left: 0,
                child: AnimatedContainer(
                  width: attachmentCardOpen ? Get.width : 0.0,
                  height: attachmentCardOpen ? 120.0 : 0.0,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCirc,
                  child: Container(
                    width: Get.width,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20), bottomRight: Radius.circular(20)), color: Colors.grey[200]),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                attachmentCardOpen = false;
                              });
                              getImage("gallery");

                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Colors.green[500]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image,color: Colors.white,size: 30,),
                                   SizedBox(height: 10,),
                                   Text('Gallery',
                                          style: TextStyle(
                                           color: Colors.white,
                                            letterSpacing: 1.0,
                                              fontFamily: 'Roboto',
                                         fontSize: 16,
                                         fontWeight: FontWeight.w600
                                                             ),
                                                             ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                attachmentCardOpen = false;
                              });
                              getVideo();
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Colors.green[500]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.video_library,color: Colors.white,size: 30,),
                                   SizedBox(height: 10,),
                                   Text('Video',
                                          style: TextStyle(
                                           color: Colors.white,
                                            letterSpacing: 1.0,
                                              fontFamily: 'Roboto',
                                         fontSize: 16,
                                         fontWeight: FontWeight.w600
                                                             ),
                                                             ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendMessage() {
    chatList.add(Chats(
        text: messageController.text,
        sender: UserPreferences().get(UserPreferences.SHARED_USER_NAME),
        senderId: UserPreferences().get(UserPreferences.SHARED_USER_ID),
        time: DateTime.now().millisecondsSinceEpoch.toString()));

    ChatModel chatModel = ChatModel()
      ..chats = chatList
      ..users = userList;


    documentReference.set(chatModel.toJson()).then((value) {
      sendNotification(messageController.text,"0","");
      messageController.text = "";
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
    });
  }

  void sendLocalImage(String imagePath) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    String imageName = generateRandomString(5);

    File compressImageFile = await _compressAndGetFile(File(imagePath), tempPath + "/" + imageName + ".jpg");

    chatList.add(Chats(
        text: "",
        sender: UserPreferences().get(UserPreferences.SHARED_USER_NAME),
        senderId: UserPreferences().get(UserPreferences.SHARED_USER_ID),
        time: DateTime.now().millisecondsSinceEpoch.toString(),
        imageName: imageName,
        imageUrl: compressImageFile.path));

    ChatModel chatModel = ChatModel()
      ..chats = chatList
      ..users = userList;

    documentReference.set(chatModel.toJson()).then((value) {
      messageController.text = "";

      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);

      getImageLink(compressImageFile.path, imageName);
    });
  }

  void sendLocalVideo(String videoPath) async {
    String imageName = generateRandomString(5);

    String compressVideoPath = await _compressVideo(videoPath);

    String videoThumb = await getVideoThumbnailPath(compressVideoPath);


    chatList.add(Chats(
        text: "",
        sender: UserPreferences().get(UserPreferences.SHARED_USER_NAME),
        senderId: UserPreferences().get(UserPreferences.SHARED_USER_ID),
        time: DateTime.now().millisecondsSinceEpoch.toString(),
        imageName: imageName,
        imageUrl: videoThumb));

    ChatModel chatModel = ChatModel()
      ..chats = chatList
      ..users = userList;

    documentReference.set(chatModel.toJson()).then((value) {
      messageController.text = "";

      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);

      getVideoLink(compressVideoPath, imageName,videoThumb);
    });
  }

  void getImageLink(String imagePath, String imageName) async {
    Map<String, dynamic> params = {
      "media": await dio.MultipartFile.fromFile(imagePath, filename: "chat_image.png"),
      "chat_id": widget.chatRoomId,
      "image_name": imageName,
      "chat_type": widget.isGroupChat ? "group" : "single",

    };

    HomeRepo().getImageLink(params).then((value) {
      if (value != null) {
        for (int i = 0; i < chatList.length; i++) {
          if (value.imageName == chatList[i].imageName) {
            chatList[i].imageUrl = value.url;
          }
        }
        String media = value.url;


        ChatModel chatModel = ChatModel()
          ..chats = chatList
          ..users = userList;

        documentReference.set(chatModel.toJson()).then((value) {
          sendNotification("image","1",media);
          _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
        });
      }
    });
  }

  void getVideoLink(String imagePath, String imageName,String thumbPath) async {
    Map<String, dynamic> params = {
      "media": await dio.MultipartFile.fromFile(imagePath, filename: "video.mp4"),
      "thumb": await dio.MultipartFile.fromFile(thumbPath, filename: "thumb.jpg"),
      "chat_id": widget.chatRoomId, "image_name": imageName,
      "chat_type": widget.isGroupChat ? "group" : "single",
    };

    HomeRepo().getImageLink(params).then((value) {
      if (value != null) {
        for (int i = 0; i < chatList.length; i++) {
          if (value.imageName == chatList[i].imageName) {
            chatList[i].videoUrl = value.url;
            chatList[i].imageUrl = value.thumb;
          }
        }
        String media = value.thumb;


        ChatModel chatModel = ChatModel()
          ..chats = chatList
          ..users = userList;

        documentReference.set(chatModel.toJson()).then((value) {
          sendNotification("video","1",media);
          _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
        });
      }
    });
  }

  Future<File> _compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80,
      rotate: 0,
    );

    print("Compress video");
    if(result != null){
      print(file.lengthSync());
      print(result.lengthSync());
    }

    return result;
  }

  Future<String> _compressVideo(String filePath)async{
    //Compress file
    final info = await VideoCompress.compressVideo(
      filePath,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    return info.path;
  }

  void fetchChatData() {
    documentReference.snapshots().listen((event) {
//      print("Checking chat room id -- ${event.documents[0].id}");

      //Converting data into model
      if (event.data().isNotEmpty) {
        ChatModel chatModel = ChatModel.fromJson(event.data());

        //set to local list
        setState(() {
          chatList = chatModel.chats;
          attachmentCardOpen = false;
          if(!initialOnlineStatus){
            refresh();
            initialOnlineStatus = true;
          }

          userList = chatModel.users;
          if(!widget.isGroupChat){
            onlineString = getOnlineStatus();
            print("checking online status ---- ${onlineString}");
          }

        });




        Future.delayed(Duration(milliseconds: 500), () {
          if(_scrollController != null){
            if(_scrollController.position != null && _scrollController.position.maxScrollExtent != null){
              _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
            }
          }
        });
      }
    });
  }

  void createNewChatRoom() {

    ChatModel chatModel = ChatModel()
      ..chats = chatList
      ..users = userList;


    print("Checkinggg ----- ${chatModel.toJson()}");

    collectionReference.doc(widget.chatRoomId).set(chatModel.toJson()).then((value) {
      //Room created
      //Now fetch the chats
      documentReference = collectionReference.doc(widget.chatRoomId);

      fetchChatData();
    });

    
  }

  Future getImage(String source) async {
    final picker = ImagePicker();
    var pickedFile;
    if(source == "camera"){
      pickedFile = await picker.getImage(source: ImageSource.camera);
    }else{
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      sendLocalImage(pickedFile.path);
    }
  }


  Future getVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      sendLocalVideo(pickedFile.path);
    }
  }

  Future<String> getVideoThumbnailPath(videoUrl) async {
    final Completer<String> completer = Completer();
    Uint8List bytes;
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 150,
      quality: 75,
    );
    final file = File(thumbnailPath);
    bytes = file.readAsBytesSync();
    final _image = Image.memory(bytes);
    _image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(file.path);
    }));
    return completer.future;
  }


  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  void setUserOnlineStatus(){
    if(!widget.isGroupChat){
      if(userList[0].id.toString() == UserPreferences().get(UserPreferences.SHARED_USER_ID)){
        userList[0].isOnline = true;
      }
      if(userList[1].id.toString() == UserPreferences().get(UserPreferences.SHARED_USER_ID)){
       userList[1].isOnline = true;
      }
    }
  }

  String getOnlineStatus(){
    if(!widget.isGroupChat){
      if(userList[0].id.toString() != UserPreferences().get(UserPreferences.SHARED_USER_ID)){
        if(userList[0].isOnline){
         return "Online";
        }else{
          return "Offline";
        }
      }
      if(userList[1].id.toString() != UserPreferences().get(UserPreferences.SHARED_USER_ID)){
        if(userList[1].isOnline){
          return "Online";
        }else{
          return "Offline";
        }
      }
    }
    return "";
  }

  void setOfflineStatus(){
      if(!widget.isGroupChat){
        if(userList[0].id.toString() == UserPreferences().get(UserPreferences.SHARED_USER_ID)){
          userList[0].isOnline = false;
        }
        if(userList[1].id.toString() == UserPreferences().get(UserPreferences.SHARED_USER_ID)){
          userList[1].isOnline = false;
        }
      }

      ChatModel chatModel = ChatModel()
        ..chats = chatList
        ..users = userList;

      documentReference.set(chatModel.toJson()).then((value) {});

  }

  void refresh(){
    ChatModel chatModel = ChatModel()
      ..chats = chatList
      ..users = userList;

    documentReference.set(chatModel.toJson()).then((value) {});

  }

  void sendNotification(String message,String mediaType,String mediaUrl){
    String recipientId = "";
    if(!widget.isGroupChat){
      if(userList[0].id.toString() != UserPreferences().get(UserPreferences.SHARED_USER_ID)){
        recipientId = userList[0].id.toString();
      }
      if(userList[1].id.toString() != UserPreferences().get(UserPreferences.SHARED_USER_ID)){
        recipientId = userList[1].id.toString();
      }
    }
    Map<String,String> params ={
      "chat_id" : widget.chatRoomId,
      "message" : message,
      "recipient_id" : recipientId,
      "chat_type" : widget.isGroupChat ? "group" : "single",
      "media" : mediaType,
      "media_url" : mediaUrl,
    };
    HomeRepo().sendChatNotification(params).then((value){

    });
  }

  void testMethod(){
    //        FirebaseFirestore.instance
//            .collection("ChatRoom")
//            .get()
//            .then((QuerySnapshot querySnapshot) {
//          querySnapshot.docs.forEach((doc) {
//            print("------------ ${doc["users"][0]["name"]}");
//          });
//        });
//


//    documentReference.update(
//        {
//        "users":
//          [
//            {
//              "name" : "hello"
//            },
//            {
//              "name" : "One"
//            }
//          ]
//        }
//    ).then((value){
//      print("User Updated");
//    });
//
//  documentReference.get().then((value){
//    if(){
//
//    }
//  });



  }

  void clearChatCount(){
    Map<String,String> params = {
      "chat_id" : widget.chatRoomId,
      "chat_type" : widget.isGroupChat ? "group" : "single",
    };
    HomeRepo().clearChatCount(params).then((value){

    });
  }

  @override
  void dispose() {
    setOfflineStatus();
    clearChatCount();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;

      switch (state) {
        case AppLifecycleState.resumed:
          print("app in resumed");
          setUserOnlineStatus();
          break;
        case AppLifecycleState.inactive:
          print("app in inactive");
          setOfflineStatus();
          clearChatCount();
          break;
        case AppLifecycleState.paused:
          print("app in paused");
          break;
        case AppLifecycleState.detached:
          print("app in detached");
          break;
      }

    });
  }



}

Color myGreen = Color(0xff4bb17b);
enum MessageType { sent, received }

class MyCircleAvatar extends StatelessWidget {
  final String imgUrl;

  const MyCircleAvatar({
    Key key,
    @required this.imgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(.3), offset: Offset(0, 2), blurRadius: 5)],
      ),
      child: CircleAvatar(
        backgroundImage: NetworkImage("$imgUrl"),
      ),
    );
  }
}

class ReceivedMessagesWidget extends StatelessWidget {
  final int i;
  final Chats data;
  final List<Users> userList;

  const ReceivedMessagesWidget({
    Key key,
    @required this.i,
    this.data,
    this.userList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(data.time));
//    String dateStr = DateFormat("yyyy-MM-dd HH:mm").format(date);
    String dateStr =timeago.format(date,locale: 'en_short') ;

    String profileImage;
    if (userList != null) {
      for (int i = 0; i < userList.length; i++) {
        if (data.senderId == userList[i].id.toString()) {
          profileImage = userList[i].image;
        }
      }
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(5, 20, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MyCircleAvatar(
            imgUrl: profileImage ?? "",
          ),
          SizedBox(width: 5,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                data.sender,
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(height: 5,),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .6),
                    padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                    decoration: BoxDecoration(
                      color: Color(0xfff9f9f9),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: Text(
//                  "${messages[i]['message']}",
                      "${data.text}",
                      style: Theme.of(context).textTheme.body1.apply(
                            color: Colors.black87,
                          ),
                    ),
                  ),
                  data.imageUrl != null
                      ?
                    Stack(
                      children: [
                        InkWell(
                          onTap: (){
                            if(data.videoUrl == null){
                              Get.to(ImageVideoViewWidget(mediaUrl: data.imageUrl,));
                            }else{
//                              Get.to(ImageVideoViewWidget(mediaUrl: data.videoUrl,));
                              Get.to(VideoPlayerWidget(videoUrl: data.videoUrl,fromMemories: false,));
                            }
                          },
                          child: Container(
                            width: 150,
                            height: 200,
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey[300]),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: data.imageUrl.contains("http")
                                    ? Image.network(
                                  data.imageUrl,
                                  width: 150,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                                    : Image.file(
                                  File(data.imageUrl),
                                  width: 150,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                        if(data.videoUrl != null)
                          Positioned(
                              right: 10,
                              bottom: 10,
                              child: Icon(Icons.play_circle_filled,color: Colors.white,size: 30,)
                          )
                      ],
                    )
                      : Container()
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                child: Text(
                  dateStr ?? "",
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

class SentMessageWidget extends StatelessWidget {
  final int i;
  final Chats data;

  const SentMessageWidget({
    Key key,
    this.i,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(data.time));
//    String dateStr = DateFormat("yyyy-MM-dd HH:mm").format(date);
    String dateStr =timeago.format(date,locale: 'en_short') ;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
         Column(
           crossAxisAlignment: CrossAxisAlignment.end,
           children: [
             Stack(
               children: [
                 Container(
                   margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                   constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .6),
                   padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                   decoration: BoxDecoration(
                     color: myGreen,
                     borderRadius: BorderRadius.only(
                       topLeft: Radius.circular(25),
                       topRight: Radius.circular(25),
                       bottomLeft: Radius.circular(25),
                     ),
                   ),
                   child: Text(
//              "${messages[i]['message']}",
                     "${data.text}",
                     style: Theme.of(context).textTheme.body2.apply(
                       color: Colors.white,
                     ),
                   ),
                 ),
                 data.imageUrl != null
                     ? Stack(
                   children: [
                     InkWell(
                       onTap: (){
                         if(data.videoUrl == null){
                           Get.to(ImageVideoViewWidget(mediaUrl: data.imageUrl,));
                         }else{
//                        Get.to(ImageVideoViewWidget(mediaUrl: data.videoUrl,));
                           Get.to(VideoPlayerWidget(videoUrl: data.videoUrl,fromMemories: false,));

                         }
                       },
                       child: Container(
                         width: 150,
                         height: 200,
                         padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey[300]),
                         child: ClipRRect(
                             borderRadius: BorderRadius.circular(10),
                             child: data.imageUrl.contains("http")
                                 ?
                             Image.network(
                               data.imageUrl,
                               width: 150,
                               height: 200,
                               fit: BoxFit.cover,
                             )
                                 :
                             Image.file(
                               File(data.imageUrl),
                               width: 150,
                               height: 200,
                               fit: BoxFit.cover,
                             )),
                       ),
                     ),
                     if(data.videoUrl != null)
                       Positioned(
                           right: 10,
                           bottom: 10,
                           child: Icon(Icons.play_circle_filled,color: Colors.white,size: 30,)
                       )
                   ],
                 )
                     : Container()
               ],
             ),
             SizedBox(height: 5),

             Padding(
               padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
               child: Text(
                 dateStr ?? "",
                 style: TextStyle(fontSize: 12, color: Colors.grey[400]),
               ),
             ),

           ],
         )
        ],
      ),
    );
  }




}
