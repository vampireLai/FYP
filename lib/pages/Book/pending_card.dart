import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PendingCardWidget extends StatefulWidget {
  final String uuid;

  const PendingCardWidget({super.key, required this.uuid});

  @override
  State<PendingCardWidget> createState() => _PendingCardWidgetState();
}

class _PendingCardWidgetState extends State<PendingCardWidget> {
  //String? _role;
  String _userName = '';
  String _userImage = '';
  String _userAbout = '';
  String _userUuid = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
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
                  // Image.network(
                  //    _userImage,
                  //   fit: BoxFit.cover,
                  //   width: 100,
                  //   height: 100,
                  // ),
                  Container(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:8.0),
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
                          padding: const EdgeInsets.symmetric(horizontal:8.0),
                          child: Text(
                            _userAbout,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style:
                                const TextStyle(fontSize: 15, color: Colors.grey),
                          ),
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
