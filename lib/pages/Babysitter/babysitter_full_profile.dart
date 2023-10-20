import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiddie_care_app/model/babysitter.dart';
import 'package:kiddie_care_app/widget/profile_widget.dart';
import '../../utils/text_controller.dart';
import 'buildabout_babysitter.dart';
import 'edit_babysitter_profile.dart';

// ignore: must_be_immutable
class BabysitterFullProfile extends StatefulWidget {
  String uuid; //current user uuid

  BabysitterFullProfile({super.key, required this.uuid});

  @override
  State<BabysitterFullProfile> createState() => _BabysitterFullProfileState();
}

class _BabysitterFullProfileState extends State<BabysitterFullProfile> {
  Babysitter? babysitter; //babysitter?
  bool isEdit = false;
  String email = '';
  String firebaseUid = '';
  String phoneNumber = '';
  String role = '';
  String name = '';
  String image = '';

  final TextEditingControllers controllers = TextEditingControllers();

  @override
  void initState() {
    super.initState();
    fetchBabysitterInfo();
  }

  Future<void> fetchBabysitterInfo() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('babysitter')
          .where('uuid', isEqualTo: widget.uuid)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final item = snapshot.docs[0].data() as Map<String, dynamic>;
        setState(() {
          babysitter = Babysitter.fromMap(item);
          email = babysitter!.email;
          phoneNumber = babysitter!.phoneNumber;
          role = babysitter!.role;
          firebaseUid = babysitter!.uuid;
          image = babysitter!.imagePath!;
        });
      }
    } catch (e) {
      debugPrint("ERRORRRRR");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Profile',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pop(babysitter); // Pass the updated parent here
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedUser = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) => EditBabysitterProfile(
                        isEdit: true,
                        email: email,
                        firebaseUid: firebaseUid,
                        phoneNumber: phoneNumber,
                        role: role,
                      )),
                ),
              );

              if (updatedUser != null && updatedUser is Babysitter) {
                debugPrint(
                    "Received updated user: ${updatedUser.toString()}"); // Add this line
                setState(() {
                  babysitter = updatedUser;
                  email = babysitter!.email;
                  phoneNumber = babysitter!.phoneNumber;
                  name = babysitter!.name;
                  image = babysitter!.imagePath!;
                });
                debugPrint(
                    "Updated parent: ${babysitter.toString()}"); // Add this line
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35.0),
        child: ListView(
          children: [
            if (babysitter != null) ProfileWidget(imagePath: babysitter != null ? babysitter!.imagePath : '',
              isEdit: false,
            ),
            const SizedBox(height: 15),
            if (babysitter != null) BuildBabysitterAbout(user: babysitter!)
          ],
        ),
      ),
    );
  }
}
