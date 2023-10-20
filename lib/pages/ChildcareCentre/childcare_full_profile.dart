import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiddie_care_app/model/childcare_centre.dart';
import 'package:kiddie_care_app/widget/profile_widget.dart';
import '../../utils/text_controller.dart';
import 'buildabout_childcare.dart';
import 'edit_childcare_profile.dart';

// ignore: must_be_immutable
class ChildcareFullProfile extends StatefulWidget {
  String uuid; //current user uuid

  ChildcareFullProfile({super.key, required this.uuid});

  @override
  State<ChildcareFullProfile> createState() => _ChildcareFullProfileState();
}

class _ChildcareFullProfileState extends State<ChildcareFullProfile> {
  ChildcareCentre? childcareCentre;
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
    fetchChildcareInfo();
  }

  Future<void> fetchChildcareInfo() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('childcarecentres')
          .where('uuid', isEqualTo: widget.uuid)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final item = snapshot.docs[0].data() as Map<String, dynamic>;
        setState(() {
          childcareCentre = ChildcareCentre.fromMap(item);
          email = childcareCentre!.email;
          phoneNumber = childcareCentre!.phoneNumber;
          role = childcareCentre!.role;
          firebaseUid = childcareCentre!.uuid;
          image = childcareCentre!.imagePath!;
        });
      }
    } catch (e) {
      debugPrint('path:$image');
      debugPrint('email:$email');
      debugPrint('phonenumber:$phoneNumber');
      debugPrint('role:$role');
      debugPrint('firebaseUid:$firebaseUid');
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
                .pop(childcareCentre); // Pass the updated parent here
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedUser = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) => EditChildcareProfile(
                        isEdit: true,
                        email: email,
                        firebaseUid: firebaseUid,
                        phoneNumber: phoneNumber,
                        role: role,
                      )),
                ),
              );

              if (updatedUser != null && updatedUser is ChildcareCentre) {
                debugPrint(
                    "Received updated user: ${updatedUser.toString()}"); // Add this line
                setState(() {
                  childcareCentre = updatedUser;
                  email = childcareCentre!.email;
                  phoneNumber = childcareCentre!.phoneNumber;
                  name = childcareCentre!.name;
                  //image = childcareCentre!.imagePath!;
                });
                debugPrint(
                    "Updated childcare: ${childcareCentre.toString()}"); // Add this line
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35.0),
        child: ListView(
          children: [
             if (childcareCentre != null) ProfileWidget(
              imagePath: childcareCentre != null ? childcareCentre!.imagePath : '',
              isEdit: false,
            ),
            const SizedBox(height: 15),
            if (childcareCentre != null) BuildChildcareAbout(user: childcareCentre!)
          ],
        ),
      ),
    );
  }
}
