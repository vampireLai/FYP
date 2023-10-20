import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiddie_care_app/pages/filter/filter_parent_result.dart';
import '../../model/checkbox_state.dart';
import '../../model/choicechip_state.dart';
import '../../model/filter_childcare.dart';
import '../../model/filter_parent.dart';
import '../../model/filterchip_state.dart';
import '../../utils/text_controller.dart';
import '../../widget/button_widget.dart';
import '../../widget/checkbox_grid_widget.dart';
import '../../widget/choice_chip_widget.dart';
import '../../widget/dropdown_menu_widget.dart';
import '../../widget/filter_chip.dart';

class ChildcareFilterParent extends StatefulWidget {
  const ChildcareFilterParent({super.key});

  @override
  State<ChildcareFilterParent> createState() => _ChildcareFilterParentState();
}

class _ChildcareFilterParentState extends State<ChildcareFilterParent> {
  final TextEditingControllers controllers = TextEditingControllers();
  List<String> selectedDayOfChildcare = [];
  List<String> selectedTimeOfChildcare = [];
  String? selectedArea; //num of child , rate

  final List<CheckBoxState> daysOfChildcareOptions = [
    CheckBoxState(title: 'Weekdays'),
    CheckBoxState(title: 'Weekends'),
  ];

  final List<ChoiceChipState> locationOptions = [
    ChoiceChipState(title: "At our home"),
    ChoiceChipState(title: "At the childcare's"),
  ];

  final List<FilterChipState> ageOfChildOptions = [
    FilterChipState(title: 'Baby'),
    FilterChipState(title: 'Toddler'),
    FilterChipState(title: 'Preschooler'),
    FilterChipState(title: 'Gradeschoolar'),
    FilterChipState(title: 'Teenager'),
  ];

  final List<CheckBoxState> timeOfChildcareOptions = [
    CheckBoxState(title: 'Morning'),
    CheckBoxState(title: 'Afternoon'),
    CheckBoxState(title: 'Evening'),
    CheckBoxState(title: 'Night'),
  ];

  final List<ChoiceChipState> typeOfCareOptions = [
    ChoiceChipState(title: "Babysitter"),
    ChoiceChipState(title: "Childcare Centre"),
  ];

  FilterParentParameters getFilterParameters() {
    final filterParameters = FilterParentParameters(
      selectedArea: selectedArea ?? '',
      rate: int.tryParse(controllers.rateController.text) ?? 0,
      numOfChild: int.tryParse(controllers.numOfChildController.text) ?? 0,
      selectedTimeOfChildcare: selectedTimeOfChildcare,
      selectedDayOfChildcare: selectedDayOfChildcare,
      location: locationOptions
          .firstWhere((chipState) => chipState.isSelected,
              orElse: () => ChoiceChipState(title: ''))
          .title,
      selectedAgeOfChild: ageOfChildOptions
          .where((chipState) => chipState.isSelected)
          .map((chipState) => chipState.title)
          .toList(),
      typeOfCare: typeOfCareOptions
          .firstWhere((chipState) => chipState.isSelected,
              orElse: () => ChoiceChipState(title: ''))
          .title,
    );

    debugPrint('selectedArea: ${filterParameters.selectedArea}');
    debugPrint('rate: ${filterParameters.rate}');
    debugPrint('Number of child: ${filterParameters.numOfChild}');
    debugPrint(
        'selectedTimeOfChildcare: ${filterParameters.selectedTimeOfChildcare}');
    debugPrint(
        'selectedDayOfChildcare: ${filterParameters.selectedDayOfChildcare}');
    debugPrint('location: ${filterParameters.location}');
    debugPrint('selectedAgeOfChild: ${filterParameters.selectedAgeOfChild}');
    debugPrint('typeOfCare: ${filterParameters.typeOfCare}');

    return filterParameters;
  }

