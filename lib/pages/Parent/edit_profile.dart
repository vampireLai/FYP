import 'package:flutter/material.dart';
import 'package:kiddie_care_app/pages/SignIn/sign_in.dart';
import 'package:kiddie_care_app/model/user.dart';
import 'package:kiddie_care_app/widget/checkbox_grid_widget.dart';
import 'package:kiddie_care_app/widget/choice_chip_widget.dart';
import 'package:kiddie_care_app/widget/dropdown_menu_widget.dart';
import 'package:kiddie_care_app/widget/filter_chip.dart';
import 'package:kiddie_care_app/widget/textfield_widget.dart';
import 'package:kiddie_care_app/widget/button_widget.dart';
import 'package:kiddie_care_app/widget/toggle_button_widget.dart';
import '../../model/checkbox_state.dart';
import '../../model/choicechip_state.dart';
import '../../model/filterchip_state.dart';
import '../../utils/text_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../../widget/profile_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfile extends StatefulWidget {
  final String role;
  final String phoneNumber;
  final String email;
  final String firebaseUid;
  final bool isEdit;

  const EditProfile(
      {super.key,
      required this.role,
      required this.phoneNumber,
      required this.email,
      required this.firebaseUid,
      required this.isEdit});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingControllers controllers = TextEditingControllers();
  int selectedGenderIndex = -1;
  String? selectedLocation;
  List<String> selectedDayOfChildcare = [];
  List<String> selectedTimeOfChildcare = [];
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

  final List<FilterChipState> ageOfChildOptions = [
    FilterChipState(title: 'Baby'),
    FilterChipState(title: 'Toddler'),
    FilterChipState(title: 'Preschoolar'),
    FilterChipState(title: 'Gradeschoolar'),
    FilterChipState(title: 'Teenager'),
  ];

  final List<FilterChipState> languageOptions = [
    FilterChipState(title: 'English'),
    FilterChipState(title: 'Mandarin'),
    FilterChipState(title: 'Malay'),
    FilterChipState(title: 'Other'),
  ];

  final List<ChoiceChipState> typeOfCareOptions = [
    ChoiceChipState(title: "Babysitter"),
    ChoiceChipState(title: "Childcare Centre"),
  ];

  final List<ChoiceChipState> locationOptions = [
    ChoiceChipState(title: "At our home"),
    ChoiceChipState(title: "At the childcare's"),
  ];

  final List<CheckBoxState> daysOfChildcareOptions = [
    CheckBoxState(title: 'Weekdays'),
    CheckBoxState(title: 'Weekends'),
  ];

  final List<CheckBoxState> timeOfChildcareOptions = [
    CheckBoxState(title: 'Morning'),
    CheckBoxState(title: 'Afternoon'),
    CheckBoxState(title: 'Evening'),
    CheckBoxState(title: 'Night'),
  ];

  Future<void> saveDataToFirestore() async {
    if (controllers.nameController.text.isEmpty ||
        controllers.aboutController.text.isEmpty ||
        controllers.userIDController.text.isEmpty ||
        controllers.numOfChildController.text.isEmpty ||
        controllers.rateController.text.isEmpty ||
        selectedGenderIndex == -1 || // Assuming -1 means no selection
        selectedLocation == null ||
        typeOfCareOptions.every((chipState) => !chipState.isSelected) ||
        locationOptions.every((chipState) => !chipState.isSelected) ||
        ageOfChildOptions.every((chipState) => !chipState.isSelected) ||
        languageOptions.every((chipState) => !chipState.isSelected) ||
        selectedDayOfChildcare.isEmpty ||
        selectedTimeOfChildcare.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all fields for signing up.')),
      );
      return;
    }

    try {
      final String imagePath = selectedImage != null ? selectedImage!.path : '';
      final newUser = Parent(
          email: widget.email,
          role: widget.role,
          uuid: widget.firebaseUid,
          phoneNumber: widget.phoneNumber,
          imagePath: imagePath, // Assign the imagePath to the newUser
          name: controllers.nameController.text,
          about: controllers.aboutController.text,
          parentID: controllers.userIDController.text,
          numOfChild: int.parse(controllers.numOfChildController.text),
          rate: int.parse(controllers.rateController.text),
          gender: selectedGenderIndex == 0 ? 'Male' : 'Female',
          area: selectedLocation ?? '',
          typeOfCare: typeOfCareOptions
              .firstWhere((chipState) => chipState.isSelected,
                  orElse: () => ChoiceChipState(title: ''))
              .title,
          location: locationOptions
              .firstWhere((chipState) => chipState.isSelected,
                  orElse: () => ChoiceChipState(title: ''))
              .title,
          ageOfChild: ageOfChildOptions
              .where((chipState) => chipState.isSelected)
              .map((chipState) => chipState.title)
              .toList(),
          language: languageOptions
              .where((chipState) => chipState.isSelected)
              .map((chipState) => chipState.title)
              .toList(),
          daysOfChildcare: selectedDayOfChildcare,
          timeOfChildcare: selectedTimeOfChildcare);

      final newUserMap = newUser.toMap();

      if (selectedImage != null) {
        // Upload the image to Firebase Storage
        final storageReference = FirebaseStorage.instance
            .ref()
            .child('parent_images')
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

      // Update Firestore document
      await FirebaseFirestore.instance
          .collection('parents')
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
        controllers.numOfChildController.text.isEmpty ||
        controllers.rateController.text.isEmpty ||
        selectedGenderIndex == -1 ||
        selectedLocation == null ||
        typeOfCareOptions.every((chipState) => !chipState.isSelected) ||
        locationOptions.every((chipState) => !chipState.isSelected) ||
        ageOfChildOptions.every((chipState) => !chipState.isSelected) ||
        languageOptions.every((chipState) => !chipState.isSelected) ||
        selectedDayOfChildcare.isEmpty ||
        selectedTimeOfChildcare.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields for updating profile.'),
        ),
      );
      return;
    }

    try {
      final String imagePath = selectedImage != null ? selectedImage!.path : '';
      final updatedUser = Parent(
        email: widget.email,
        role: widget.role,
        uuid: widget.firebaseUid,
        phoneNumber: widget.phoneNumber,
        imagePath: imagePath, // Assign the imagePath to the newUser
        name: controllers.nameController.text,
        about: controllers.aboutController.text,
        parentID: controllers.userIDController.text,
        numOfChild: int.parse(controllers.numOfChildController.text),
        rate: int.parse(controllers.rateController.text),
        gender: selectedGenderIndex == 0 ? 'Male' : 'Female',
        area: selectedLocation ?? '',
        typeOfCare: typeOfCareOptions
            .firstWhere((chipState) => chipState.isSelected,
                orElse: () => ChoiceChipState(title: ''))
            .title,
        location: locationOptions
            .firstWhere((chipState) => chipState.isSelected,
                orElse: () => ChoiceChipState(title: ''))
            .title,
        ageOfChild: ageOfChildOptions
            .where((chipState) => chipState.isSelected)
            .map((chipState) => chipState.title)
            .toList(),
        language: languageOptions
            .where((chipState) => chipState.isSelected)
            .map((chipState) => chipState.title)
            .toList(),
        daysOfChildcare: selectedDayOfChildcare,
        timeOfChildcare: selectedTimeOfChildcare,
      );

      final updatedUserMap = updatedUser.toMap();

      if (selectedImage != null) {
        // Upload the image to Firebase Storage
        final storageReference = FirebaseStorage.instance
            .ref()
            .child('parent_images')
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
          .collection('parents')
          .doc(
              widget.firebaseUid) // Assuming the document ID is the user's UUID
          .update(updatedUserMap);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(updatedUser); // Close the edit page

      debugPrint('Updated user');
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
                label: 'User Name',
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
                label: 'Parent ID',
                initialText: controllers.userIDController.text,
                controller: controllers.userIDController,
                onChanged: (parentID) {
                  controllers.userIDController.text =
                      parentID; // Update the controller externally
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
              child: Text(
                'Gender',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ToggleSwitchWidget(
                switchNames: const ['Male', 'Female'],
                isGender: true,
                onToggle: (index) {
                  setState(
                    () {
                      selectedGenderIndex = index;
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    label: 'About',
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
                    label: 'Number of children',
                    initialText: controllers.numOfChildController.text,
                    controller: controllers.numOfChildController,
                    onChanged: (numOfChild) {
                      controllers.numOfChildController.text =
                          numOfChild; // Update the controller externally
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
              child: Text(
                'Age of Child',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: FilterChipWidget(
                chipStates: ageOfChildOptions,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFieldWidget(
                label: 'Hourly or Daily rate for childcare',
                initialText: controllers.rateController.text,
                controller: controllers.rateController,
                onChanged: (ratePerHour) {
                  controllers.rateController.text =
                      ratePerHour; // Update the controller externally
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
              child: Text(
                'Type of childcare needed',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ChoiceChipWidget(
                //chipNames: ["Babysitter", "Childcare Centre"],
                chipStates: typeOfCareOptions,
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
                'Language we speak',
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
                'Preferred childcare location',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ChoiceChipWidget(
                chipStates: locationOptions,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
              child: Text(
                'Days we need childcare',
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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
              child: Text(
                'Time we need childcare',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            CheckboxGridWidget(
              checkboxTitles: const [
                'Morning',
                'Afternoon',
                'Evening',
                'Night'
              ],
              onChanged: (title) {
                setState(() {
                  if (selectedTimeOfChildcare.contains(title)) {
                    selectedTimeOfChildcare.remove(title);
                  } else {
                    selectedTimeOfChildcare.add(title);
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
