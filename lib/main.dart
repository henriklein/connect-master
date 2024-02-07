import 'package:c0nnect/PageController.dart';
import 'package:c0nnect/helper/routes.dart';
import 'package:c0nnect/helper/shared_prefs.dart';
import 'package:c0nnect/helper/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'ChatSystem.dart';
import 'Setup/loginScreen.dart';
import 'globals.dart' as global;
import 'package:get/get.dart';

import 'locale/LocalizationService.dart';

import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

import 'helper/shared_prefs.dart';
import 'locale/LocalizationService.dart';
import 'model/chat_model.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

int notiId = 0;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  configureFirebase();
  await UserPreferences().init();


  Future.delayed(Duration(seconds: 2),(){
  });

  final NotificationAppLaunchDetails notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('gnhnoti');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {

        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });


  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    print('this is payload --- $payload');
//    _showToast('dfdsdf--$payload');
        if (payload != null) {
          notificationRedirection(payload);
        }
      });


   runApp(
       GestureDetector(
         onVerticalDragDown: (details) {
           if(Platform.isIOS) {
             FocusScopeNode currentFocus = FocusScope.of(Get.context);
             if (!currentFocus.hasPrimaryFocus &&
                 currentFocus.focusedChild != null) {
               FocusManager.instance.primaryFocus.unfocus();
             }
           }
         },
         onTap: () {
           if(Platform.isIOS) {
             FocusScopeNode currentFocus = FocusScope.of(Get.context);
           if (!currentFocus.hasPrimaryFocus &&
               currentFocus.focusedChild != null) {
             FocusManager.instance.primaryFocus.unfocus();
           }
           }
         },
         child: GetMaterialApp(
    title: "Connect",
    debugShowCheckedModeBanner: false,
    defaultTransition: Transition.rightToLeft,
    getPages: Routes.route,
    initialRoute: '/splash',
    textDirection: TextDirection.ltr,
    locale: LocalizationService.locale,
    fallbackLocale: LocalizationService.fallbackLocale,
    translations: LocalizationService(),
    theme: ThemeData(
      primaryColor: Colors.blue,
      primaryColorDark: Colors.blue[800],
      primaryColorLight: Colors.pink[300],
      accentColor: Colors.green,
      backgroundColor: Color(0xFF214151),
    ),
    darkTheme: ThemeData(
      primaryColor: Colors.black45,
      primaryColorDark: Colors.black87,
    ),
    themeMode: ThemeMode.light,
  ),
       ));


  }



void configureFirebase(){
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      if(Platform.isAndroid){
        renderNotificationType(message);
      }else{
        renderNotificationTypeios(message);
      }
      print("firebase onMessage: $message");

    },
    onBackgroundMessage: myBackgroundMessageHandler,
    onLaunch: (Map<String, dynamic> message) async {
      print("firebase onLaunch: $message");
      if(Platform.isAndroid){
        renderNotificationType(message);

      }else{
        renderNotificationTypeios(message);
      }

    },
    onResume: (Map<String, dynamic> message) async {
      print("firebase onResume: $message");

      if(Platform.isAndroid){
        renderNotificationType(message);

      }else{
        renderNotificationTypeios(message);
      }


    },
  );
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    renderNotificationType(message);
  }
  if (message.containsKey('notification')) {
    final dynamic notification = message['notification'];
  }
}

void renderNotificationType(Map<String, dynamic> message){
  final dynamic data = message['data'];
  print('notidata : $data');
  String section = data['section'];
  String image = data['image'];

  notiId++;

  if(image!=null){
    _showBigPictureNotificationHiddenLargeIcon(message);
  }else{
    _showNotification(message);
  }
}

void renderNotificationTypeios(Map<String, dynamic> message) async{
  String section = message['notification']['title'];
  print('section 333 ${section}');
//  String image = message['image'];


  const IOSNotificationDetails iosPlatformChannelSpecifics = IOSNotificationDetails( presentSound: true, presentBadge: true, presentAlert: true);

  const NotificationDetails platformChannelSpecifics = NotificationDetails(iOS: iosPlatformChannelSpecifics);

  NotificationDetails(iOS: iosPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
      0, message['notification']['title'], message['notification']['body'], platformChannelSpecifics,
      payload: section);



}


Future<void> _showNotification(Map<String, dynamic> message) async {

  final dynamic data = message['data'];

  String title = data['title'];
  String body = data['body'];
  String image = data['image'];
  String url = data['url'];
  String section = data['section'];
  String id = data['id'];


  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
      '101', 'Connect', 'General',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      notiId, title, body, platformChannelSpecifics,
      payload: jsonEncode(message));
}

Future<void> _showBigPictureNotificationHiddenLargeIcon(Map<String, dynamic> message) async {
  final dynamic data = message['data'];

  String title = data['title'];
  String body = data['body'];
  String image = data['image'];
  String url = data['url'];
  String section = data['section'];
  String id = data['id'];


  final String largeIconPath = await _downloadAndSaveFile(
      image, 'largeIcon');
  final String bigPicturePath = await _downloadAndSaveFile(
      image, 'bigPicture');
  final BigPictureStyleInformation bigPictureStyleInformation =
  BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
      summaryText: body,
      htmlFormatSummaryText: true);
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails('102',
      'gnh-image', 'big text channel description',
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      styleInformation: bigPictureStyleInformation);
  final NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      notiId, title, body, platformChannelSpecifics,
      payload: jsonEncode(message));
}

void _showToast(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black26,
    textColor: Colors.white,
    fontSize: 14.0,
  );
}


Future<String> _downloadAndSaveFile(String url, String fileName) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';
  final http.Response response = await http.get(url);
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}


void notificationRedirection(String payload){
  Map payloadValue = jsonDecode(payload);
  print("checking section value ---- ${payloadValue["data"]["section"]}");
  String section = payloadValue["data"]["section"];

//  if(section.compareTo("sos") == 0){
//    Config.REDIRECT_SECTION = "sos";
//    Get.toNamed("/home");
//  }
  if(section.compareTo("chat") == 0){
    getFirebaseMessages(payloadValue["data"]["id"]);
  }
}

void getFirebaseMessages(String chatId){
  FirebaseFirestore.instance
      .collection("ChatRoom")
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      if(doc.id == chatId){


        String userName;
        if(doc["users"][0]["id"].toString() != UserPreferences().get(UserPreferences.SHARED_USER_ID)){
          userName = doc["users"][0]["name"];
        }
        if(doc["users"][1]["id"].toString() != UserPreferences().get(UserPreferences.SHARED_USER_ID)){
          userName = doc["users"][1]["name"];
        }

        List<Users> userList =[];
        for(int i=0;i<doc["users"].length;i++){
          userList.add(   Users(
            id: doc["users"][i]["id"],
            name: doc["users"][i]["name"],
            image: doc["users"][i]["image"],
            isOnline: doc["users"][i]["isOnline"],
          ));
        }


        Get.to(ChatScreen(contactName: userName, chatRoomId: doc.id,
          userList: userList,
          previousPageListener: null,
          isGroupChat: false,
        ));

      }
    });
  });
}