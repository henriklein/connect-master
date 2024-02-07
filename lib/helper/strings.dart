import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'api_urls.dart';
import 'package:get/get.dart';

class Strings{


  static const app_name  = 'Connect';

  static const invalid_otp  = 'Invalid OTP';
  static const profile_title = 'We still dont \nknow how you look';
  static const profile_des = 'add an emoji or real picture \nas your profile';
  static const use_emoji = 'Use Emoji';
  static const take_selfie = 'Take Selfie';
  static const choose_image = 'Choose Image';
  static const close = 'Close';
  static const emoji_profile_image = 'Emoji Profile Image';
  static const emoji_profile_des = 'Choose an emoji and color to use \n as your profile image!';
  static const save = 'SAVE';
  static const invite_friends = 'Invite friends';
  static const location = 'Location';
  static const selectStartTime = 'Select Start Time';
  static const startTime = 'Start Time';
  static const selectEndTime = 'Select End Time';
  static const endTime = 'End Time';
  static const continueString = 'Continue';
  static const pleaseWait = 'Please Wait.....';
  static const inviteFriendsTitle = 'Lets get your friends \non board';
  static const inviteFriendsDesc = 'what is a friends app without friends';
  static const noInvitation = 'No Invitaion';
  static const noFriendRequest = 'No Friend Request';
  static const noData = 'No Data';
  static const noTogetherData = 'No Data';
  static const noUpcomingEvents = 'NO UPCOMING EVENTS';
  static const enterFirstName = 'Enter First Name';
  static const enterLastName = 'Enter Last Name';
  static const connectFriends = 'Want to connect \nyour friends?';
  static const searchForFriends = 'Let us search for friends with are already on connect!';
  static const contactSkip = 'Skip for now';
  static const allowAccess = 'Allow access';
  static const selectCategory = 'Select Category';
  static const enterEventName = 'Enter Event Name';
  static const enterEventDesc = 'Enter Event Description';
  static const enterEventLink = 'Enter Event Link';
  static const noSocialLinkFound = 'No data';
  static const eventEdit = 'EDIT';
  static const publicEvent = 'Public Event';
  static const publicDesc = 'Everyone is able to join this event.';
  static const privateEvent = 'Private Event';
  static const privateDesc = 'Only invited members can join this event';
  static const about = 'About';
  static const direction = 'GET DIRECTIONS';
  static const going = 'going';
  static const challengeTitle = 'What are you up for?';
  static const memories = 'Memories';
  static const addMemories = 'ADD MEMORIES';
  static const challengeMedia = 'Challenge Media';
  static const addMedia = 'Add Media';
  static const unFriend = 'UNFRIEND';
  static const report = 'REPORT';
  static const invite = 'INVITE';
  static const reportReason1 = 'Pretending to be somebody else';
  static const reportReason2 = 'Posting misleading contents';
  static const reportReason3 = 'Violating connect guidelines';


  static const String GOOGLE_PLACES_API_KEY = "AIzaSyDRD9z7fnO3eVi12Hm_ivg8WbcPb3g5ePo";
  static const String GOOGLE_MAP_API_KEY = "AIzaSyDdyth2EiAjU9m9eE_obC5fnTY1yeVNTJU";


  static String formatDateNew(String date){
    print("Checking date --- ${date}");
    final DateFormat oldDateFormat = DateFormat('yyyy-MM-dd');
    final DateFormat newDateFormat = DateFormat('dd MMM yyyy');
    final DateTime oldDate =oldDateFormat.parse(date);
    final String formattedDate = newDateFormat.format(oldDate);
    return formattedDate.toUpperCase();
  }



}