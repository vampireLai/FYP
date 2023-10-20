import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiddie_care_app/model/childcare_centre.dart';
import '../../model/checkbox_state.dart';
import '../../model/filterchip_state.dart';
import '../../utils/text_controller.dart';
import '../../widget/button_widget.dart';
import '../../widget/checkbox_grid_widget.dart';
import '../../widget/dropdown_menu_widget.dart';
import '../../widget/filter_chip.dart';
import '../../widget/profile_widget.dart';
import '../../widget/textfield_widget.dart';
import '../SignIn/sign_in.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class EditChildcareProfile extends StatefulWidget {
  final String role;
  final String phoneNumber;
  final String email;
  final String firebaseUid;
  final bool isEdit;

  const EditChildcareProfile(
      {super.key,
      required this.role,
      required this.phoneNumber,
      required this.email,
      required this.firebaseUid,
      required this.isEdit});

  @override
  State<EditChildcareProfile> createState() => _EditChildcareProfileState();
}

class _EditChildcareProfileState extends State<EditChildcareProfile> {
  final TextEditingControllers controllers = TextEditingControllers();
  String? selectedLocation; //area
  List<String> selectedDayOfChildcare = [];
  File? selectedImage;

  late String email;
  late String firebaseUid;
  late String phoneNumber;
  late String role;

  @override
  void initState() {
    super.initState();
    email = widget.email;
    firebaseUid = widget.firebaseUid;
    phoneNumber = widget.phoneNumber;
    role = widget.role;
  }

  final List<FilterChipState> languageOptions = [
    FilterChipState(title: 'English'),
    FilterChipState(title: 'Mandarin'),
    FilterChipState(title: 'Malay'),
    FilterChipState(title: 'Other'),
  ];

  final List<FilterChipState> experienceOfageOptions = [
    FilterChipState(title: 'Baby'),
    FilterChipState(title: 'Toddler'),
    FilterChipState(title: 'Preschoolar'),
  ];

  final List<FilterChipState> activitiesOptions = [
    FilterChipState(title: 'Homework'),
    FilterChipState(title: 'Revision'),
    FilterChipState(title: 'Nap'),
    FilterChipState(title: 'Food'),
    FilterChipState(title: 'Story Time'),
    FilterChipState(title: 'Other'),
  ];

  final List<CheckBoxState> daysOfChildcareOptions = [
    CheckBoxState(title: 'Weekdays'),
    CheckBoxState(title: 'Weekends'),
  ];

  Future<void> saveDataToFirestore() async {
    if (controllers.nameController.text.isEmpty ||
        controllers.aboutController.text.isEmpty ||
        controllers.userIDController.text.isEmpty ||
        controllers.addressController.text.isEmpty ||
        controllers.operatingYearController.text.isEmpty ||
        controllers.rateController.text.isEmpty ||
        selectedLocation == null ||
        experienceOfageOptions.every((chipState) => !chipState.isSelected) ||
        activitiesOptions.every((chipState) => !chipState.isSelected) ||
        languageOptions.every((chipState) => !chipState.isSelected) ||
        selectedDayOfChildcare.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all fields for signing up.')),
      );
      return;
    }

