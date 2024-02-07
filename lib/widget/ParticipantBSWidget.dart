import 'package:c0nnect/helper/config.dart';
import 'package:c0nnect/helper/strings.dart';
import 'package:c0nnect/model/event_details_model.dart';
import 'package:c0nnect/model/participant_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../profile.dart';

class ParticipantBSWidget extends StatelessWidget {
  final List<Invited_users> inviteUserList;

  const ParticipantBSWidget({Key key, this.inviteUserList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Text('Participants',
                  style: TextStyle(
                   color: Colors.black,
                    letterSpacing: 1.0,
                      fontFamily: 'Roboto',
                 fontSize: 18,
                 fontWeight: FontWeight.w600
                                     ),
                                     ),
          SizedBox(height: 20,),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return InkWell(
                onTap: (){
                  if(inviteUserList[i].friendStatus){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Profile(
                          userId: inviteUserList[i].id.toString(),
                          roomId: inviteUserList[i].chatId != null ? inviteUserList[i].chatId : null,
                        )));
                  }else{
                    Config().displaySnackBar("To view profile you have to connect with ${inviteUserList[i].name}", "");
                  }
                
                  HapticFeedback.mediumImpact();
                },
                child: Container(
                  width: Get.width,
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                     Row(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         Container(
                           width: 40,
                           height: 40,
                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey),
                           child: ClipRRect(
                             borderRadius: BorderRadius.circular(20),
                             child: Image.network(
                               inviteUserList[i].profileImage,
                               width: 40,
                               height: 40,
                               fit: BoxFit.cover,
                             ),
                           ),
                         ),
                         SizedBox(width: 15,),
                         Text(
                           inviteUserList[i].name,
                           style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
                           textAlign: TextAlign.start,
                         ),
                       ],
                     ),

                      Container(
                                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: Colors.green
                                          ),
                        child:  Center(
                          child: Text(inviteUserList[i].status.toUpperCase(),
                                 style: TextStyle(
                                  color: Colors.white,
                                     fontFamily: 'Roboto',
                                fontSize: 10,
                                fontWeight: FontWeight.w400
                                                    ),
                                                    ),
                        ),
                                        ),

                    ],
                  ),
                ),
              );
            },
            itemCount: inviteUserList.length,
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}
