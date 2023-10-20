import 'package:flutter/material.dart';
import 'package:kiddie_care_app/dialog/complaint_dialog.dart';
import 'package:kiddie_care_app/widget/favourite_icon_widget.dart';
import 'package:kiddie_care_app/widget/profile_widget.dart';
import 'package:kiddie_care_app/widget/review_list_widget.dart';
import '../dialog/review_dialog.dart';
import '../model/childcare_centre.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'book_button_widget.dart';

class ChildcareCentreProfileDetailWidget extends StatefulWidget {
  final String uuid;
  final String role;

  const ChildcareCentreProfileDetailWidget({super.key, required this.uuid,required this.role});

  @override
  State<ChildcareCentreProfileDetailWidget> createState() =>
      _ChildcareCentreProfileDetailWidgetState();
}

class _ChildcareCentreProfileDetailWidgetState
    extends State<ChildcareCentreProfileDetailWidget> {
  ChildcareCentre? childcareCentre;

  @override
  void initState() {
    super.initState();
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
      debugPrint('Error fetching childcareCentre info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (childcareCentre == null) {
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
          FavouriteIconButton(uuid: widget.uuid,role: widget.role),
          IconButton(
              icon: const Icon(Icons.error_outline),
              onPressed: () {
                openMakeComplaintDialog(context);
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            ProfileWidget(
              imagePath: childcareCentre!.imagePath!,
            ),
            const SizedBox(height: 15),
            buildName(childcareCentre!),
            buildDetails(childcareCentre!),
            ReviewListWidget(uuid: widget.uuid),
            BookPersonButton(uuid: widget.uuid)
          ],
        ),
      ),
    );
  }

  Widget buildName(ChildcareCentre childcareCentre) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            childcareCentre.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      );

  Widget buildDetails(ChildcareCentre childcareCentre) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'About us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              childcareCentre.about,
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
                  childcareCentre.area,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 18),
            //address
            const Row(
              children: [
                Icon(
                  Icons.note,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 32),
                Expanded(
                  child: Text(
                    childcareCentre.address,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),
            //operating year
            const Row(
              children: [
                Icon(
                  Icons.work,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Year of operating',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 32),
                Text(
                  childcareCentre.yearOfOperating.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 18),
            //phone number
            const Row(
              children: [
                Icon(
                  Icons.phone,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Contact',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 32),
                Text(
                  childcareCentre.phoneNumber,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 18),
            //email
            const Row(
              children: [
                Icon(
                  Icons.email,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Email',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 32),
                Text(
                  childcareCentre.email,
                  style: const TextStyle(fontSize: 16),
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
              'About childcare',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            //language
            const Row(
              children: [
                Icon(
                  Icons.speaker_notes,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Language we speak',
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
                      if (childcareCentre.language != null)
                        ...childcareCentre.language.map(
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
            const Row(
              children: [
                Icon(
                  Icons.people,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Experience of age(s)',
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
                      if (childcareCentre.experienceOfage != null)
                        ...childcareCentre.experienceOfage.map(
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
                  'Rate per day',
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
                  childcareCentre.rate.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            //programme
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
                  'Activities included',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  Wrap(
                    spacing: 8, // Adjust the spacing between items
                    children: [
                      if (childcareCentre.childcareProgramme != null)
                        ...childcareCentre.childcareProgramme.map(
                          (programme) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check,
                                color: Colors
                                    .green, // Change the color of the tick icon as needed
                              ),
                              const SizedBox(width: 4),
                              Text(
                                programme,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
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
                    if (childcareCentre.daysOfChildcare != null)
                      ...childcareCentre.daysOfChildcare.map(
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

  openRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ReviewDialog(uuid: widget.uuid),
        );
      },
    );
  }
}