    try {
      final String imagePath = selectedImage != null ? selectedImage!.path : '';
      final newUser = ChildcareCentre(
        email: widget.email,
        role: widget.role,
        uuid: widget.firebaseUid,
        phoneNumber: widget.phoneNumber,
        imagePath: imagePath,
        name: controllers.nameController.text,
        about: controllers.aboutController.text,
        address: controllers.addressController.text,
        childcareID: controllers.userIDController.text,
        yearOfOperating: int.parse(controllers.operatingYearController.text),
        rate: int.parse(controllers.rateController.text),
        area: selectedLocation ?? '',
        experienceOfage: experienceOfageOptions
            .where((chipState) => chipState.isSelected)
            .map((chipState) => chipState.title)
            .toList(),
        childcareProgramme: activitiesOptions
            .where((chipState) => chipState.isSelected)
            .map((chipState) => chipState.title)
            .toList(),
        language: languageOptions
            .where((chipState) => chipState.isSelected)
            .map((chipState) => chipState.title)
            .toList(),
        daysOfChildcare: selectedDayOfChildcare,
      );

      final newUserMap = newUser.toMap();

      if (selectedImage != null) {
        // Upload the image to Firebase Storage
        final storageReference = FirebaseStorage.instance
            .ref()
            .child('childcare_images')
            .child(widget.firebaseUid);

        final uploadTask = storageReference.putFile(selectedImage!);
        await uploadTask.whenComplete(() {
          debugPrint("Image uploaded to storage");
        });

        // Get the download URL of the uploaded image
        final imageUrl = await storageReference.getDownloadURL();

        // Update newUserMap with the image URL
        newUserMap['imagePath'] = imageUrl;
      }

      await FirebaseFirestore.instance
          .collection('childcarecentres')
          .doc(widget.firebaseUid)
          .set(newUserMap);

      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: ((context) => const SignIn()),
        ),
      );

      debugPrint('User Created');
    } catch (e) {
      debugPrint("Error saving data to Firestore: $e");
    }
  }

  Future<void> updateDataInFirestore() async {
    if (controllers.nameController.text.isEmpty ||
        controllers.aboutController.text.isEmpty ||
        controllers.userIDController.text.isEmpty ||
        controllers.addressController.text.isEmpty ||
        controllers.operatingYearController.text.isEmpty ||
        controllers.rateController.text.isEmpty ||
        selectedLocation == null ||
        experienceOfageOptions.every((chipState) => !chipState.isSelected) ||
        activitiesOptions.every((chipState) => !chipState.isSelected) ||
        languageOptions.every((chipState) => !chipState.isSelected) ||
        selectedDayOfChildcare.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields for updating profile.'),
        ),
      );
      return;
    }

    try {
      final String imagePath = selectedImage != null ? selectedImage!.path : '';
      final updatedUser = ChildcareCentre(
        email: widget.email,
        role: widget.role,
        uuid: widget.firebaseUid,
        phoneNumber: widget.phoneNumber,
        imagePath: imagePath,
        name: controllers.nameController.text,
        about: controllers.aboutController.text,
        address: controllers.addressController.text,
        childcareID: controllers.userIDController.text,
        yearOfOperating: int.parse(controllers.operatingYearController.text),
        rate: int.parse(controllers.rateController.text),
        area: selectedLocation ?? '',
        experienceOfage: experienceOfageOptions
            .where((chipState) => chipState.isSelected)
            .map((chipState) => chipState.title)
            .toList(),
        childcareProgramme: activitiesOptions
            .where((chipState) => chipState.isSelected)
            .map((chipState) => chipState.title)
            .toList(),
        language: languageOptions
            .where((chipState) => chipState.isSelected)
            .map((chipState) => chipState.title)
            .toList(),
        daysOfChildcare: selectedDayOfChildcare,
      );

      final updatedUserMap = updatedUser.toMap();

      if (selectedImage != null) {
        // Upload the image to Firebase Storage
        final storageReference = FirebaseStorage.instance
            .ref()
            .child('childcare_images')
            .child(widget.firebaseUid);

        final uploadTask = storageReference.putFile(selectedImage!);
        await uploadTask.whenComplete(() {
          debugPrint("Image uploaded to storage");
        });

        // Get the download URL of the uploaded image
        final imageUrl = await storageReference.getDownloadURL();

        // Update newUserMap with the image URL
        updatedUserMap['imagePath'] = imageUrl;
      }

      await FirebaseFirestore.instance
          .collection('childcarecentres')
          .doc(
              widget.firebaseUid) // Assuming the document ID is the user's UUID
          .update(updatedUserMap);
      
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(updatedUser); // Close the edit page

      debugPrint('Updated User');
    } catch (e) {
      debugPrint("Error updating data in Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Edit Profile',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35.0),
        child: ListView(
          children: [
            ProfileWidget(
              imagePath: selectedImage != null ? selectedImage!.path : null,
              isEdit: true,
              onClicked: (pickedImage) {
                setState(() {
                  selectedImage = pickedImage;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFieldWidget(
                label: 'Childcare Centre Name',
                initialText: controllers.nameController.text,
                controller: controllers.nameController,
                onChanged: (name) {
                  controllers.nameController.text =
                      name; // Update the controller externally
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFieldWidget(
                label: 'Childcare Centre ID',
                initialText: controllers.userIDController.text,
                controller: controllers.userIDController,
                onChanged: (childcareID) {
                  controllers.userIDController.text =
                      childcareID; // Update the controller externally
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    label: 'About us',
                    maxLines: 5,
                    initialText: controllers.aboutController.text,
                    controller: controllers.aboutController,
                    onChanged: (about) {
                      controllers.aboutController.text =
                          about; // Update the controller externally
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    label: 'Address',
                    maxLines: 3,
                    initialText: controllers.addressController.text,
                    controller: controllers.addressController,
                    onChanged: (address) {
                      controllers.addressController.text =
                          address; // Update the controller externally
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    label: 'Year of Operating',
                    initialText: controllers.operatingYearController.text,
                    controller: controllers.operatingYearController,
                    onChanged: (year) {
                      controllers.operatingYearController.text =
                          year; // Update the controller externally
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
              child: Text(
                'Experience of Child (age)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: FilterChipWidget(
                chipStates: experienceOfageOptions,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
              child: Text(
                'Activities Included',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: FilterChipWidget(
                chipStates: activitiesOptions,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFieldWidget(
                label: 'Daily rate for childcare',
                initialText: controllers.rateController.text,
                controller: controllers.rateController,
                onChanged: (ratePerHour) {
                  controllers.rateController.text =
                      ratePerHour; // Update the controller externally
                },
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
              child: Text(
                'Select Area',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: DropdownMenuWidget(
                menuNames: const [
                  'Kuala Lumpur',
                  'Perak',
                  'Johor',
                  'Kedah',
                  'Kelantan',
                  'Labuan',
                  'Melaka',
                  'Negeri Sembilan',
                  'Pahang',
                  'Penang',
                  'Putrajaya',
                  'Sabah',
                  'Sarawak',
                  'Selangor',
                  'Terengganu'
                ],
                onChanged: (value) {
                  setState(() {
                    selectedLocation = value;
                    debugPrint('Dropdown Value Changed: $selectedLocation');
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
              child: Text(
                'Language I speak',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: FilterChipWidget(
                chipStates: languageOptions,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
              child: Text(
                'Days provide childcare',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            CheckboxGridWidget(
              checkboxTitles: const ['Weekdays', 'Weekends'],
              onChanged: (title) {
                setState(() {
                  if (selectedDayOfChildcare.contains(title)) {
                    selectedDayOfChildcare.remove(title);
                  } else {
                    selectedDayOfChildcare.add(title);
                  }
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 130.0),
              child: ButtonWidget(
                text: widget.isEdit ? 'Update' : 'Sign Up',
                onClicked: () {
                  widget.isEdit
                      ? updateDataInFirestore()
                      : saveDataToFirestore();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
