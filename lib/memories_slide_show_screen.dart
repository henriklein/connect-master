import 'package:c0nnect/helper/app_colors.dart';
import 'package:c0nnect/widget/CarouselImageWidget.dart';
import 'package:c0nnect/widget/VideoPlayerWidget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'model/event_details_model.dart';

class MemoriesSlideShowScreen extends StatefulWidget {
  EventDetailsModel eventDetailsModel;
  int selectedIndex;


  MemoriesSlideShowScreen({this.eventDetailsModel, this.selectedIndex});

  @override
  _MemoriesSlideShowScreenState createState() => _MemoriesSlideShowScreenState();
}

class _MemoriesSlideShowScreenState extends State<MemoriesSlideShowScreen> {


  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300),(){
        pageController.jumpToPage(widget.selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title:  Text('Media',
               style: TextStyle(
                color: Colors.white,
                 letterSpacing: 1.0,
                   fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w600
                                  ),
                                  ),
      ),
      backgroundColor: Colors.black,
      body: Container(
        width: Get.width,
        height: Get.height,
        child: PageView(
          controller: pageController,
          scrollDirection: Axis.horizontal,
          children: widget.eventDetailsModel.data.eventMemories.map(
              (e){
                return
                  e.contains("mp4") ?
                  SingleChildScrollView(
                    child: Container(
                      width: Get.width,
                      height: Get.height,
                      color: Colors.grey,
                      child: Center(
                        child: VideoPlayerWidget(
                          videoUrl: e,
                          fromMemories: true,
                        ),
                      ),
                    ),
                  )
                      :
                  Image.network(e,fit: BoxFit.contain,);
              }
          ).toList(),
        ),
      ),
    );
  }
}

//Stack(
//children: [
//Image.network(e,fit: BoxFit.contain,),
//Container(
//width: Get.width,
//height: Get.height,
//child: Icon(Icons.play_circle_filled,color: Colors.white,size: 60,)
//)
//],
//)