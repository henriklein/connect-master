
import 'package:c0nnect/helper/shared_prefs.dart';
import 'package:c0nnect/model/friends_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:c0nnect/model/chat_model.dart' as chat;

import '../profile.dart';

class HomeFriendsWidget extends StatelessWidget {

  final Data data;
  var online = false.obs;

  CollectionReference collectionReference = Firestore.instance.collection("ChatRoom");
  DocumentReference documentReference;
  List<chat.Chats> chatList = [];


  HomeFriendsWidget({Key key, this.data,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOnlineStatus();
    return Container(
      width: 75,
      height: 75,
      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Profile(
                userId: data.id.toString(),
                roomId: data.chatId,
              )));
          HapticFeedback.mediumImpact();
        },
        child: Stack(
          children: <Widget>[
            data.ring
                ? Container(
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.green, width: 3)),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(data.profileImage), fit: BoxFit.cover)),
                ),
              ),
            )
                :
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(data.profileImage), fit: BoxFit.cover)),
            ),

            Obx(()=>
            online.value
                ? Positioned(
              top: 48,
              left: 52,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
              ),
            )
                :
            Container()
            )


          ],
        ),
      ),
    );
  }
  void getOnlineStatus() {
    collectionReference.doc(data.chatId).get().then((value) {
      if (value.exists) {
        documentReference = collectionReference.doc(data.chatId);
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
          online.value = chatModel.users[0].isOnline;
        }

        if(UserPreferences().get(UserPreferences.SHARED_USER_ID) != chatModel.users[1].id.toString()){
          online.value = chatModel.users[1].isOnline;
        }



      }
    });
  }


}
