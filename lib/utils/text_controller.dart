import 'package:flutter/widgets.dart';

class TextEditingControllers {
  //edit page
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordComfirmController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController numOfChildController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController userIDController = TextEditingController();

  //babysitter
  final TextEditingController ageController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();

  //childcare centre
  final TextEditingController operatingYearController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  //review dialog
  final TextEditingController reviewController = TextEditingController();

  //comaplaint dialog
  final TextEditingController complaintController = TextEditingController();

  //filter babysitter
  final TextEditingController minAgeController = TextEditingController();
  final TextEditingController minYearController = TextEditingController();


  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordComfirmController.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
    aboutController.dispose();
    numOfChildController.dispose();
    rateController.dispose();
    userIDController.dispose();
    ageController.dispose();
    experienceController.dispose();
    minAgeController.dispose();
    minYearController.dispose();
  }
}
