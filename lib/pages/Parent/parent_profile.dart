import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiddie_care_app/pages/Parent/parent_full_profile.dart';
import 'package:kiddie_care_app/widget/profile_widget.dart';
import 'package:kiddie_care_app/widget/button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/shared_preferences_helper.dart';
import '../Babysitter/babysitter_full_profile.dart';
import '../ChildcareCentre/childcare_full_profile.dart';
import '../SignIn/sign_in.dart';

class ParentProfile extends StatefulWidget {
  const ParentProfile({super.key});

  @override
  State<ParentProfile> createState() => _ParentProfileState();
}

// ignore: camel_case_types
class _ParentProfileState extends State<ParentProfile> {
  String _userName = ''; // Declare _userName here
  String _userPhoneNumber = '';
  String _userEmail = '';
  String _userUuid = '';
  String _userImage = '';

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Call the method to retrieve user info
  }

  Future<void> fetchUserData() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null) {
      debugPrint("Fetching user document for UID: $currentUserUid");
      final userDoc = await FirebaseFirestore.instance
          .collection('Authentication')
          .doc(currentUserUid)
          .get();

      if (userDoc.exists) {
        //get user role from default authentication database
        final userRole = userDoc['role'];

        //pass in user's role
        final userCollection = FirebaseFirestore.instance.collection(userRole);
        debugPrint("User collection: $userCollection");

        //role database's uuid same with current uuid?
        final userDataQuery =
            userCollection.where('uuid', isEqualTo: currentUserUid);
        final userDataSnapshot = await userDataQuery.get();

        if (userDataSnapshot.docs.isNotEmpty) {
          final userDataDoc = userDataSnapshot.docs.first;
          final userName = userDataDoc['name'];
          final userPhoneNumber = userDataDoc['phoneNumber'];
          final userEmail = userDataDoc['email'];
          final userUuid = userDataDoc['uuid'];
          final userImage = userDataDoc['imagePath'];
          debugPrint("Userrr IDDD:$userUuid");

          setState(() {
            _userName = userName;
            _userEmail = userEmail;
            _userPhoneNumber = userPhoneNumber;
            _userUuid = userUuid;
            _userImage = userImage;
          });
        } else {
          debugPrint("User data document does not exist.");
        }
      } else {
        debugPrint("User document does not exist.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Profile',
        ),
        // actions: <Widget>[
        //   IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35.0),
        child: ListView(
          children: [
            ProfileWidget(
              imagePath: _userImage ?? '',
            ),
            const SizedBox(height: 28),
            buildName(_userName, _userPhoneNumber, _userEmail),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0),
              child: ButtonWidget(
                text: 'View My Profile',
                onClicked: () async {
                  final userDoc = await FirebaseFirestore.instance
                      .collection('Authentication')
                      .doc(_userUuid)
                      .get();

                  if (userDoc.exists) {
                    final userRole = userDoc['role'];
                    // Retrieve user role from Firestore
                    debugPrint('userRole:$userRole');

                    // ignore: use_build_context_synchronously
                    final updatedUser = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          if (userRole == 'parents') {
                            return ParentFullProfile(uuid: _userUuid);
                          } else if (userRole == 'babysitter') {
                            return BabysitterFullProfile(uuid: _userUuid);
                          } else if (userRole == 'childcarecentres') {
                            return ChildcareFullProfile(uuid: _userUuid);
                          }
                          return Container(); // Return a dummy widget as a fallback
                        },
                      ),
                    );

                    if (updatedUser != null) {
                      setState(() {
                        _userName = updatedUser.name;
                        _userEmail = updatedUser.email;
                        _userPhoneNumber = updatedUser.phoneNumber;
                      });
                    }
                  } else {
                    debugPrint("User document does not exist.");
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0),
              child: ButtonWidget(
                text: 'Log Out',
                onClicked: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    await SharedPreferencesHelper.logOut();
                    // Navigate to the sign-in page
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const SignIn(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  } catch (e) {
                    // Handle log-out error
                    debugPrint("Log Out Error: $e");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildName(String userName, String userPhoneNumber, String userEmail) =>
      Column(
        children: [
          Text(
            userName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 20),
          Text.rich(
            TextSpan(
              children: [
                const WidgetSpan(
                  child: Icon(
                    Icons.email,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
                TextSpan(
                  text: userEmail,
                  style: const TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text.rich(
            TextSpan(
              children: [
                const WidgetSpan(
                  child: Icon(
                    Icons.phone,
                    size: 18,
                    color: Colors.grey,
                  ),
                ),
                TextSpan(
                  text: userPhoneNumber,
                  style: const TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ],
            ),
          )
        ],
      );
}
