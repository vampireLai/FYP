import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiddie_care_app/pages/SignIn/faceID/face_is_sign_in.dart';
import 'package:kiddie_care_app/pages/SignUp/sign_up_main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/shared_preferences_helper.dart';

class SignIn extends StatefulWidget {
  final VoidCallback? onSignInSuccess;
  final VoidCallback? onLogout;

  const SignIn({Key? key, this.onSignInSuccess, this.onLogout})
      : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        await SharedPreferencesHelper.logIn(); // Save login status

        // Search for a document with matching UID in your Firestore collection
        final uid = userCredential.user!.uid;
        final firestore = FirebaseFirestore.instance;
        final userDoc =
            await firestore.collection('Authentication').doc(uid).get();

        if (userDoc.exists) {
          // Retrieve the user's role from the document
          final userRole = userDoc.data()!['role'] ?? 'guest';

          // Save the user's role in SharedPreferences
          await SharedPreferencesHelper.saveUserData(userRole: userRole);
        } else {
          debugPrint('User is not exist for role');
        }
        debugPrint('Login liaoo');
        widget.onSignInSuccess?.call();
      }
    } catch (e) {
      // Set the error message to be displayed
      setState(() {
        errorMessage = 'Invalid Email or Password';
      });
      // Handle login error
      debugPrint("Error: $e");
    }
  }

  // Future<void> _signOut() async {
  //   try {
  //     // Clear the authentication state
  //     await FirebaseAuth.instance.signOut();

  //     // Log out using SharedPreferences
  //     await SharedPreferencesHelper.logOut();

  //     // Call the logout callback provided by the parent
  //     widget.onLogout?.call();
  //   } catch (e) {
  //     // ... error handling ...
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Images
            Image.asset('images/signupchildcare.png'),
            const SizedBox(height: 10.0),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 23.0),
                  child: Text(
                    'Hello!',
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 23.0),
                  child: Text(
                    'Welcome Back!',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25.0),
            //Input Text Fields
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'Email',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Password',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Password',
                ),
              ),
            ),
            Text(
              errorMessage,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 180.0),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FaceSignIn()),
                    );
                    debugPrint('Sign In with faceID');
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: 'Sign In with Face ID?',
                      style: TextStyle(
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        decorationColor:
                            Colors.orange, // Color of the underline
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      debugPrint('Sign In');
                      _signInWithEmailAndPassword();
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.orange,
                  thickness: 0.8,
                  indent: 50,
                  endIndent: 50,
                ),
                SizedBox(
                  width: 250,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(width: 1.0, color: Colors.orange),
                    ),
                    child: const Text(
                      'New to Kiddie Care?Sign Up',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
