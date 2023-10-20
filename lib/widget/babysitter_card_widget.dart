import 'package:flutter/material.dart';
import 'package:kiddie_care_app/model/babysitter.dart';
import 'package:kiddie_care_app/widget/babysitter_profile_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BabysitterCardWidget extends StatefulWidget {
  final String uuid; //current babysitter uuid
  final String role;

  const BabysitterCardWidget({
    Key? key,
    required this.uuid,
    required this.role,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BabysitterCardWidgetState createState() => _BabysitterCardWidgetState();
}

class _BabysitterCardWidgetState extends State<BabysitterCardWidget> {
  Babysitter? babysitter;

  @override
  void initState() {
    super.initState();
    // Fetch the additional information based on the userID
    fetchBabysitterInfo();
  }

  Future<void> fetchBabysitterInfo() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('babysitter')
          .where('uuid', isEqualTo: widget.uuid)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final item = snapshot.docs[0].data() as Map<String, dynamic>;
        setState(() {
          babysitter = Babysitter.fromMap(item);
        });
      }
    } catch (e) {
      debugPrint('Error fetching babysitter info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (babysitter == null) {
      // Return a loading widget or placeholder
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white), // Change color as needed
          strokeWidth: 3, // Adjust the value to make it smaller
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            //pass the user id into widget below
            builder: (context) =>
                BabysitterProfileDetailWidget(uuid: widget.uuid, role: widget.role),
          ),
        );
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
                    babysitter!.imagePath!,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                  Container(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              babysitter!.name,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(width: 5),
                            if (babysitter!.gender == 'Male')
                              const Icon(
                                Icons.male,
                                color: Colors.blue,
                                size: 24,
                              ),
                            if (babysitter!.gender == 'Female')
                              const Icon(
                                Icons.female,
                                color: Colors.pink,
                                size: 24,
                              ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.circle,
                              size: 6,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              babysitter!.age.toString(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'RM',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              babysitter!.rate.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Text(
                              '/hr',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(height: 10),
                        Text(
                          babysitter!.about,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style:
                              const TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
