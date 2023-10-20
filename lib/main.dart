import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kiddie_care_app/enum.dart';
import 'package:kiddie_care_app/pages/SignIn/sign_in.dart';
import 'package:kiddie_care_app/utils/shared_preferences_helper.dart';
import 'package:kiddie_care_app/widget/signin_form.dart';

import 'locator.dart';

void main() async {
  setupServices();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _initialized = false;
  bool _error = false;
  bool _isAuthenticated = false;
  bool _showSignInSheet = false;
  String userRole = ''; // Add a variable to store the user's role

  void clearAppState() {
    setState(() {
      _isAuthenticated = false;
    });
  }

  Future<void> checkLoginStatus() async {
    final isAuthenticated = await SharedPreferencesHelper.isLoggedIn();
    setState(() {
      _isAuthenticated = isAuthenticated;
    });
    if (_isAuthenticated) {
      // If authenticated, retrieve the user's role
      userRole = (await SharedPreferencesHelper.getUserRole())!;
    }
  }

  Future<void> logoutCallback() async {
    await SharedPreferencesHelper.logOut();
    setState(() {
      _isAuthenticated = false;
    });
  }

  // Define a function to update _showSignInSheet
  void setShowSignInSheet(bool value) {
    setState(() {
      _showSignInSheet = value;
    });
  }

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return MaterialApp(
        home: Scaffold(
          body: Container(
            color: Colors.white,
            child: const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.orange,
                    size: 25,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Failed to initialise firebase!',
                    style: TextStyle(color: Colors.orange, fontSize: 25),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      home: _isAuthenticated
          ? AppNavigationBar(userRole: userRole)
          : _showSignInSheet
              ? SignInSheet(
                  onSignInSuccess: checkLoginStatus,
                  onLogout: logoutCallback,
                  setShowSignInSheet: setShowSignInSheet, // Pass the callback
                )
              : SignIn(
                  onSignInSuccess: checkLoginStatus,
                  onLogout: logoutCallback,
                ),
    );
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
    checkLoginStatus();
  }
}
