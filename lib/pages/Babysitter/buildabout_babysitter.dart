import 'package:flutter/material.dart';
import 'package:kiddie_care_app/model/babysitter.dart';

class BuildBabysitterAbout extends StatefulWidget {
  final Babysitter user;

  const BuildBabysitterAbout({super.key, required this.user});

  @override
  State<BuildBabysitterAbout> createState() => _BuildBabysitterAboutState();
}

class _BuildBabysitterAboutState extends State<BuildBabysitterAbout> {
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
                    fontSize: 24,
                  ),
                ),
                const SizedBox(width: 8),
                if (widget.user.gender == 'Male')
                  const Icon(
                    Icons.male,
                    color: Colors.blue,
                    size: 24,
                  ),
                if (widget.user.gender == 'Female')
                  const Icon(
                    Icons.female,
                    color: Colors.pink,
                    size: 24,
                  ),
              ],
            ),
            const SizedBox(height: 8),
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
            const Row(
              children: [
                Icon(
                  Icons.child_care,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Experience of childcare',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 32),
                Text(
                  widget.user.experience.toString(),
                  style: const TextStyle(fontSize: 16),
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
                      // ignore: unnecessary_null_comparison
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
                  widget.user.rate.toString(),
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
                  widget.user.location,
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
                      if (widget.user.timeOfChildcare != null)
                        ...widget.user.timeOfChildcare.map(
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
          ],
        ),
      ),
    );
  }
}
