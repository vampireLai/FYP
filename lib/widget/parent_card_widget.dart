import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kiddie_care_app/widget/parent_profile_widget.dart';
import '../model/user.dart';

class ParentCardWidget extends StatefulWidget {
  final String uuid; //current parent uuid
  final String role;

  const ParentCardWidget({
    Key? key,
    required this.uuid,
    required this.role,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ParentCardWidgetState createState() => _ParentCardWidgetState();
}

class _ParentCardWidgetState extends State<ParentCardWidget> {
  Parent? parent;

  @override
  void initState() {
    super.initState();
    // Fetch the additional information based on the userID
    fetchParentInfo();
  }

  Future<void> fetchParentInfo() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('parents')
          .where('uuid', isEqualTo: widget.uuid)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final item = snapshot.docs[0].data() as Map<String, dynamic>;
        setState(() {
          parent = Parent.fromMap(item);
        });
      }
    } catch (e) {
      debugPrint('Error fetching parent info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (parent == null) {
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
                ParentProfileDetailWidget(uuid: widget.uuid, role: widget.role),
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
                    parent!.imagePath!,
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
                              parent!.name,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(width: 5),
                            if (parent!.gender == 'Male')
                              const Icon(
                                Icons.male,
                                color: Colors.blue,
                                size: 24,
                              ),
                            if (parent!.gender == 'Female')
                              const Icon(
                                Icons.female,
                                color: Colors.pink,
                                size: 24,
                              ),
                            const SizedBox(width: 5),
                          ],
                        ),
                        Container(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Num of child: ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              parent!.numOfChild.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Container(height: 10),
                        Text(
                          parent!.about,
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
