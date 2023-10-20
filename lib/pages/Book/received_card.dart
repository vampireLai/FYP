import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../model/bookperson.dart';

class ReceivedBookingCardWidget extends StatefulWidget {
  final String uuid; //sender

  const ReceivedBookingCardWidget({
    super.key,
    required this.uuid,
  });

  @override
  State<ReceivedBookingCardWidget> createState() =>
      _ReceivedBookingCardWidgetState();
}

class _ReceivedBookingCardWidgetState extends State<ReceivedBookingCardWidget> {
  String _userName = '';
  String _userImage = '';
  String _userAbout = '';
  String _userUuid = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> updateBookingStatusToAccept() async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    try {
      // Update 'booklists' collection
      final bookingListRef = FirebaseFirestore.instance
          .collection('booklists')
          .doc(widget.uuid); // sender uuid
      final bookingListDoc = await bookingListRef.get();

      if (bookingListDoc.exists) {
        final data = bookingListDoc.data() as Map<String, dynamic>;
        final bookedPersonListData = data['bookedPersonList'] as List<dynamic>;
        final bookedPersonList = bookedPersonListData
            .map((item) => BookPerson(
                  receiverUuid: item['receiverUuid'] as String,
                  senderUuid: item['senderUuid'] as String,
                  status: item['status'] as String,
                ))
            .toList();

        // Find the specific bookedPerson item you want to update
        // current logged-in user
        final indexToUpdate = bookedPersonList.indexWhere((bookedPerson) =>
            bookedPerson.receiverUuid == currentUserUid &&
            bookedPerson.status == 'pending');

        if (indexToUpdate != -1) {
          // Update the status to 'accept' for the found bookedPerson
          bookedPersonList[indexToUpdate].status = 'accept';

          // Replace the entire bookedPersonList in Firestore with the modified list
          await bookingListRef.update({
            'bookedPersonList': bookedPersonList
                .map((bookedPerson) => bookedPerson.toMap())
                .toList(),
          });

          debugPrint(
              'Updated status to accept for document: ${bookingListRef.id}');
        }
      } else {
        debugPrint('Document not exists in booklists');
      }

      // Update 'bookedperson' collection
      final bookedPersonRef =
          FirebaseFirestore.instance.collection('bookedperson');
      final bookedPersonQuerySnapshot = await bookedPersonRef
          .where('receiverUuid', isEqualTo: currentUserUid)
          .where('senderUuid', isEqualTo: widget.uuid)
          .where('status', isEqualTo: 'pending')
          .get();

      if (bookedPersonQuerySnapshot.docs.isNotEmpty) {
        for (final bookedPersonDoc in bookedPersonQuerySnapshot.docs) {
          await bookedPersonDoc.reference.update({'status': 'accept'});
          debugPrint(
              'Updated status to accept for bookedperson document: ${bookedPersonDoc.id}');
        }
      }
    } catch (e) {
      debugPrint('Error updating booking status to accept: $e');
    }
  }

  Future<void> updateBookingStatusToDecline() async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    try {
      // Update 'booklists' collection
      final bookingListRef = FirebaseFirestore.instance
          .collection('booklists')
          .doc(widget.uuid); // sender uuid
      final bookingListDoc = await bookingListRef.get();

      if (bookingListDoc.exists) {
        final data = bookingListDoc.data() as Map<String, dynamic>;
        final bookedPersonListData = data['bookedPersonList'] as List<dynamic>;
        final bookedPersonList = bookedPersonListData
            .map((item) => BookPerson(
                  receiverUuid: item['receiverUuid'] as String,
                  senderUuid: item['senderUuid'] as String,
                  status: item['status'] as String,
                ))
            .toList();

        // Find the specific bookedPerson item you want to update
        // current logged-in user
        final indexToUpdate = bookedPersonList.indexWhere((bookedPerson) =>
            bookedPerson.receiverUuid == currentUserUid &&
            bookedPerson.status == 'pending');

        if (indexToUpdate != -1) {
          // Update the status to 'decline' for the found bookedPerson
          bookedPersonList[indexToUpdate].status = 'decline';

          // Replace the entire bookedPersonList in Firestore with the modified list
          await bookingListRef.update({
            'bookedPersonList': bookedPersonList
                .map((bookedPerson) => bookedPerson.toMap())
                .toList(),
          });

          debugPrint(
              'Updated status to decline for document: ${bookingListRef.id}');
        }
      } else {
        debugPrint('Document not exists in booklists');
      }

      // Update 'bookedperson' collection
      final bookedPersonRef =
          FirebaseFirestore.instance.collection('bookedperson');
      final bookedPersonQuerySnapshot = await bookedPersonRef
          .where('receiverUuid', isEqualTo: currentUserUid)
          .where('senderUuid', isEqualTo: widget.uuid)
          .where('status', isEqualTo: 'pending')
          .get();

      if (bookedPersonQuerySnapshot.docs.isNotEmpty) {
        for (final bookedPersonDoc in bookedPersonQuerySnapshot.docs) {
          await bookedPersonDoc.reference.update({'status': 'decline'});
          debugPrint(
              'Updated status to decline for bookedperson document: ${bookedPersonDoc.id}');
        }
      }
    } catch (e) {
      debugPrint('Error updating booking status to decline: $e');
    }
  }

  Future<void> fetchUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Authentication')
          .doc(widget.uuid)
          .get();

      if (userDoc.exists) {
        //get user role from default authentication database
        final userRole = userDoc['role'];

        //pass in user's role
        final userCollection = FirebaseFirestore.instance.collection(userRole);
        debugPrint("User collection: $userCollection");

        //role database's uuid same with current uuid?
        final userDataQuery =
            userCollection.where('uuid', isEqualTo: widget.uuid);
        final userDataSnapshot = await userDataQuery.get();

        if (userDataSnapshot.docs.isNotEmpty) {
          final userDataDoc = userDataSnapshot.docs.first;
          final userName = userDataDoc['name'];
          final userAbout = userDataDoc['about'];
          final userUuid = userDataDoc['uuid'];
          final userImage = userDataDoc['imagePath'];
          debugPrint("Userrr IDDD:$userUuid");

          setState(() {
            _userName = userName;
            _userAbout = userAbout;
            _userUuid = userUuid;
            _userImage = userImage;
          });
        } else {
          debugPrint("User data document does not exist.");
        }
      } else {
        debugPrint("User document does not exist.");
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     //pass the user id into widget below
        //     builder: (context) =>
        //         BabysitterProfileDetailWidget(uuid: widget.uuid, role: widget.role),
        //   ),
        // );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white70,
        // Define the child widget of the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Add padding around the row widget
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                    _userImage,
                    fit: BoxFit.cover, // Set the fit property
                    width: 100, // Set the width
                    height: 100,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        );
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('Loading image'); // Handle the error
                    },
                  ),
                  Container(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                _userName,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        Container(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            _userAbout,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 80.0),
                ElevatedButton(
                  onPressed: () async {
                    //update _uuid status to accept
                    await updateBookingStatusToAccept();
                  },
                  child: const Text(
                    'Accept',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 50.0),
                ElevatedButton(
                  onPressed: () async {
                    await updateBookingStatusToDecline();
                  },
                  child: const Text(
                    'Decline',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
