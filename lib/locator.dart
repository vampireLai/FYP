import 'package:kiddie_care_app/services/camera_service.dart';
import 'package:kiddie_care_app/services/ml_service.dart';
import 'package:kiddie_care_app/services/face_detector_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerLazySingleton<CameraService>(() => CameraService());
  locator.registerLazySingleton<FaceDetectorService>(() => FaceDetectorService());
  locator.registerLazySingleton<MLService>(() => MLService());
}
