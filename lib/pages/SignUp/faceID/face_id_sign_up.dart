import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:kiddie_care_app/locator.dart';
import 'package:kiddie_care_app/services/camera_service.dart';
import 'package:kiddie_care_app/services/ml_service.dart';
import 'package:kiddie_care_app/services/face_detector_service.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import '../../../widget/auth_action_button.dart';
import '../../../widget/facepainter.dart';

class FaceSignUp extends StatefulWidget {
  final String role;
  
  const FaceSignUp({Key? key, required this.role}) : super(key: key);

  @override
  FaceSignUpState createState() => FaceSignUpState();
}

class FaceSignUpState extends State<FaceSignUp> {
  String? imagePath;
  Face? faceDetected;
  Size? imageSize;

  bool _detectingFaces = false;
  bool pictureTaken = false;

  bool _initializing = false;

  bool _saving = false;
  bool _bottomSheetVisible = false;

  // service injection
  FaceDetectorService _faceDetectorService = locator<FaceDetectorService>();
  CameraService _cameraService = locator<CameraService>();
  MLService _mlService = locator<MLService>();

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  _start() async {
    setState(() => _initializing = true);
    await _cameraService.initialize();
    setState(() => _initializing = false);
    _faceDetectorService.initialize();
    await _mlService.initialize(); 
    _frameFaces();
  }

  Future<bool> onShot() async {
    if (faceDetected == null) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('No face detected!'),
          );
        },
      );

      return false;
    } else {
      _saving = true; //true
      await Future.delayed(Duration(milliseconds: 500));
      await Future.delayed(Duration(milliseconds: 200));
      XFile? file = await _cameraService.takePicture();
      imagePath = file?.path;

      setState(() {
        _bottomSheetVisible = true;
        pictureTaken = true;
      });

      return true;
    }
  }

  _frameFaces() {
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController?.startImageStream((image) async {
      if (_cameraService.cameraController != null && image != null) {
        if (_detectingFaces) return;
        _detectingFaces = true;
        try {
          // Ensure that the face detector is initialized
          if (_faceDetectorService.initialize()) {
            await _faceDetectorService.detectFacesFromImage(image);

            if (_faceDetectorService.faces.isNotEmpty) {
              setState(() {
                faceDetected = _faceDetectorService.faces[0];
              });
              if (_saving) {
                _mlService.setCurrentPrediction(
                    image, faceDetected); 
                setState(() {
                  _saving = false;
                });
               
              } 
            } else {
              setState(() {
                faceDetected = null;
              });
            }
          } else {
            debugPrint('Face detector model is not initialized.');
          }
          _detectingFaces = false;
        } catch (e) {
          debugPrint('Error _faceDetectorService face => $e');
          _detectingFaces = false;
        }
      } else {
        debugPrint('Image ');
      }
    });
  }

  _reload() {
    setState(() {
      _bottomSheetVisible = false;
      pictureTaken = false;
    });
    this._start();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_declarations
    final double mirror = math.pi;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    late Widget body;
    if (_initializing) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!_initializing && pictureTaken) {
      body = Container(
        width: width,
        height: height,
        child: Transform(
            alignment: Alignment.center,
            // ignore: sort_child_properties_last
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.file(File(imagePath!)),
            ),
            transform: Matrix4.rotationY(mirror)),
      );
    }

    if (!_initializing && !pictureTaken) {
      body = Transform.scale(
        scale: 1.0,
        child: AspectRatio(
          aspectRatio: MediaQuery.of(context).size.aspectRatio,
          child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Container(
                width: width,
                height:
                    width * _cameraService.cameraController!.value.aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CameraPreview(_cameraService.cameraController!),
                    CustomPaint(
                      painter: FacePainter(
                          face: faceDetected, imageSize: imageSize!),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Sign Up'),
        ),
        body: Stack(
          children: [
            body,
            const Text(''),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: !_bottomSheetVisible
            ? AuthActionButton(
                onPressed: onShot,
                isLogin: false,
                reload: _reload,
                role: widget.role,
              )
            : Container());
  }
}
