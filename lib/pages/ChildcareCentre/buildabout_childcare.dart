import 'package:flutter/material.dart';
import 'package:kiddie_care_app/model/childcare_centre.dart';

class BuildChildcareAbout extends StatefulWidget {
  final ChildcareCentre user;

  const BuildChildcareAbout({super.key, required this.user});

  @override
  State<BuildChildcareAbout> createState() => _BuildChildcareAboutState();
}

class _BuildChildcareAboutState extends State<BuildChildcareAbout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(
              color: Colors.orange,
              thickness: 0.8,
            ),
            const SizedBox(height: 8),
            const Text(
              'About us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.user.about,
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
                  widget.user.area,
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
                    widget.user.address,
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
                  widget.user.yearOfOperating.toString(),
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
                  widget.user.phoneNumber,
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
                  widget.user.email,
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
                      if (widget.user.language != null)
                        ...widget.user.language.map(
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
                      if (widget.user.experienceOfage != null)
                        ...widget.user.experienceOfage.map(
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
                  widget.user.rate.toString(),
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
                      if (widget.user.childcareProgramme != null)
                        ...widget.user.childcareProgramme.map(
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
                Expanded(
                  child: Wrap(
                    spacing: 8, // Adjust the spacing between items
                    children: [
                      if (widget.user.daysOfChildcare != null)
                        ...widget.user.daysOfChildcare.map(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
