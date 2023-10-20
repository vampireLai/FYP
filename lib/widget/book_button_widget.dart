import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/booklist.dart';
import '../model/bookperson.dart';

class BookPersonButton extends StatefulWidget {
  final String uuid; //receiver uuid
  const BookPersonButton({super.key, required this.uuid});

  @override
  State<BookPersonButton> createState() => _BookPersonButtonState();
}

class _BookPersonButtonState extends State<BookPersonButton> {
  String bookingStatus = 'pending'; // Initial booking status
  final currentUserUid =
      FirebaseAuth.instance.currentUser!.uid; //current logged in user

  void createBookPerson() async {
    // Create a new BookedPerson object with the receiver's UUID and status
    final bookedPerson =
        BookPerson(receiverUuid: widget.uuid, senderUuid: currentUserUid ,status: bookingStatus);

    //save to bookperson
    await saveBookedPersonToFirestore(bookedPerson);

    // After saving the bookedPerson, retrieve the existing BookingList for the senderUuid
    final existingBookingList = await retrieveBookingList();

    // Add the newly created bookedPerson to the existing list
    existingBookingList.bookedPersonList.add(bookedPerson);

    //Save the updated BookingList object back to Firestore
    await saveBookingListToFirestore(existingBookingList);

    // Show a success message or perform any other required actions
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking Request Sent Successfully')),
    );
  }

  Future<BookingList> retrieveBookingList() async {
    final bookingListRef = FirebaseFirestore.instance
        .collection('booklists')
        .doc(currentUserUid); //set booklist uid to current logged in user
    final bookingListDoc = await bookingListRef.get();

    if (bookingListDoc.exists) {
      final data = bookingListDoc.data() as Map<String, dynamic>;
      final senderUuid = data['senderUuid'] as String;
      final bookedPersonList = (data['bookedPersonList'] as List<dynamic>)
          .map((item) => BookPerson(
                receiverUuid: item['receiverUuid'] as String,
                senderUuid: item['senderUuid'] as String,
                status: item['status'] as String,
              ))
          .toList();

      return BookingList(
          senderUuid: senderUuid, bookedPersonList: bookedPersonList);
    } else {
      // Create a new BookingList if it doesn't exist
      final newBookingList =
          BookingList(senderUuid: currentUserUid, bookedPersonList: []);
      await bookingListRef.set(newBookingList.toMap());
      return newBookingList;
    }
  }

  Future<void> saveBookedPersonToFirestore(BookPerson bookedPerson) async {
    final bookedPersonRef = FirebaseFirestore.instance
        .collection('bookedperson')
        .doc();

    await bookedPersonRef.set({
      'receiverUuid': bookedPerson.receiverUuid,
      'senderUuid': bookedPerson.senderUuid,
      'status': bookedPerson.status,
    });
  }

  Future<void> saveBookingListToFirestore(BookingList bookingList) async {
    final bookingListRef = FirebaseFirestore.instance
        .collection('booklists')
        .doc(bookingList.senderUuid);

    final List<Map<String, dynamic>> bookedPersonListData =
        bookingList.bookedPersonList
            .map((bookedPerson) => {
                  'receiverUuid': bookedPerson.receiverUuid,
                  'senderUuid': bookedPerson.senderUuid,
                  'status': bookedPerson.status,
                })
            .toList();

    await bookingListRef.set({
      'senderUuid': bookingList.senderUuid,
      'bookedPersonList': bookedPersonListData,
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: createBookPerson,
      child: const Text(
        'Book Now',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
