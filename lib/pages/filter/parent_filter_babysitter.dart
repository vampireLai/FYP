import 'package:flutter/material.dart';
import 'package:kiddie_care_app/pages/filter/filter_babysitter_result.dart';
import 'package:kiddie_care_app/widget/button_widget.dart';
import 'package:kiddie_care_app/widget/checkbox_grid_widget.dart';
import 'package:kiddie_care_app/widget/choice_chip_widget.dart';
import 'package:kiddie_care_app/widget/dropdown_menu_widget.dart';
import 'package:kiddie_care_app/widget/filter_chip.dart';
import 'package:kiddie_care_app/widget/toggle_button_widget.dart';
import '../../model/checkbox_state.dart';
import '../../model/choicechip_state.dart';
import '../../model/filter_babysitter.dart';
import '../../model/filterchip_state.dart';
import '../../utils/text_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentFilterBabysitter extends StatefulWidget {
  const ParentFilterBabysitter({super.key});

  @override
  State<ParentFilterBabysitter> createState() => _ParentFilterBabysitterState();
}

class _ParentFilterBabysitterState extends State<ParentFilterBabysitter> {
  final TextEditingControllers controllers = TextEditingControllers();
  int selectedGenderIndex = -1;
  String? selectedArea;
  List<String> selectedDayOfChildcare = [];
  List<String> selectedTimeOfChildcare = [];

  final List<ChoiceChipState> locationOptions = [
    ChoiceChipState(title: "At our home"),
    ChoiceChipState(title: "At the childcare's"),
  ];

  final List<FilterChipState> languageOptions = [
    FilterChipState(title: 'English'),
    FilterChipState(title: 'Mandarin'),
    FilterChipState(title: 'Malay'),
    FilterChipState(title: 'Other'),
  ];

  final List<CheckBoxState> daysOfChildcareOptions = [
    CheckBoxState(title: 'Weekdays'),
    CheckBoxState(title: 'Weekends'),
  ];

  final List<CheckBoxState> timeOfChildcareOptions = [
    CheckBoxState(title: 'Morning'),
    CheckBoxState(title: 'Afternoon'),
    CheckBoxState(title: 'Evening'),
    CheckBoxState(title: 'Night'),
  ];

  final List<FilterChipState> experienceOfAgeOptions = [
    FilterChipState(title: 'Baby'),
    FilterChipState(title: 'Toddler'),
    FilterChipState(title: 'Preschoolar'),
    FilterChipState(title: 'Gradeschoolar'),
    FilterChipState(title: 'Teenager'),
  ];

  FilterBabysitterParameters getFilterParameters() {
    final filterParameters = FilterBabysitterParameters(
      selectedArea: selectedArea ?? '',
      rate: int.tryParse(controllers.rateController.text) ?? 0,
      ageStart: int.tryParse(controllers.minAgeController.text) ?? 0,
      yearStart: int.tryParse(controllers.minYearController.text) ?? 0,
      gender: selectedGenderIndex == 0
          ? 'Male'
          : selectedGenderIndex == 1
              ? 'Female'
              : '',
      selectedTimeOfChildcare: selectedTimeOfChildcare,
      selectedDayOfChildcare: selectedDayOfChildcare,
      selectedLanguages: languageOptions
          .where((chipState) => chipState.isSelected)
          .map((chipState) => chipState.title)
          .toList(),
      location: locationOptions
          .firstWhere((chipState) => chipState.isSelected,
              orElse: () => ChoiceChipState(title: ''))
          .title,
      selectedExperienceOfage: experienceOfAgeOptions
          .where((chipState) => chipState.isSelected)
          .map((chipState) => chipState.title)
          .toList(),
    );

    debugPrint('selectedArea: ${filterParameters.selectedArea}');
    debugPrint('rate: ${filterParameters.rate}');
    debugPrint('ageStart: ${filterParameters.ageStart}');
    debugPrint('yearStart: ${filterParameters.yearStart}');
    debugPrint('gender: ${filterParameters.gender}');
    debugPrint(
        'selectedTimeOfChildcare: ${filterParameters.selectedTimeOfChildcare}');
    debugPrint(
        'selectedDayOfChildcare: ${filterParameters.selectedDayOfChildcare}');
    debugPrint('selectedLanguages: ${filterParameters.selectedLanguages}');
    debugPrint('location: ${filterParameters.location}');
    debugPrint(
        'selectedExperienceOfage: ${filterParameters.selectedExperienceOfage}');

    return filterParameters;
  }

