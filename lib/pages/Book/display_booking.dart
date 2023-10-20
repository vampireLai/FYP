import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiddie_care_app/pages/Book/received_card.dart';
import '../../model/bookperson.dart';
import 'display_accept_booking.dart';
import 'display_decline_booking.dart';
import 'display_pending_booking.dart';

class DisplayBookingPage extends StatefulWidget {
  const DisplayBookingPage({super.key});

  @override
  State<DisplayBookingPage> createState() => _DisplayBookingPageState();
}

class _DisplayBookingPageState extends State<DisplayBookingPage> {
  final _currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  late List<String> senderUuidList = [];

  @override
  void initState() {
    super.initState();

    // Create a Firestore snapshot listener
    final query = FirebaseFirestore.instance
        .collection('bookedperson')
        .where('receiverUuid', isEqualTo: _currentUserUid)
        .where('status', isEqualTo: 'pending');

    query.snapshots().listen((QuerySnapshot querySnapshot) {
      final senderUuids =
          querySnapshot.docs.map((doc) => doc['senderUuid'] as String).toList();

      setState(() {
        senderUuidList =
            senderUuids; // Update the state with the fetched senderUuids
      });

      debugPrint('sender list: $senderUuids');
      debugPrint('current user: $_currentUserUid');
    });
  }

  Future<List<BookPerson>> fetchBookedPersonList() async {
    try {
      final bookingListRef = FirebaseFirestore.instance
          .collection('booklists')
          .doc(_currentUserUid);
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

        return bookedPersonList;
      } else {
        debugPrint('Document not exists');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching bookedPersonList: $e');
      return [];
    }
  }

  Future<void> fetchSenderUuids(String currentUserUid) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bookedperson')
          .where('receiverUuid', isEqualTo: currentUserUid)
          .where('status', isEqualTo: 'pending') // Filter by status 'pending'
          .get();

      final List<String> senderUuids =
          querySnapshot.docs.map((doc) => doc['senderUuid'] as String).toList();

      setState(() {
        senderUuidList =
            senderUuids; // Update the state with the fetched senderUuids
      });
      debugPrint('sender list:$senderUuids');
      debugPrint('current user:$_currentUserUid');
    } catch (e) {
      debugPrint('Error fetching senderUuids: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Your Booking'),
      ),
      body: FutureBuilder<List<BookPerson>>(
        future: fetchBookedPersonList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final bookedPersonList = snapshot.data ?? [];

            final pendingUuids = <String>[];
            final acceptedUuids = <String>[];
            final declinedUuids = <String>[];

            for (final bookedPerson in bookedPersonList) {
              if (bookedPerson.status == 'pending') {
                pendingUuids.add(bookedPerson.receiverUuid);
              } else if (bookedPerson.status == 'accept') {
                acceptedUuids.add(bookedPerson.receiverUuid);
              } else if (bookedPerson.status == 'decline') {
                declinedUuids.add(bookedPerson.receiverUuid);
              }
            }

            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 15.0),
                      Container(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DisplayAcceptedBookingWidget(
                                        uuid: acceptedUuids),
                              ),
                            );
                          },
                          child: const Text(
                            'Accpted Booking',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DisplayPendingBookingWidget(
                                        uuid: pendingUuids),
                              ),
                            );
                          },
                          child: const Text(
                            'Pending Booking',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DisplayDeclinedBookingWidget(uuid: declinedUuids),
                        ),
                      );
                    },
                    child: const Text(
                      'Declined Booking',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text('Received Booking List',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 15.0),
                  if (senderUuidList
                      .isNotEmpty) // Check if senderUuidList is not empty
                    Expanded(
                      child: ListView.builder(
                        itemCount: senderUuidList.length,
                        itemBuilder: (context, index) {
                          final uuid = senderUuidList[index];
                          return ReceivedBookingCardWidget(uuid: uuid);
                        },
                      ),
                    )
                  else
                    const Center(child: Text('No bookings available.')),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
