import 'dart:async';
import 'package:faarun/constant/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class SplashPage extends StatefulWidget {



  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>  {
  VideoPlayerController playerController;
  VoidCallback listener;

  @override
  @override
  void initState() {
    super.initState();
    listener = () {
      setState(() {});
    };
    initializeVideo();
    playerController.play();

    ///video splash display only 5 second you can change the duration according to your need
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    playerController.setVolume(0.0);
    playerController.removeListener(listener);
//    Navigator.of(context).pop(SPLASH_PAGE);
    Navigator.of(context).pushReplacementNamed(HOME_PAGE);
  }

  void initializeVideo() {
    playerController =
    VideoPlayerController.asset('assets/videos/splash1440x3040.mp4')
      ..addListener(listener)
      ..setVolume(1.0)
      ..initialize()
      ..play();
  }

  @override
  void deactivate() {
    if (playerController != null) {
      playerController.setVolume(0.0);
      playerController.removeListener(listener);
    }
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (playerController != null) playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(fit:StackFit.expand,
              children: <Widget>[
                new AspectRatio(
                    aspectRatio:  1/ 1,
                    child: Container(
                      child: (playerController != null
                          ? VideoPlayer(
                        playerController,
                      )
                          : Container()),
                    )),
            ],
        )
       );
  }

//  VideoPlayerController playerController;
//  VoidCallback listener;
//
//  @override
//  void initState() {
//    super.initState();
//    listener = (){
//      setState(() {});
//    };
//  }
//
//  void createVideo(){
//    if(playerController == null){
//      playerController = VideoPlayerController.asset("assets/videos/SplashVDO.mp4")
//          ..addListener(listener)
//          ..setVolume(1.0)
//          ..initialize();
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('VIDEO TEST'),
//      ),
//      body: Center(
//        child: AspectRatio(
//            aspectRatio: 720/1280,
//            child: Container(
//              child: (playerController != null
//                  ? VideoPlayer(
//                      playerController,
//                    )
//                  : Container()
//              ),
//            ),
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: (){
//          createVideo();
//          playerController.play();
//        },
//        child: Icon(Icons.play_arrow),
//      ),
//    );
//  }

}

