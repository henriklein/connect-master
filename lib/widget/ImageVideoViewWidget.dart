import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class ImageVideoViewWidget extends StatefulWidget {
  final String mediaUrl;

  const ImageVideoViewWidget({Key key, this.mediaUrl}) : super(key: key);

  @override
  _ImageVideoViewWidgetState createState() => _ImageVideoViewWidgetState();
}

class _ImageVideoViewWidgetState extends State<ImageVideoViewWidget> {
  VideoPlayerController _controller;
  ChewieController _chewieController;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    if(widget.mediaUrl.contains("mp4")){
      _controller = VideoPlayerController.network(widget.mediaUrl)
//      _controller = VideoPlayerController.network("https://assets.mixkit.co/videos/preview/mixkit-forest-stream-in-the-sunlight-529-large.mp4")
        ..initialize().then((_) {
          setState(() {
            _controller.play();
          });
        });


      _chewieController = ChewieController(
        videoPlayerController: _controller,

        // Prepare the video to be played and display the first frame
        autoInitialize: true,
        autoPlay: true,
        showControlsOnInitialize: false,
        fullScreenByDefault : true,
        // Errors can occur for example when trying to play a video
        // from a non-existent URL
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        },

      );


    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title:  Text(widget.mediaUrl.contains("mp4") ? "" : "",
               style: TextStyle(
                color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600
                                  ),
                                  ),
      ),
      body: Stack(
        children: [
          Container(
            width: Get.width,
            height: Get.height,
            child: widget.mediaUrl.toLowerCase().contains("mp4")
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Chewie(
                    controller: _chewieController,
                  ),
                )
                : widget.mediaUrl.contains("http")
                ?
            PhotoView(
              imageProvider:  NetworkImage(
                widget.mediaUrl,
              ),
            )

                :
            PhotoView(
              imageProvider:  FileImage(
                File(widget.mediaUrl),
              ),
            )

          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    if(_controller != null){
      _controller.dispose();
    }
    if(_chewieController != null){
      _chewieController.dispose();
    }
    super.dispose();
  }
}
