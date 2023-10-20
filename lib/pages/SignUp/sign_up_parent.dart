import 'package:flutter/material.dart';
import 'package:kiddie_care_app/pages/Parent/edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/authentication.dart';
import '../../utils/text_controller.dart';
import '../../utils/validation.dart';
import 'package:kiddie_care_app/services/ml_service.dart';
import 'package:kiddie_care_app/locator.dart';

class SignUpParent extends StatefulWidget {
  final String role;

  const SignUpParent({super.key, required this.role});

  @override
  State<SignUpParent> createState() => _SignUpParentState();
}

class _SignUpParentState extends State<SignUpParent> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingControllers controllers = TextEditingControllers();
  final MLService _mlService = locator<MLService>();
  String password = '';
  String confirmPassword = '';
  String phoneNumber = '';
  String signUpErrorMessage = '';
  bool passwordMatchError = false;
  bool phoneError = false;
  bool isEdit = false;

  @override
  void dispose() {
    controllers
        .dispose(); // Dispose the controllers when the screen is disposed
    super.dispose();
  }

  bool validatePhoneNumber() {
    setState(() {
      phoneError = !Validation.isValidPhoneNumber(phoneNumber);
    });
    return !phoneError;
    //return Validation.isValidPhoneNumber(phoneNumber);
  }

  bool validatePasswords() {
    setState(() {
      passwordMatchError =
          !Validation.doPasswordsMatch(password, confirmPassword);
    });
    return !passwordMatchError;
  }

  bool validateFields() {
    return Validation.isNotEmpty(controllers.emailController.text) &&
        Validation.isNotEmpty(controllers.phoneNumberController.text) &&
        Validation.isNotEmpty(controllers.passwordController.text) &&
        Validation.isNotEmpty(controllers.passwordComfirmController.text);
  }

  Future<void> _signUpWithEmailAndPassword() async {
    String firebaseUid;
    List predictedData = _mlService.predictedData;

    if (validateFields()) {
      try {
        final UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: controllers.emailController.text,
          password: controllers.passwordController.text,
        );

        if (userCredential.user != null) {
          firebaseUid = userCredential.user!.uid; // Get the Firebase UID

          final newUser = Authentication(
            email: controllers.emailController.text,
            password: controllers.passwordController.text,
            role: widget.role,
            uuid: firebaseUid,
            modelData: predictedData,
          );
          // Convert the newUser instance to a map
          final newUserMap = newUser.toMap();
          // Save the user data to Firestore
          await FirebaseFirestore.instance
              .collection('Authentication')
              .doc(firebaseUid) // Use Firebase UID as the document ID
              .set(newUserMap);

          // Clear the predictedData
          this._mlService.setPredictedData([]);

          //ignore: use_build_context_synchronously
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => EditProfile(
                    role: widget.role,
                    phoneNumber: controllers.phoneNumberController.text,
                    email: controllers.emailController.text,
                    firebaseUid: firebaseUid,
                    isEdit: isEdit,
                  )),
            ),
          );
          debugPrint("CREATEDDDDD");
        }
      } catch (e) {
        setState(() {
          signUpErrorMessage = 'Error during sign-up';
        });
        debugPrint("Error: $e");
      }
    } else {
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all fields for signing up.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                Image.asset('images/signupparent.jpg'),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Sign Up As\nParents",
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            //title
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Create An Account',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            //text fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: TextField(
                controller: controllers.emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter Email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: TextField(
                controller: controllers.phoneNumberController,
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value;
                    if (phoneError) {
                      validatePhoneNumber();
                    }
                  });
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Phone Number',
                  hintText: 'Enter Phone Number',
                  errorText: phoneError ? 'Invalid phone number' : null,
                  errorStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: TextField(
                controller: controllers.passwordController,
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value;
                    if (passwordMatchError) {
                      validatePasswords();
                    }
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter Password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: TextField(
                controller: controllers.passwordComfirmController,
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    confirmPassword = value;
                    if (passwordMatchError) {
                      validatePasswords();
                    }
                  });
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  hintText: 'Confirm Password',
                  errorText:
                      passwordMatchError ? 'Passwords do not match' : null,
                  errorStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (validatePasswords() && validatePhoneNumber()) {
                  _signUpWithEmailAndPassword();
                }
              },
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
