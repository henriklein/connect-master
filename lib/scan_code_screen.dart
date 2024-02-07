import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camerakit/CameraKitController.dart';
import 'package:camerakit/CameraKitView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'model/scan_code.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';

class ScanCodeScreen extends StatefulWidget {
  static String routeName = '/scanCode';
  final ValueChanged<String> onBarcodeScanned;

  const ScanCodeScreen({Key key, this.onBarcodeScanned}) : super(key: key);

  @override
  _ScanCodeScreenState createState() {
    return _ScanCodeScreenState();
  }
}

class _ScanCodeScreenState extends State<ScanCodeScreen>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CameraController controller;
  CameraKitController cameraKitController;
  String imagePath;
  String scanCode;
  bool _flashlightOn = false;
  bool takePicCamOn = false;
  bool scanDone = false;
  bool showDisplayImage = false;
  String targetPath = '';


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    cameraKitController = CameraKitController();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
//    if (controller == null || !controller.value.isInitialized) {
//      return;
//    }
//    if (state == AppLifecycleState.inactive) {
//      controller?.dispose();
//    } else if (state == AppLifecycleState.resumed) {
//      if (controller != null) {
//        onNewCameraSelected(controller.description);
//      }
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Visibility(
            visible: true,
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              color: Colors.black,
              child: Center(
                child: _cameraPreviewWidget(),
              ),
            ),
          ),
          Visibility(
            visible: true,
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: CameraKitView(
                hasBarcodeReader: true,
                barcodeFormat: BarcodeFormats.FORMAT_ALL_FORMATS,
                scaleType: ScaleTypeMode.fill,
                previewFlashMode: CameraFlashMode.off,
                cameraKitController: cameraKitController,
                androidCameraMode: AndroidCameraMode.API_X,
                cameraSelector: CameraSelector.back,
                onBarcodeRead: (barcode) {
                  if(!scanDone){
                    scanDone = true;
                    takePicCamOn = true;
                    scanCode = barcode;
                    widget.onBarcodeScanned(scanCode);
                  }

                },
              ),
            ),
          ),
          Center(
            child: Image(
              image: AssetImage('assets/images/angle.png'),
              height: MediaQuery
                  .of(context)
                  .size
                  .width / 2,
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                if (_flashlightOn) {
                  setState(() {
                    _flashlightOn = false;
                  });
                  cameraKitController.changeFlashMode(CameraFlashMode.off);
                } else {
                  setState(() {
                    _flashlightOn = true;
                  });
                  cameraKitController.changeFlashMode(CameraFlashMode.on);
                }
              },
              child: Container(

                alignment: Alignment.center,
                height: 70,
                width: 70,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    color: Colors.white),
                child: SvgPicture.asset(
                  'assets/images/flash.svg',
                  height: 30.0,
                  color: _flashlightOn ? Colors.orangeAccent : Colors.grey[500],
                ),
              ),
            ),
          ),

          Visibility(
            visible: showDisplayImage,
            child: Positioned(
                top: 50,
                child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(File(targetPath), height: 200,)
                )),
          ),

        ],
      ),
    );
  }

  Future<CameraDescription> getCamera() async {
    try {
      List<CameraDescription> cameras = await availableCameras();
      CameraDescription camera = cameras[0];
      return camera;
    } on CameraException catch (e) {
      logError(e.code, e.description);
      return null;
    }
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return SizedBox();
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        // showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (controller != null && controller.value.isInitialized) {
      Future.delayed(Duration(milliseconds: 500), () {
        onTakePictureButtonPressed();
      });
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) async {
      if (mounted) {
        setState(() {
          imagePath = filePath;
        });
        if (filePath != null) {
          // showInSnackBar('Picture saved to $filePath');
          print("Flutter read barcode:  ---- $imagePath ---- $scanCode");


          await getTemporaryDirectory().then((value) =>
          {
            targetPath = '${value.path}/${DateTime.now()}.jpg',
            print('targetPath--- $targetPath'),

          });
          await testCompressAndGetFile(File(imagePath), targetPath);

          setState(() {
            showDisplayImage = true;
          });

          HapticFeedback.heavyImpact();
          Navigator.of(context).pop<ScanCode>(new ScanCode(targetPath, scanCode));

        }
      }
    });
  }

  Future<String> takePicture() async {
    String timestamp() =>
        DateTime
            .now()
            .millisecondsSinceEpoch
            .toString();

    if (!controller.value.isInitialized) {
      //  showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);

    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    // showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    print("testCompressAndGetFile");
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
      minWidth: 1080,
      minHeight: 1920,
      rotate: 0,
    );
    return result;
  }


  Future<void> showBarcodeDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Barcode Detected'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to proceed'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Scan again'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  targetPath = '';
                  scanDone = false;
                  takePicCamOn = false;
                  showDisplayImage = false;
                  controller = null;
                });
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                if(targetPath==''){
                  showInSnackBar('Loading image please wait..');
                  return;
                }
                print('in yes');
                Navigator.of(context).pop();
                Navigator.of(context).pop<ScanCode>(new ScanCode(targetPath, scanCode));
              },
            ),

          ],
        );
      },
    );
  }
}