  Future<List<String>> filterBabysitters() async {
    final filterParameters = getFilterParameters();
    final CollectionReference babysittersCollection =
        FirebaseFirestore.instance.collection('babysitter');
    List<List<String>> results = [];

    // Apply conditions based on filter parameters
    if (filterParameters.selectedArea!.isNotEmpty) {
      QuerySnapshot areaQuery = await babysittersCollection
          .where('area', isEqualTo: filterParameters.selectedArea)
          .get();
      List<String> areaUuids =
          areaQuery.docs.map((doc) => doc['uuid'] as String).toList();
      results.add(areaUuids);
      debugPrint('Area Query Results: $areaUuids');
    }

    // Apply rate condition
    if (filterParameters.rate! > 0) {
      QuerySnapshot rateQuery = await babysittersCollection
          .where('rate', isGreaterThanOrEqualTo: filterParameters.rate)
          .get();
      List<String> rateUuids =
          rateQuery.docs.map((doc) => doc['uuid'] as String).toList();

      if (rateUuids.isNotEmpty) {
        results.add(rateUuids);
        debugPrint('Rate Query Results: $rateUuids');
      }
    }

    // Apply age condition
    if (filterParameters.ageStart! > 0) {
      QuerySnapshot ageQuery = await babysittersCollection
          .where('age', isGreaterThanOrEqualTo: filterParameters.ageStart)
          .get();
      List<String> ageUuids =
          ageQuery.docs.map((doc) => doc['uuid'] as String).toList();

      if (ageUuids.isNotEmpty) {
        results.add(ageUuids);
        debugPrint('Rate Query Results: $ageUuids');
      }
    }

     // Apply year condition
    if (filterParameters.yearStart! > 0) {
      QuerySnapshot yearQuery = await babysittersCollection
          .where('experience', isGreaterThanOrEqualTo: filterParameters.yearStart)
          .get();
      List<String> yearUuids =
          yearQuery.docs.map((doc) => doc['uuid'] as String).toList();

      if (yearUuids.isNotEmpty) {
        results.add(yearUuids);
        debugPrint('Rate Query Results: $yearUuids');
      }
    }

    //gender
    if (filterParameters.gender!.isNotEmpty) {
      QuerySnapshot genderQuery = await babysittersCollection
          .where('gender', isEqualTo: filterParameters.gender)
          .get();
      List<String> genderUuids =
          genderQuery.docs.map((doc) => doc['uuid'] as String).toList();
      results.add(genderUuids);
      debugPrint('gender Query Results: $genderUuids');
    }

    // //location
    if (filterParameters.location!.isNotEmpty) {
      QuerySnapshot locationQuery = await babysittersCollection
          .where('location', isEqualTo: filterParameters.location)
          .get();
      List<String> locationUuids =
          locationQuery.docs.map((doc) => doc['uuid'] as String).toList();
      results.add(locationUuids);
      debugPrint('Location Query Results: $locationUuids');
    }

    // //time of childcare
    List<String> selectedDayOfChildcare =
        filterParameters.selectedDayOfChildcare!;
    if (selectedDayOfChildcare.isNotEmpty) {
      QuerySnapshot selectedDayOfChildcareQuery = await babysittersCollection
          .where('daysOfChildcare', arrayContainsAny: selectedDayOfChildcare)
          .get();
      List<String> daysOfChildcareUuids = selectedDayOfChildcareQuery.docs
          .map((doc) => doc['uuid'] as String)
          .toList();
      results.add(daysOfChildcareUuids);
      debugPrint('days Query Results: $daysOfChildcareUuids');
    }

    // //days of childcare
    List<String> selectedTimeOfChildcare =
        filterParameters.selectedTimeOfChildcare!;
    if (selectedTimeOfChildcare.isNotEmpty) {
      QuerySnapshot selectedTimeOfChildcareQuery = await babysittersCollection
          .where('timeOfChildcare', arrayContainsAny: selectedTimeOfChildcare)
          .get();
      List<String> timeOfChildcareUuids = selectedTimeOfChildcareQuery.docs
          .map((doc) => doc['uuid'] as String)
          .toList();
      results.add(timeOfChildcareUuids);
      debugPrint('Time Query Results: $timeOfChildcareUuids');
    }

    // Execute the query for languages
    List<String> selectedLanguages = filterParameters.selectedLanguages!;
    if (selectedLanguages.isNotEmpty) {
      QuerySnapshot languagesQuery = await babysittersCollection
          .where('language', arrayContainsAny: selectedLanguages)
          .get();
      List<String> languageUuids =
          languagesQuery.docs.map((doc) => doc['uuid'] as String).toList();
      results.add(languageUuids);
      debugPrint('Language Query Results: $languageUuids');
    }

    // Execute the query for experience of age
    List<String> selectedExperienceOfAge =
        filterParameters.selectedExperienceOfage!;
    if (selectedExperienceOfAge.isNotEmpty) {
      QuerySnapshot experienceQuery = await babysittersCollection
          .where('experienceOfage', arrayContainsAny: selectedExperienceOfAge)
          .get();
      List<String> experienceUuids =
          experienceQuery.docs.map((doc) => doc['uuid'] as String).toList();
      results.add(experienceUuids);
      debugPrint('Experience Query Results: $experienceUuids');
    }

    // Find the intersection of the results
    Set<String> intersection =
        results.isNotEmpty ? results.first.toSet() : Set<String>();
    for (int i = 1; i < results.length; i++) {
      intersection = intersection.intersection(results[i].toSet());
    }

    debugPrint('Intersection Set: $intersection');

    List<String> filteredBabysitterUuids = intersection.toList();

    return filteredBabysitterUuids.toList();
  }

