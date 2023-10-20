import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/saved_person.dart';

class FavouriteIconButton extends StatefulWidget {
  final String uuid;
  final String role;

  const FavouriteIconButton({Key? key, required this.uuid, required this.role})
      : super(key: key);

  @override
  State<FavouriteIconButton> createState() => _FavouriteIconButtonState();
}

class _FavouriteIconButtonState extends State<FavouriteIconButton> {
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    loadFavouriteStatus();
  }

  void loadFavouriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavourite = prefs.getBool(widget.uuid) ?? false;
    });
  }

  void toggleFavouriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavourite = !isFavourite;
      prefs.setBool(widget.uuid, isFavourite);
    });

    // Call the function to update Firestore document
    updateSavedPerson();
  }

  void updateSavedPerson() async {
    try {
      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

      // Check if the document exists in Firestore
      final docSnapshot = await FirebaseFirestore.instance
          .collection('savedPersons')
          .doc(currentUserUid)
          .get();

      if (docSnapshot.exists) {
        // Document exists, update the list in the existing document
        final existingSavedPerson =
            SavedPerson.fromMap(docSnapshot.data() as Map<String, dynamic>);

        // Check the role and update the appropriate list
        if (isFavourite) {
          if (widget.role == 'babysitter') {
            if (!existingSavedPerson.savedBabysitter!.contains(widget.uuid)) {
              existingSavedPerson.savedBabysitter!.add(widget.uuid);
              debugPrint('List: ${existingSavedPerson.savedBabysitter}');
            }
          } else if (widget.role == 'childcarecentres') {
            if (!existingSavedPerson.savedChildcareCentre!
                .contains(widget.uuid)) {
              existingSavedPerson.savedChildcareCentre!.add(widget.uuid);
              debugPrint('List: ${existingSavedPerson.savedChildcareCentre}');
            }
          } else if (widget.role == 'parents') {
            if (!existingSavedPerson.savedParent!.contains(widget.uuid)) {
              existingSavedPerson.savedParent!.add(widget.uuid);
              debugPrint('List: ${existingSavedPerson.savedParent}');
            }
          }
        } else {
          existingSavedPerson.savedBabysitter!.remove(widget.uuid);
          existingSavedPerson.savedChildcareCentre!.remove(widget.uuid);
          existingSavedPerson.savedParent!.remove(widget.uuid);
        }

        // Update Firestore document with the updated list
        await FirebaseFirestore.instance
            .collection('savedPersons')
            .doc(currentUserUid)
            .set(existingSavedPerson.toMap());

        debugPrint("Firestore update successful!");
      } else {
        // Document doesn't exist, create a new document
        if (isFavourite) {
          List<String> savedList = [];
          if (widget.role == 'babysitter') {
            savedList = [widget.uuid];
            final newSavedPerson = SavedPerson(
                senderUuid: currentUserUid, savedBabysitter: savedList);
            await FirebaseFirestore.instance
                .collection('savedPersons')
                .doc(currentUserUid)
                .set(newSavedPerson.toMap());
          } else if (widget.role == 'childcarecentres') {
            savedList = [widget.uuid];
            final newSavedPerson = SavedPerson(
                senderUuid: currentUserUid, savedChildcareCentre: savedList);
            await FirebaseFirestore.instance
                .collection('savedPersons')
                .doc(currentUserUid)
                .set(newSavedPerson.toMap());
          } else if (widget.role == 'parents') {
            savedList = [widget.uuid];
            final newSavedPerson =
                SavedPerson(senderUuid: currentUserUid, savedParent: savedList);
            await FirebaseFirestore.instance
                .collection('savedPersons')
                .doc(currentUserUid)
                .set(newSavedPerson.toMap());
          }
          debugPrint("New Firestore document created!");
        } else {
          debugPrint("Document not created as isFavourite is false.");
        }
      }
    } catch (e) {
      // Handle error
      debugPrint("Firestore Update Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavourite ? Icons.favorite : Icons.favorite_border,
        color: isFavourite ? Colors.red : null,
      ),
      onPressed: toggleFavouriteStatus,
    );
  }
}
