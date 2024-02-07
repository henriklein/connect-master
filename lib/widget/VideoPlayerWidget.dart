import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';


class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool fromMemories;
  VideoPlayerWidget({Key key, this.videoUrl, this.fromMemories}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {

  VideoPlayerController videoCon;
  ChewieController chewieController;
  bool isInitialised = false;


  @override
  void initState() {
    super.initState();
    videoCon = VideoPlayerController.network(
      widget.videoUrl.replaceAll(' ', '%20'),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    videoCon.addListener(() {
      setState(() {


      });
    });
    videoCon.setLooping(true);
    videoCon.initialize().then((value) {
      setState(() {
        setState(() {
          isInitialised = true;
          //videoCon.play();
        });
      });
    });

    chewieController = ChewieController(
      videoPlayerController: videoCon,
      autoPlay: false,
      looping: true,
      // Try playing around with some of these other options:
      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  @override
  void dispose() {
    videoCon.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: !widget.fromMemories ?
      AppBar(
        backgroundColor: Colors.black,
        title:  Text("",
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600
          ),
        ),
      )
        :
      PreferredSize(preferredSize: Size(0,0),child: Container(),),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: AspectRatio(
                  aspectRatio: videoCon.value.aspectRatio - 0.01,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      isInitialised?
                      Chewie(
                        controller: chewieController,
                      ):Container(height: 100,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


