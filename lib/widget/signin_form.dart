import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kiddie_care_app/model/authentication.dart';
import '../../../widget/app_button.dart';
import '../../../widget/app_text_field.dart';
import 'package:flutter/material.dart';
import '../utils/shared_preferences_helper.dart';

class SignInSheet extends StatefulWidget {
  final VoidCallback? onSignInSuccess;
  final VoidCallback? onLogout;
  final Function(bool) setShowSignInSheet; // Callback to set _showSignInSheet
  final Authentication? user;

  const SignInSheet(
      {Key? key,
      this.user,
      this.onSignInSuccess,
      this.onLogout,
      required this.setShowSignInSheet})
      : super(key: key);

  @override
  State<SignInSheet> createState() => _SignInSheetState();
}

class _SignInSheetState extends State<SignInSheet> {
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String errorMessage = '';

  Future _signIn(context, user) async {
    if (user.password == _passwordController.text) {
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
          widget.setShowSignInSheet(false); // Close the SignInSheet
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
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Wrong email or password!'),
          );
        },
      );
    }
  }

  Future<void> _signOut() async {
    try {
      // Clear the authentication state
      await FirebaseAuth.instance.signOut();
      // Log out using SharedPreferences
      await SharedPreferencesHelper.logOut();
      // Call the logout callback provided by the user
      widget.onLogout?.call();
    } catch (e) {
      debugPrint('LOG OUT');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ignore: avoid_unnecessary_containers
          Container(
            child: Text(
              // ignore: prefer_interpolation_to_compose_strings
              'Welcome back, ' + widget.user!.email + '.',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Container(
            child: Column(
              children: [
                const SizedBox(height: 10),
                AppTextField(
                  controller: _passwordController,
                  labelText: "Password",
                  isPassword: true,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  controller: _emailController,
                  labelText: "Email",
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                AppButton(
                  text: 'LOGIN',
                  onPressed: () async {
                    _signIn(context, widget.user);
                  },
                  icon: const Icon(
                    Icons.login,
                    color: Colors.white,
                  ),
                  color: Colors.orange,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
