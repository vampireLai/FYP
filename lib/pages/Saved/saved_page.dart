import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../model/saved_person.dart';
import '../../widget/babysitter_card_widget.dart';
import '../../widget/childcarecentre_card.dart';
import '../../widget/parent_card_widget.dart';

class SavePerson extends StatefulWidget {
  const SavePerson({super.key});

  @override
  _SavePersonState createState() => _SavePersonState();
}

class _SavePersonState extends State<SavePerson> {
  List<String> savedBabysitterList = [];
  List<String> savedChildcareCenterList = [];
  List<String> savedParentList = [];

  // @override
  // void initState() {
  //   super.initState();
  //   loadData();
  // }

  // void loadData() async {
  //   try {
  //     final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  //     final docSnapshot = await FirebaseFirestore.instance
  //         .collection('savedPersons')
  //         .doc(currentUserUid)
  //         .get();

  //     if (docSnapshot.exists) {
  //       final savedPerson =
  //           SavedPerson.fromMap(docSnapshot.data() as Map<String, dynamic>);
  //       savedBabysitterList = savedPerson.savedBabysitter!;
  //       savedChildcareCenterList = savedPerson.savedChildcareCentre!;
  //       savedParentList = savedPerson.savedParent!;
  //       setState(() {});
  //     }
  //   } catch (e) {
  //     // Handle error
  //     debugPrint("Firestore Load Data Error: $e");
  //   }
  // }

  @override
void initState() {
  super.initState();
  loadSavedData();

  // Create snapshot listeners for each list
  listenToSavedPersons();
}

void listenToSavedPersons() {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  final savedPersonsRef = FirebaseFirestore.instance.collection('savedPersons');

  savedPersonsRef.doc(currentUserUid).snapshots().listen((docSnapshot) {
    if (docSnapshot.exists) {
      final savedPerson = SavedPerson.fromMap(docSnapshot.data() as Map<String, dynamic>);
      setState(() {
        savedBabysitterList = savedPerson.savedBabysitter!;
        savedChildcareCenterList = savedPerson.savedChildcareCentre!;
        savedParentList = savedPerson.savedParent!;
      });
    } else {
      // Handle the case when the document is deleted (person removed from saved list)
      setState(() {
        savedBabysitterList = [];
        savedChildcareCenterList = [];
        savedParentList = [];
      });
    }
  });
}

void loadSavedData() async {
  try {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final docSnapshot = await FirebaseFirestore.instance
        .collection('savedPersons')
        .doc(currentUserUid)
        .get();

    if (docSnapshot.exists) {
      final savedPerson =
          SavedPerson.fromMap(docSnapshot.data() as Map<String, dynamic>);
      savedBabysitterList = savedPerson.savedBabysitter!;
      savedChildcareCenterList = savedPerson.savedChildcareCentre!;
      savedParentList = savedPerson.savedParent!;
      setState(() {});
    }
  } catch (e) {
    // Handle error
    debugPrint("Firestore Load Data Error: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Saved',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const ListTile(
              title: Text(
                'Saved Profiles',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: savedBabysitterList.length +
                    savedChildcareCenterList.length +
                    savedParentList.length,
                itemBuilder: (context, index) {
                  if (index < savedBabysitterList.length) {
                    return BabysitterCardWidget(
                      uuid: savedBabysitterList[index],
                      role: 'babysitter',
                    );
                  } else if (index <
                      savedBabysitterList.length +
                          savedChildcareCenterList.length) {
                    final childcareCenterIndex =
                        index - savedBabysitterList.length;
                    return ChildcareCentreCardWidget(
                      uuid: savedChildcareCenterList[childcareCenterIndex],
                      role: 'childcarecentres',
                    );
                  } else {
                    final parentIndex = index -
                        (savedBabysitterList.length +
                            savedChildcareCenterList.length);
                    return ParentCardWidget(
                      uuid: savedParentList[parentIndex],
                      role: 'parents',
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