  Future<void> applyFilter() async {
    final List<String> filteredUuids = await filterBabysitters();
    debugPrint('UUID:$filteredUuids');
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterBabysitterResult(uuidList: filteredUuids),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 70),
                  Text('Filter'),
                  Icon(Icons.filter_alt_outlined),
                ],
              ),
            ),
            SizedBox(
              width: 70,
              child: TextButton(
                onPressed: () {
                  // Navigate back to the previous page
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black, // Set the text color to white
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView(
          children: [buildFilter()],
        ),
      ),
    );
  }

  Widget buildFilter() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gender',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          ToggleSwitchWidget(
            switchNames: const ['Male', 'Female'],
            isGender: true,
            onToggle: (index) {
              setState(
                () {
                  selectedGenderIndex = index;
                },
              );
            },
          ),
          const SizedBox(height: 15.0),
          const Text(
            'Age',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          TextField(
            keyboardType: TextInputType.number,
            controller: controllers.minAgeController,
            decoration: const InputDecoration(
              hintText: 'Minumum acceptable age',
              hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 15.0),
          const Text(
            'Area',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          DropdownMenuWidget(
            menuNames: const [
              'Kuala Lumpur',
              'Perak',
              'Johor',
              'Kedah',
              'Kelantan',
              'Labuan',
              'Melaka',
              'Negeri Sembilan',
              'Pahang',
              'Penang',
              'Putrajaya',
              'Sabah',
              'Sarawak',
              'Selangor',
              'Terengganu'
            ],
            onChanged: (value) {
              setState(() {
                selectedArea = value;
                debugPrint('Dropdown Value Changed: $selectedArea');
              });
            },
          ),
          const SizedBox(height: 15.0),
          const Text(
            'Year of experience',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
           TextField(
            keyboardType: TextInputType.number,
            controller: controllers.minYearController,
            decoration: const InputDecoration(
              hintText: 'Minumum year of experience',
              hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 15.0),
          const Text(
            'Experience of age(s)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          FilterChipWidget(
            chipStates: experienceOfAgeOptions,
          ),
          const SizedBox(height: 15.0),
          const Text(
            'Rate per hour',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                controller: controllers.rateController,
                decoration: const InputDecoration(
                  hintText: 'Enter hourly rate',
                  hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  contentPadding:
                      EdgeInsets.only(left: 40), // Adjust left padding
                ),
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
              const Positioned(
                child: Text(
                  'RM',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              const Positioned(
                right: 12, // Adjust the position of the 'RM' text
                child: Text(
                  '/hr',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15.0),
          const Text(
            'Preferred babysitting location', //at the family, at the babysitter's
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          ChoiceChipWidget(
            chipStates: locationOptions,
          ),
          const SizedBox(height: 15.0),
          const Text(
            'Language',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          FilterChipWidget(
            chipStates: languageOptions,
          ),
          const SizedBox(height: 15.0),
          const Text(
            'Days we need childcare',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          CheckboxGridWidget(
            checkboxTitles: const ['Weekdays', 'Weekends'],
            onChanged: (title) {
              setState(() {
                if (selectedDayOfChildcare.contains(title)) {
                  selectedDayOfChildcare.remove(title);
                } else {
                  selectedDayOfChildcare.add(title);
                }
              });
            },
          ),
          const SizedBox(height: 15.0),
          const Text(
            'Time we need childcare',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          CheckboxGridWidget(
            checkboxTitles: const ['Morning', 'Afternoon', 'Evening', 'Night'],
            onChanged: (title) {
              setState(() {
                if (selectedTimeOfChildcare.contains(title)) {
                  selectedTimeOfChildcare.remove(title);
                } else {
                  selectedTimeOfChildcare.add(title);
                }
              });
            },
          ),
          const SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: ButtonWidget(
              text: 'See Results',
              onClicked: applyFilter,
            ),
          ),
        ],
      );
}
