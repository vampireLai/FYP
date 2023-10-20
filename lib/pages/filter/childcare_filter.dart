import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiddie_care_app/widget/button_widget.dart';
import 'package:kiddie_care_app/widget/checkbox_grid_widget.dart';
import 'package:kiddie_care_app/widget/dropdown_menu_widget.dart';
import 'package:kiddie_care_app/widget/filter_chip.dart';
import '../../model/checkbox_state.dart';
import '../../model/filterchip_state.dart';
import '../../utils/text_controller.dart';
import '../../model/filter_childcare.dart';
import 'filter_childcare_result.dart';

class ParentFilterChildcare extends StatefulWidget {
  const ParentFilterChildcare({super.key});

  @override
  State<ParentFilterChildcare> createState() => _ParentFilterChildcareState();
}

class _ParentFilterChildcareState extends State<ParentFilterChildcare> {
  final TextEditingControllers controllers = TextEditingControllers();
  List<String> selectedDayOfChildcare = [];
  String? selectedArea;

  final List<CheckBoxState> daysOfChildcareOptions = [
    CheckBoxState(title: 'Weekdays'),
    CheckBoxState(title: 'Weekends'),
  ];

  final List<FilterChipState> languageOptions = [
    FilterChipState(title: 'English'),
    FilterChipState(title: 'Mandarin'),
    FilterChipState(title: 'Malay'),
    FilterChipState(title: 'Other'),
  ];

  final List<FilterChipState> experienceOfAgeOptions = [
    FilterChipState(title: 'Baby'),
    FilterChipState(title: 'Toddler'),
    FilterChipState(title: 'Preschooler'),
    FilterChipState(title: 'Gradeschoolar'),
    FilterChipState(title: 'Teenager'),
  ];

  FilterChildcareParameters getFilterParameters() {
    final filterParameters = FilterChildcareParameters(
      selectedArea: selectedArea ?? '',
      rate: int.tryParse(controllers.rateController.text) ?? 0,
      yearStart: int.tryParse(controllers.minYearController.text) ?? 0,
      selectedDayOfChildcare: selectedDayOfChildcare,
      selectedLanguages: languageOptions
          .where((chipState) => chipState.isSelected)
          .map((chipState) => chipState.title)
          .toList(),
      selectedExperienceOfage: experienceOfAgeOptions
          .where((chipState) => chipState.isSelected)
          .map((chipState) => chipState.title)
          .toList(),
    );

    debugPrint('selectedArea: ${filterParameters.selectedArea}');
    debugPrint('rate: ${filterParameters.rate}');
    debugPrint('yearStart: ${filterParameters.yearStart}');
    debugPrint(
        'selectedDayOfChildcare: ${filterParameters.selectedDayOfChildcare}');
    debugPrint('selectedLanguages: ${filterParameters.selectedLanguages}');
    debugPrint(
        'selectedExperienceOfage: ${filterParameters.selectedExperienceOfage}');

    return filterParameters;
  }

  Future<List<String>> filterChildcareCentres() async {
    final filterParameters = getFilterParameters();
    final CollectionReference childcareCollection =
        FirebaseFirestore.instance.collection('childcarecentres');
    List<List<String>> results = [];

    // Area
    if (filterParameters.selectedArea!.isNotEmpty) {
      QuerySnapshot areaQuery = await childcareCollection
          .where('area', isEqualTo: filterParameters.selectedArea)
          .get();
      List<String> areaUuids =
          areaQuery.docs.map((doc) => doc['uuid'] as String).toList();
      results.add(areaUuids);
      debugPrint('Area Query Results: $areaUuids');
    }

    // Apply rate condition
    if (filterParameters.rate! > 0) {
      QuerySnapshot rateQuery = await childcareCollection
          .where('rate', isGreaterThanOrEqualTo: filterParameters.rate)
          .get();
      List<String> rateUuids =
          rateQuery.docs.map((doc) => doc['uuid'] as String).toList();

      if (rateUuids.isNotEmpty) {
        results.add(rateUuids);
        debugPrint('Rate Query Results: $rateUuids');
      }
    }

    // Apply year condition
    if (filterParameters.yearStart! > 0) {
      QuerySnapshot yearQuery = await childcareCollection
          .where('yearOfOperating',
              isGreaterThanOrEqualTo: filterParameters.yearStart)
          .get();
      List<String> yearUuids =
          yearQuery.docs.map((doc) => doc['uuid'] as String).toList();

      if (yearUuids.isNotEmpty) {
        results.add(yearUuids);
        debugPrint('Year Query Results: $yearUuids');
      }
    }

    // day of childcare
    List<String> selectedDayOfChildcare =
        filterParameters.selectedDayOfChildcare!;
    if (selectedDayOfChildcare.isNotEmpty) {
      QuerySnapshot selectedDayOfChildcareQuery = await childcareCollection
          .where('daysOfChildcare', arrayContainsAny: selectedDayOfChildcare)
          .get();
      List<String> daysOfChildcareUuids = selectedDayOfChildcareQuery.docs
          .map((doc) => doc['uuid'] as String)
          .toList();
      results.add(daysOfChildcareUuids);
      debugPrint('days Query Results: $daysOfChildcareUuids');
    }

    //languages
    List<String> selectedLanguages = filterParameters.selectedLanguages!;
    if (selectedLanguages.isNotEmpty) {
      QuerySnapshot languagesQuery = await childcareCollection
          .where('language', arrayContainsAny: selectedLanguages)
          .get();
      List<String> languageUuids =
          languagesQuery.docs.map((doc) => doc['uuid'] as String).toList();
      results.add(languageUuids);
      debugPrint('Language Query Results: $languageUuids');
    }

    //experience of age
    List<String> selectedExperienceOfAge =
        filterParameters.selectedExperienceOfage!;
    if (selectedExperienceOfAge.isNotEmpty) {
      QuerySnapshot experienceQuery = await childcareCollection
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

    List<String> filteredChildcareUuids = intersection.toList();

    return filteredChildcareUuids.toList();
  }

  Future<void> applyFilter() async {
    final List<String> filteredUuids = await filterChildcareCentres();
    debugPrint('UUID:$filteredUuids');
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterChildcareResult(uuidList: filteredUuids),
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
                  SizedBox(width: 60),
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
                    color: Colors.black,
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
          const SizedBox(height: 24.0),
          const Text(
            'Year of Operating',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: controllers.minYearController,
            decoration: const InputDecoration(
              hintText: 'Minimum year of operating',
              hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 24.0),
          const Text(
            'Experience of Age',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          FilterChipWidget(
            chipStates: experienceOfAgeOptions,
          ),
          const SizedBox(height: 24.0),
          const Text(
            'Rate per day',
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
                  '/day',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          const Text(
            'Language',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          FilterChipWidget(
            chipStates: languageOptions,
          ),
          const SizedBox(height: 24.0),
          const Text(
            'Days you need childcare',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: ButtonWidget(text: 'See Results', onClicked: applyFilter),
          ),
        ],
      );
}
