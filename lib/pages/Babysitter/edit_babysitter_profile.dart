import 'package:flutter/material.dart';
import 'package:kiddie_care_app/model/babysitter.dart';
import 'package:kiddie_care_app/pages/SignIn/sign_in.dart';
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
import 'package:firebase_storage/firebase_storage.dart';
import '../../widget/profile_widget.dart';

class EditBabysitterProfile extends StatefulWidget {
  final String role;
  final String phoneNumber;
  final String email;
  final String firebaseUid;
  final bool isEdit;

  const EditBabysitterProfile(
      {super.key,
      required this.role,
      required this.phoneNumber,
      required this.email,
      required this.firebaseUid,
      required this.isEdit});

  @override
  State<EditBabysitterProfile> createState() => _EditBabysitterProfileState();
}

class _EditBabysitterProfileState extends State<EditBabysitterProfile> {
  final TextEditingControllers controllers = TextEditingControllers();
  int selectedGenderIndex = -1;
  String? selectedLocation;
  List<String> selectedDayOfChildcare = [];
  List<String> selectedTimeOfChildcare = [];
  List<String> experienceOfage = [];
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

  final List<FilterChipState> experienceOfageOptions = [
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
        controllers.ageController.text.isEmpty ||
        controllers.rateController.text.isEmpty ||
        controllers.experienceController.text.isEmpty ||
        selectedGenderIndex == -1 || // Assuming -1 means no selection
        selectedLocation == null ||
        experienceOfageOptions.every((chipState) => !chipState.isSelected) ||
        locationOptions.every((chipState) => !chipState.isSelected) ||
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
      final newUser = Babysitter(
          email: widget.email,
          role: widget.role,
          uuid: widget.firebaseUid,
          phoneNumber: widget.phoneNumber,
          imagePath: imagePath,
          name: controllers.nameController.text,
          about: controllers.aboutController.text,
          babysitterID: controllers.userIDController.text,
          age: int.parse(controllers.ageController.text),
          experience: int.parse(controllers.experienceController.text),
          rate: int.parse(controllers.rateController.text),
          gender: selectedGenderIndex == 0 ? 'Male' : 'Female',
          area: selectedLocation ?? '',
          experienceOfage: experienceOfageOptions
              .where((chipState) => chipState.isSelected)
              .map((chipState) => chipState.title)
              .toList(),
          location: locationOptions
              .firstWhere((chipState) => chipState.isSelected,
                  orElse: () => ChoiceChipState(title: ''))
              .title,
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
            .child('babysitter_images')
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
          .collection('babysitter')
          .doc(widget.firebaseUid)
          .set(newUserMap);

      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: ((context) => const SignIn()),
        ),
      );

      debugPrint('Created User');
    } catch (e) {
      debugPrint("Error saving data to Firestore: $e");
    }
  }

  Future<void> updateDataInFirestore() async {
    if (controllers.nameController.text.isEmpty ||
        controllers.aboutController.text.isEmpty ||
        controllers.userIDController.text.isEmpty ||
        controllers.ageController.text.isEmpty ||
        controllers.experienceController.text.isEmpty ||
        controllers.rateController.text.isEmpty ||
        selectedGenderIndex == -1 ||
        selectedLocation == null ||
        locationOptions.every((chipState) => !chipState.isSelected) ||
        experienceOfageOptions.every((chipState) => !chipState.isSelected) ||
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
      final updatedUser = Babysitter(
        email: widget.email,
        role: widget.role,
        uuid: widget.firebaseUid,
        phoneNumber: widget.phoneNumber,
        imagePath: imagePath,
        name: controllers.nameController.text,
        about: controllers.aboutController.text,
        babysitterID: controllers.userIDController.text,
        age: int.parse(controllers.ageController.text),
        rate: int.parse(controllers.rateController.text),
        experience: int.parse(controllers.experienceController.text),
        gender: selectedGenderIndex == 0 ? 'Male' : 'Female',
        area: selectedLocation ?? '',
        location: locationOptions
            .firstWhere((chipState) => chipState.isSelected,
                orElse: () => ChoiceChipState(title: ''))
            .title,
        experienceOfage: experienceOfageOptions
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
            .child('babysitter_images')
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
          .collection('babysitter')
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
                label: 'Babysitter ID',
                initialText: controllers.userIDController.text,
                controller: controllers.userIDController,
                onChanged: (babsyitterID) {
                  controllers.userIDController.text =
                      babsyitterID; // Update the controller externally
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
                    label: 'Age',
                    initialText: controllers.ageController.text,
                    controller: controllers.ageController,
                    onChanged: (age) {
                      controllers.ageController.text =
                          age; // Update the controller externally
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFieldWidget(
                label: 'Hourly rate for childcare',
                initialText: controllers.rateController.text,
                controller: controllers.rateController,
                onChanged: (ratePerHour) {
                  controllers.rateController.text =
                      ratePerHour; // Update the controller externally
                },
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFieldWidget(
                label: 'year of experience',
                initialText: controllers.experienceController.text,
                controller: controllers.experienceController,
                onChanged: (experience) {
                  controllers.experienceController.text =
                      experience; // Update the controller externally
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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
              child: Text(
                'Time provide childcare',
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
