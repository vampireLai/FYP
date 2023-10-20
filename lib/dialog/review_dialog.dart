import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiddie_care_app/model/review.dart';
import '../../utils/text_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ReviewDialog extends StatefulWidget {
  final String uuid; //receiver uuid

  const ReviewDialog({super.key, required this.uuid});

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  final TextEditingControllers controllers = TextEditingControllers();
  bool showError = false;
  bool _isMounted = true;
  var reviewPageController = PageController();
  var rating = 0;
  String successMessage = '';

  Future<void> saveReview() async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final String uuid = Uuid().v4();

    if (controllers.reviewController.text.isEmpty || rating == 0) {
      setState(() {
        showError = true;
      });
      return;
    }

    try {
      final newReview = Review(
          senderUuid: currentUserUid,
          receiverUuid: widget.uuid,
          review: controllers.reviewController.text,
          rating: rating.toDouble());

      final newReviewMap = newReview.toMap();

      await FirebaseFirestore.instance
          .collection('reviews')
          .doc(uuid)
          .set(newReviewMap);

      setState(() {
        successMessage = 'Review Created Successfully'; // Set success message
      });

      debugPrint("CREATE New Review");
    } catch (e) {
      debugPrint("Error saving review to Firestore: $e");
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
          Container(
            height: max(300, MediaQuery.of(context).size.height * 0.48),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Container(
              child: buildReview(),
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
                    showError = false; // Reset error message
                  });
                  // Check if the conditions for showing an error are met
                  if (controllers.reviewController.text.isEmpty ||
                      rating == 0) {
                    setState(() {
                      showError = true; // Show error message
                    });
                    return; // Keep the dialog open
                  }
                  // If conditions are not met, proceed to save the review and hide the dialog
                  saveReview();
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
                        title: const Text('Review Created Successfully'),
                        content:
                            const Text('Your review has been successfully created.'),
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
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: index < rating
                      ? const Icon(Icons.star, size: 32)
                      : const Icon(
                          Icons.star_border,
                          size: 32,
                        ),
                  color: Colors.orange,
                  onPressed: () {
                    setState(() {
                      //user rating
                      rating = index + 1;
                    });
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 250,
            left: 0,
            right: 0,
            child: Visibility(
              visible: showError,
              child: const Text(
                'Please fill in all fields before submitting your complaint.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildReview() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Start rating and share your review with others!',
          style: TextStyle(
            fontSize: 20,
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            maxLines: 3,
            controller: controllers.reviewController,
            decoration: const InputDecoration(
              hintText: 'Leave your review here!',
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              border: InputBorder.none,
              alignLabelWithHint: true,
            ),
          ),
        ),
      ],
    );
  }

  hideDialog() {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }
}
