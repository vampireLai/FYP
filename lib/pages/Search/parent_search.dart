import 'package:flutter/material.dart';
import 'package:kiddie_care_app/pages/filter/childcare_filter.dart';
import 'package:kiddie_care_app/pages/filter/parent_filter_babysitter.dart';
import 'package:kiddie_care_app/widget/babysitter_card_widget.dart';
import 'package:kiddie_care_app/widget/button_widget.dart';
import 'package:kiddie_care_app/widget/chatbot.dart';
import 'package:kiddie_care_app/widget/childcarecentre_card.dart';
import '../../widget/toggle_button_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentSearch extends StatefulWidget {
  const ParentSearch({super.key});

  @override
  State<ParentSearch> createState() => _ParentSearchState();
}

class _ParentSearchState extends State<ParentSearch> {
  int _currentIndex = 0; // 0 for Babysitter, 1 for Childcare Centre

  @override
  Widget build(BuildContext context) {
    final selectedCollection = _currentIndex == 0
        ? FirebaseFirestore.instance.collection('babysitter')
        : FirebaseFirestore.instance.collection('childcarecentres');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Search',
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatBot(),
                ),
              );
            },
            icon: const Icon(Icons.chat),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: ButtonWidget(
                text: 'Filter',
                isIcon: true,
                onClicked: () {
                  if (_currentIndex == 0) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: ((context) => const ParentFilterBabysitter()),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: ((context) => const ParentFilterChildcare()),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 15.0),
            ToggleSwitchWidget(
              switchNames: const ['Babysitter', 'Childcare Centre'],
              onToggle: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            const SizedBox(height: 18.0),
            _currentIndex == 0
                ? const Row(
                    children: [
                      SizedBox(width: 4.0),
                      Text(
                        'Babysitter List',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : const Row(
                    children: [
                      SizedBox(width: 4.0),
                      Text(
                        'Childcare Centre List',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final item = docs[index].data() as Map<String, dynamic>;
                    // Check if the selected collection is 'babysitter' or 'childcarecentres'
                    if (_currentIndex == 0) {
                      final String uuid = item['uuid'];
                      return BabysitterCardWidget(
                          uuid: uuid, role: 'babysitter');
                    } else {
                      final String uuid = item['uuid'];
                      return ChildcareCentreCardWidget(
                          uuid: uuid, role: 'childcarecentres');
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