  Future<List<String>> filterParents() async {
    final filterParameters = getFilterParameters();
    final CollectionReference parentsCollection =
        FirebaseFirestore.instance.collection('parents');
    List<List<String>> results = [];

    // Apply conditions based on filter parameters
    if (filterParameters.selectedArea!.isNotEmpty) {
      QuerySnapshot areaQuery = await parentsCollection
          .where('area', isEqualTo: filterParameters.selectedArea)
          .get();
      List<String> areaUuids =
          areaQuery.docs.map((doc) => doc['uuid'] as String).toList();
      results.add(areaUuids);
      debugPrint('Area Query Results: $areaUuids');
    }

    // Apply rate condition
    if (filterParameters.rate! > 0) {
      QuerySnapshot rateQuery = await parentsCollection
          .where('rate', isGreaterThanOrEqualTo: filterParameters.rate)
          .get();
      List<String> rateUuids =
          rateQuery.docs.map((doc) => doc['uuid'] as String).toList();

      if (rateUuids.isNotEmpty) {
        results.add(rateUuids);
        debugPrint('Rate Query Results: $rateUuids');
      }
    }

    // Apply num of child condition
    if (filterParameters.numOfChild! > 0) {
      QuerySnapshot numOfChildQuery = await parentsCollection
          .where('numOfChild', isEqualTo: filterParameters.numOfChild)
          .get();
      List<String> numOfChildUuids =
          numOfChildQuery.docs.map((doc) => doc['uuid'] as String).toList();

      if (numOfChildUuids.isNotEmpty) {
        results.add(numOfChildUuids);
        debugPrint('numOfChild Results: $numOfChildUuids');
      }
    }

    //location
    if (filterParameters.typeOfCare!.isNotEmpty) {
      QuerySnapshot typeOfCareQuery = await parentsCollection
          .where('typeOfCare', isEqualTo: filterParameters.typeOfCare)
          .get();
      List<String> typeOfCareUuids =
          typeOfCareQuery.docs.map((doc) => doc['uuid'] as String).toList();
      results.add(typeOfCareUuids);
      debugPrint('typeOfCare Query Results: $typeOfCareUuids');
    }

    //location
    if (filterParameters.location!.isNotEmpty) {
      QuerySnapshot locationQuery = await parentsCollection
          .where('location', isEqualTo: filterParameters.location)
          .get();
      List<String> locationUuids =
          locationQuery.docs.map((doc) => doc['uuid'] as String).toList();
      results.add(locationUuids);
      debugPrint('Location Query Results: $locationUuids');
    }

    //day of childcare
    List<String> selectedDayOfChildcare =
        filterParameters.selectedDayOfChildcare!;
    if (selectedDayOfChildcare.isNotEmpty) {
      QuerySnapshot selectedDayOfChildcareQuery = await parentsCollection
          .where('daysOfChildcare', arrayContainsAny: selectedDayOfChildcare)
          .get();
      List<String> daysOfChildcareUuids = selectedDayOfChildcareQuery.docs
          .map((doc) => doc['uuid'] as String)
          .toList();
      results.add(daysOfChildcareUuids);
      debugPrint('days Query Results: $daysOfChildcareUuids');
    }

    //time of childcare
    List<String> selectedTimeOfChildcare =
        filterParameters.selectedTimeOfChildcare!;
    if (selectedTimeOfChildcare.isNotEmpty) {
      QuerySnapshot selectedTimeOfChildcareQuery = await parentsCollection
          .where('timeOfChildcare', arrayContainsAny: selectedTimeOfChildcare)
          .get();
      List<String> timeOfChildcareUuids = selectedTimeOfChildcareQuery.docs
          .map((doc) => doc['uuid'] as String)
          .toList();
      results.add(timeOfChildcareUuids);
      debugPrint('Time Query Results: $timeOfChildcareUuids');
    }

    // Execute the query for experience of age
    List<String> selectedAgeOfChild = filterParameters.selectedAgeOfChild!;
    if (selectedAgeOfChild.isNotEmpty) {
      QuerySnapshot ageOfChildQuery = await parentsCollection
          .where('ageOfChild', arrayContainsAny: selectedAgeOfChild)
          .get();
      List<String> ageOfChildUuids =
          ageOfChildQuery.docs.map((doc) => doc['uuid'] as String).toList();
      results.add(ageOfChildUuids);
      debugPrint('ageOfChild Query Results: $ageOfChildUuids');
    }

    // Find the intersection of the results
    Set<String> intersection =
        results.isNotEmpty ? results.first.toSet() : Set<String>();
    for (int i = 1; i < results.length; i++) {
      intersection = intersection.intersection(results[i].toSet());
    }

    debugPrint('Intersection Set: $intersection');

    List<String> filteredParentsUuids = intersection.toList();

    return filteredParentsUuids.toList();
  }

  Future<void> applyFilter() async {
    final List<String> filteredUuids = await filterParents();
    debugPrint('UUID:$filteredUuids');
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterParentResult(uuidList: filteredUuids),
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
            'Type of care needed',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          ChoiceChipWidget(
            chipStates: typeOfCareOptions,
          ),
          const SizedBox(height: 24.0),
          const Text(
            'Number of child',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: controllers.numOfChildController,
            decoration: const InputDecoration(
              hintText: 'Enter number of child',
              hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 24.0),
          const Text(
            'Age of child',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          FilterChipWidget(
            chipStates: ageOfChildOptions,
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
          const SizedBox(height: 24.0),
          const Text(
            'Rate',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                controller: controllers.rateController,
                decoration: const InputDecoration(
                  hintText: 'Enter rate (/hr or /day)',
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
                  '/hr or /day',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          const Text(
            'Days they need childcare',
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
            'Time they need childcare',
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
