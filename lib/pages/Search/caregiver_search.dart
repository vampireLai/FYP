import 'package:flutter/material.dart';
import 'package:kiddie_care_app/pages/filter/parent_filter.dart';
import 'package:kiddie_care_app/widget/button_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kiddie_care_app/widget/parent_card_widget.dart';

class CaregiverSearch extends StatefulWidget {
  const CaregiverSearch({super.key});

  @override
  State<CaregiverSearch> createState() => _CaregiverSearchState();
}

class _CaregiverSearchState extends State<CaregiverSearch> {
  @override
  Widget build(BuildContext context) {
    final selectedCollection = FirebaseFirestore.instance.collection('parents');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Search',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: ButtonWidget(
                text: 'Filter',
                isIcon: true,
                onClicked: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) => const ChildcareFilterParent()),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15.0),
            const Row(
              children: [
                SizedBox(width: 4.0),
                Text(
                  'Parent List',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            StreamBuilder<QuerySnapshot>(
              stream: selectedCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final docs = snapshot.data!.docs;
      
                return Expanded(
                  child: ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final item = docs[index].data() as Map<String, dynamic>;
                      final String uuid = item['uuid'];
                      return ParentCardWidget(uuid: uuid, role: 'parents');
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
