import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kiddie_care_app/services/image_converter.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;

import '../model/authentication.dart';

class MLService {
  Interpreter? _interpreter;
  double threshold = 0.5;

  List _predictedData = [];
  List get predictedData => _predictedData;

  Future initialize() async {
    late Delegate delegate;
    try {
      if (Platform.isAndroid) {
        delegate = GpuDelegateV2(
          options: GpuDelegateOptionsV2(
            isPrecisionLossAllowed: false,
            inferencePreference: TfLiteGpuInferenceUsage.fastSingleAnswer,
            inferencePriority1: TfLiteGpuInferencePriority.minLatency,
            inferencePriority2: TfLiteGpuInferencePriority.auto,
            inferencePriority3: TfLiteGpuInferencePriority.auto,
          ),
        );
      } else if (Platform.isIOS) {
        delegate = GpuDelegate(
          options: GpuDelegateOptions(
              allowPrecisionLoss: true,
              waitType: TFLGpuDelegateWaitType.active),
        );
      }
      var interpreterOptions = InterpreterOptions()..addDelegate(delegate);

      this._interpreter = await Interpreter.fromAsset('mobilefacenet.tflite',
          options: interpreterOptions);
    } catch (e) {
      print('Failed to load model.');
      print(e);
    }
  }

  void setCurrentPrediction(CameraImage cameraImage, Face? face) {
    if (_interpreter == null) throw Exception('Interpreter is null');
    if (face == null) throw Exception('Face is null');

    List input = _preProcess(cameraImage, face);

    input = input.reshape([1, 112, 112, 3]);
    List output = List.generate(1, (index) => List.filled(192, 0));
    this._interpreter?.run(input, output);
    output = output.reshape([192]);

    this._predictedData = List.from(output);
    print('Predicted:');
    print( this._predictedData);
  }

  Future<Authentication?> predict() async {
    return _searchResult(this._predictedData);
  }

  List _preProcess(CameraImage image, Face faceDetected) {
    imglib.Image croppedImage = _cropFace(image,
        faceDetected); //to extract the region of interest (ROI)face from the camera image.
    imglib.Image img =
        imglib.copyResizeCropSquare(croppedImage, 112); //crop into square
    //floating point
    Float32List imageAsList = imageToByteListFloat32(
        img); //convert the processed image into a list of floating-point values suitable for model input and returns
    return imageAsList;
  }

  imglib.Image _cropFace(CameraImage image, Face faceDetected) {
    imglib.Image convertedImage = _convertCameraImage(image);
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    return imglib.copyCrop(convertedImage, x.round(), y.round(), w.round(),
        h.round()); // crop the face region from the camera image based on these calculated coordinates and dimensions
    // returns the cropped face as an imglib.Image
  }

  imglib.Image _convertCameraImage(CameraImage image) {
    // converting a CameraImage (presumably a frame captured from the camera) into an imglib.Image
    var img = convertToImage(
        image); // takes a CameraImage as input and performs necessary transformations to convert it into an imglib.Image
    var img1 = imglib.copyRotate(img,
        -90); // rotates the image by -90 degrees, which is often done to correct the orientation of camera frames
    return img1;
  }

  Float32List imageToByteListFloat32(imglib.Image image) {
    // converts the given imglib.Image into a list of floating-point values suitable for model input.
    //creates a Float32List with the appropriate size based on the dimensions of the image and its color channels (112x112 pixels with 3 color channels).
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    // iterates through each pixel of the image and normalizes the color values (red, green, and blue) to the range [-1, 1] and stores them in the Float32List.
    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
    //The final Float32List represents the processed image data that can be fed into a machine learning model.
  }

  List<double> castToDoubleList(List<dynamic> inputList) {
    return inputList
        .map((value) => value is double
            ? value
            : (value is int
                ? value.toDouble()
                : double.tryParse(value.toString()) ?? 0.0))
        .toList();
  }

  // Future<Authentication?> _searchResult(List predictedData) async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   List<double> predictedDataDouble = castToDoubleList(predictedData);
  //   try {
  //     QuerySnapshot querySnapshot = await firestore
  //         .collection('Authentication')
  //         .where('modelData', isEqualTo: predictedDataDouble)
  //         .get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       // If a match is found, return the first document
  //       var document = querySnapshot.docs[0];
  //       return Authentication.fromMap(document.data() as Map<String, dynamic>);
  //     } else {
  //       // If no match is found, return null
  //       print('No search daooooooo');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error searching for Authentication: $e');
  //     return null; // Handle the error gracefully as needed
  //   }
  // }

  Future<Authentication?> _searchResult(List<dynamic> predictedData) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot =
          await firestore.collection('Authentication').get();

      List<Authentication> users = [];

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        // Parse the modelData string into a List<dynamic>
        List<dynamic>? modelData = data['modelData'] != null
            ? (data['modelData'] as String)
                .split(',')
                .map((value) =>
                    value.trim()) // Trim any leading/trailing whitespace
                .toList()
            : null;

        Authentication user = Authentication(
          email: data['email'],
          password: data['password'],
          role: data['role'],
          uuid: data['uuid'],
          modelData: modelData,
        );
        print('USER HERE');
        print(user.modelData);
        users.add(user);
      }

      double minDist = 999;
      double currDist = 0.0;
      // double minDist = double.infinity; // Initialize minDist to a large value
      Authentication? predictedResult;

      for (Authentication u in users) {
        print('HIIIIIIIIIIIIII');
        // Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        // dynamic modelData = data['modelData'];
        // // List<dynamic>? modelData = data['modelData'] as List<dynamic>?;
        // print('MODELLLLLLL' + modelData.toString());

        // if (modelData != null) {
        //   print('Type of modelData: ${modelData}');

        //   List? modelDataList = modelData as List?;

        //   if (modelDataList != null) {
        //     print('DYNAMIC');
        print('BYEEEEEEEEE');
        print(u.modelData);
        print('HAHAHAHAHHHAHAHA');
        print(predictedData);

        if (u.modelData != null) {
          // List<double> parsedModelData =
          //     u.modelData!.map((value) => double.parse(value.trim())).toList();
          // currDist = _euclideanDistance(parsedModelData, predictedData);
          String modelDataString = u.modelData![
              0]; // Assuming it's a single string containing the list
          modelDataString = modelDataString.substring(
              1, modelDataString.length - 1); // Remove square brackets
          List<String> modelDataList = modelDataString.split(",");
          List<double> parsedModelData = [];

          for (String valueString in modelDataList) {
            try {
              double value = double.parse(valueString.trim());
              parsedModelData.add(value);
            } catch (e) {
              // Handle parsing errors if needed
              print("Error parsing value: $valueString");
            }
          }

          currDist = _euclideanDistance(parsedModelData, predictedData);

          if (currDist <= threshold && currDist < minDist) {
            minDist = currDist;
            predictedResult = u;
            print('PREDIT');
            print(predictedResult);
          } else {
            print('CANNOT PREDIT');
          }
        } else {
          print('NULL NULL');
        }
      
      }

      return predictedResult;
    } catch (e) {
      print('Error searching for Authentication: $e');
      return null; // Handle the error gracefully as needed
    }
  }

  double _euclideanDistance(List? e1, List? e2) {
    print('RUNNING');
    if (e1 == null || e2 == null) throw Exception("Null argument");

    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow((e1[i] - e2[i]), 2);
    }
    return sqrt(sum);
  }

  void setPredictedData(value) {
    this._predictedData = value;
  }

  dispose() {}
}
