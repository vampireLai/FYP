import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiddie_care_app/model/complaint.dart';
import 'package:kiddie_care_app/widget/filter_chip.dart';
import 'package:uuid/uuid.dart';
import '../model/filterchip_state.dart';
import '../utils/text_controller.dart';
import '../widget/checkbox_grid_widget.dart';

class MakeComplaintDialog extends StatefulWidget {
  final String uuid;
  //receiver uuid

  const MakeComplaintDialog({super.key, required this.uuid});

  @override
  State<MakeComplaintDialog> createState() => _MakeComplaintDialogState();
}

class _MakeComplaintDialogState extends State<MakeComplaintDialog> {
  final TextEditingControllers controllers = TextEditingControllers();
  var reviewPageController = PageController();
  List<String> selectedCheckbox = [];
  bool showError = false;
  bool _isMounted = true;
  String successMessage = '';

  final List<FilterChipState> issueCategoryOptions = [
    FilterChipState(title: 'Abusive'),
    FilterChipState(title: 'Safety Concern'),
    FilterChipState(title: 'Inappropraite Behaviour'),
    FilterChipState(title: 'Not Follow Rules and Guidelines'),
    FilterChipState(title: 'Others'),
  ];

  Future<void> saveComplaint() async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final String uuid = const Uuid().v4(); //add const

    if (controllers.complaintController.text.isEmpty ||
        issueCategoryOptions.every((chipState) => !chipState.isSelected) ||
        selectedCheckbox.isEmpty) {
      setState(() {
        showError = true;
      });
      return;
    }

    try {
      final newComplaint = Complaint(
        senderUuid: currentUserUid,
        receiverUuid: widget.uuid,
        complaint: controllers.complaintController.text,
        issueCategory: issueCategoryOptions
            .where((chipState) => chipState.isSelected)
            .map((chipState) => chipState.title)
            .toList(),
      );

      final newComplaintMap = newComplaint.toMap();

      await FirebaseFirestore.instance
          .collection('complaints')
          .doc(uuid)
          .set(newComplaintMap);

      setState(() {
        successMessage = 'Complaint Created Successfully'; // Set success message
      });

      debugPrint("CREATED New Complaint");
    } catch (e) {
      debugPrint("Error saving complaint to Firestore: $e");
    }
  }

  @override
  void dispose() {
    _isMounted = false; // Set the flag to false when the widget is disposed
    super.dispose();
  }

  void hideDialogAndConfirmation() {
    Navigator.of(context).pop(); // Close the review dialog
    if (successMessage.isNotEmpty) {
      Navigator.of(context).pop(); // Close the confirmation dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          //thanks note
          Container(
            height: max(300, MediaQuery.of(context).size.height * 0.9),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 13.0),
            child: Container(
              child: buildTitle(),
            ),
          ),
          //submit button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.orange,
              child: MaterialButton(
                onPressed: () {
                  setState(() {
                    showError = false; // Show error message
                  });
                  if (controllers.complaintController.text.isEmpty ||
                      issueCategoryOptions
                          .every((chipState) => !chipState.isSelected) ||
                      selectedCheckbox.isEmpty) {
                    setState(() {
                      showError = true; // Show error message
                    });
                    return; // Keep the dialog open
                  }
                  saveComplaint();
                  Future.delayed(const Duration(milliseconds: 2500), () {
                    if (_isMounted) {
                      // Check if the widget is still mounted
                      setState(() {
                        showError = false; // Hide error message after a delay
                      });
                    }
                  });
                   // Display the confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Complaint Created Successfully'),
                        content:
                            const Text('Your complaint has been successfully created.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed:
                                hideDialogAndConfirmation, // Close both dialogs
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                textColor: Colors.white,
                child: const Text('Submit'),
              ),
            ),
          ),
          //skip button
          Positioned(
            right: 0,
            child: MaterialButton(
              onPressed: () {
                hideDialog();
              },
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }

  buildTitle() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Do you want to make a complaint?',
            style: TextStyle(
              fontSize: 20,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(
            color: Colors.orange,
            thickness: 0.8,
          ),
          const SizedBox(height: 8),
          const Text(
            'Issue Category',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          FilterChipWidget(
            chipStates: issueCategoryOptions,
          ),
          const Divider(
            color: Colors.orange,
            thickness: 0.8,
          ),
          const SizedBox(height: 8),
          const Text(
            'Your Complaint',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              maxLines: 3,
              controller: controllers.complaintController,
              decoration: const InputDecoration(
                hintText: 'Leave your complaint here!',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ),
          const SizedBox(height: 4),
          CheckboxGridWidget(
            checkboxTitles: const [
              'I hereby declare that the information provided is true and correct.'
            ],
            onChanged: (title) {
              setState(() {
                if (selectedCheckbox.contains(title)) {
                  selectedCheckbox.remove(title);
                } else {
                  selectedCheckbox.add(title);
                }
              });
            },
          ),
          Visibility(
            visible: showError,
            child: const Text(
              'Please fill in all fields before submitting your complaint.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  hideDialog() {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }
}
