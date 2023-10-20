import 'package:flutter/material.dart';
import 'package:kiddie_care_app/model/childcare_centre.dart';
import 'childcare_profile_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChildcareCentreCardWidget extends StatefulWidget {
  final String uuid;
  final String role;

  const ChildcareCentreCardWidget({
    Key? key,
    required this.uuid,
    required this.role
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChildcareCentreCardWidgetState createState() =>
      _ChildcareCentreCardWidgetState();
}

class _ChildcareCentreCardWidgetState extends State<ChildcareCentreCardWidget> {
  ChildcareCentre? childcareCentre;

  @override
  void initState() {
    super.initState();
    // Fetch the additional information based on the userID
    fetchChildcareCentreInfo();
  }

  Future<void> fetchChildcareCentreInfo() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('childcarecentres')
          .where('uuid', isEqualTo: widget.uuid)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final item = snapshot.docs[0].data() as Map<String, dynamic>;
        setState(() {
          childcareCentre = ChildcareCentre.fromMap(item);
        });
      }
    } catch (e) {
      debugPrint('Error fetching childcare centre info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (childcareCentre == null) {
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
            builder: (context) =>
                ChildcareCentreProfileDetailWidget(uuid: widget.uuid, role: widget.role),
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
                    childcareCentre!.imagePath!,
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
                        Text(
                          childcareCentre!.name,
                          maxLines: 2,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
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
                              childcareCentre!.rate.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Text(
                              '/day',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Operating Year:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              childcareCentre!.yearOfOperating.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Container(height: 10),
                        Text(
                          childcareCentre!.about,
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
