import 'package:flutter/material.dart';
import 'package:kiddie_care_app/dialog/complaint_dialog.dart';
import 'package:kiddie_care_app/model/user.dart';
import 'package:kiddie_care_app/widget/favourite_icon_widget.dart';
import 'package:kiddie_care_app/widget/profile_widget.dart';
import 'package:kiddie_care_app/widget/review_list_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../dialog/review_dialog.dart';
import 'book_button_widget.dart';

class ParentProfileDetailWidget extends StatefulWidget {
  final String uuid; //current babysitter uuid
  final String role;

  const ParentProfileDetailWidget(
      {super.key, required this.uuid, required this.role});

  @override
  State<ParentProfileDetailWidget> createState() =>
      _ParentProfileDetailWidgetState();
}

class _ParentProfileDetailWidgetState extends State<ParentProfileDetailWidget> {
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
              Colors.orange), // Change color as needed
          strokeWidth: 3, // Adjust the value to make it smaller
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Profile',
        ),
        actions: <Widget>[
          FavouriteIconButton(uuid: widget.uuid, role: widget.role),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            ProfileWidget(
              imagePath: parent!.imagePath!,
            ),
            const SizedBox(height: 15),
            buildName(parent!),
            buildDetails(parent!),
            //pass current babysitter uuid into review
            ReviewListWidget(uuid: widget.uuid),
            BookPersonButton(uuid: widget.uuid)
          ],
        ),
      ),
    );
  }

  Widget buildName(Parent parent) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            parent.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(width: 8),
          if (parent.gender == 'Male')
            const Icon(
              Icons.male,
              color: Colors.blue,
              size: 24,
            ),
          if (parent.gender == 'Female')
            const Icon(
              Icons.female,
              color: Colors.pink,
              size: 24,
            ),
        ],
      );

  Widget buildDetails(Parent parent) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              color: Colors.orange,
              thickness: 0.8,
            ),
            const SizedBox(height: 8),
            const Text(
              'About me',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              parent.about,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 18),
            //area
            const Row(
              children: [
                Icon(
                  Icons.house,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Area',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 32),
                Text(
                  parent.area,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            //language
            const SizedBox(height: 18),
            const Row(
              children: [
                Icon(
                  Icons.date_range,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Language',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 32),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    children: [
                      if (parent.language != null)
                        ...parent.language.map(
                          (language) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                language,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(
              color: Colors.orange,
              thickness: 0.8,
            ),
            const SizedBox(height: 10),
            const Text(
              'About children',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            //number of chiildren
            const Row(
              children: [
                Icon(
                  Icons.child_care,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Number of children',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 32),
                Text(
                  parent.numOfChild.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            //age of child
            const SizedBox(height: 18),
            const Row(
              children: [
                Icon(
                  Icons.people,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Age of child',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 32),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    children: [
                      if (parent.ageOfChild != null)
                        ...parent.ageOfChild.map(
                          (age) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                age,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            //type of childcare
            const SizedBox(height: 18),
            const Row(
              children: [
                Icon(
                  Icons.child_friendly,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Type of childcare',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 32),
                Text(
                  parent.typeOfCare,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            //rate
            const SizedBox(height: 18),
            const Row(
              children: [
                Icon(
                  Icons.money,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Rate per hour',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 32),
                const Text(
                  'RM',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  parent.rate.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            //location
            const SizedBox(height: 18),
            const Row(
              children: [
                Icon(
                  Icons.house_siding_rounded,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Location of childcare',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 32),
                Text(
                  parent.location,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            //days of childcare
            const SizedBox(height: 18),
            const Row(
              children: [
                Icon(
                  Icons.date_range,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Days of childcare',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 32),
                Wrap(
                  spacing: 8, // Adjust the spacing between items
                  children: [
                    if (parent.daysOfChildcare != null)
                      ...parent.daysOfChildcare.map(
                        (day) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check,
                              color: Colors
                                  .green, // Change the color of the tick icon as needed
                            ),
                            const SizedBox(width: 4),
                            Text(
                              day,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
            //time of childcare
            const SizedBox(height: 18),
            const Row(
              children: [
                Icon(
                  Icons.timelapse,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Time of childcare',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 32),
                Expanded(
                  child: Wrap(
                    spacing: 8, // Adjust the spacing between items
                    children: [
                      if (parent.timeOfChildcare != null)
                        ...parent.timeOfChildcare.map(
                          (time) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check,
                                color: Colors
                                    .green, // Change the color of the tick icon as needed
                              ),
                              const SizedBox(width: 4),
                              Text(
                                time,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(
              color: Colors.orange,
              thickness: 0.8,
            ),
            Row(
              children: [
                const Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    openRatingDialog(context);
                  },
                  child: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ],
        ),
      );

  openRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ReviewDialog(uuid: widget.uuid), //receiver uuid
        );
      },
    );
  }

  openMakeComplaintDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: MakeComplaintDialog(uuid: widget.uuid),
        );
      },
    );
  }
}
