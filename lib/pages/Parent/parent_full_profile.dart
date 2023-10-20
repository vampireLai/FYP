import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiddie_care_app/model/user.dart';
import 'package:kiddie_care_app/pages/Parent/buildabout_full.dart';
import 'package:kiddie_care_app/pages/Parent/edit_profile.dart';
import 'package:kiddie_care_app/widget/profile_widget.dart';
import '../../utils/text_controller.dart';

// ignore: must_be_immutable
class ParentFullProfile extends StatefulWidget {
  String uuid; //current user uuid

  ParentFullProfile({super.key, required this.uuid});

  @override
  State<ParentFullProfile> createState() => _ParentFullProfileState();
}

class _ParentFullProfileState extends State<ParentFullProfile> {
  Parent? parent;
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
    fetchParentInfo();
  }

  Future<void> fetchParentInfo() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('parents')
          .where('uuid', isEqualTo: widget.uuid)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final item = snapshot.docs[0].data() as Map<String, dynamic>;
        setState(() {
          parent = Parent.fromMap(item);
          email = parent!.email;
          phoneNumber = parent!.phoneNumber;
          role = parent!.role;
          firebaseUid = parent!.uuid;
          image = parent!.imagePath!;
        });
      }
    } catch (e) {
      debugPrint("ERROR");
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
            Navigator.of(context).pop(parent); // Pass the updated parent here
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedUser = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) => EditProfile(
                        isEdit: true,
                        email: email,
                        firebaseUid: firebaseUid,
                        phoneNumber: phoneNumber,
                        role: role,
                      )),
                ),
              );

              if (updatedUser != null && updatedUser is Parent) {
                // debugPrint(
                //     "Received updated user: ${updatedUser.toString()}"); // Add this line
                setState(() {
                  parent = updatedUser;
                  email = parent?.email ?? '';
                  phoneNumber = parent?.phoneNumber ?? '';
                  name = parent?.name ?? '';
                  image = parent?.imagePath ?? '';
                });
                // debugPrint(
                //     "Updated parent: ${parent.toString()}"); // Add this line
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35.0),
        child: ListView(
          children: [
            if (parent != null)
              ProfileWidget(imagePath: parent!.imagePath, isEdit: false),
            const SizedBox(height: 15),
            if (parent != null) BuildAboutWidget(user: parent!),
          ],
        ),
      ),
    );
  }
}
