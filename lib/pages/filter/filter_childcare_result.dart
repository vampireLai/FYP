import 'package:flutter/material.dart';
import 'package:kiddie_care_app/widget/childcarecentre_card.dart';

class FilterChildcareResult extends StatefulWidget {
  final List<String> uuidList;

  const FilterChildcareResult({super.key, required this.uuidList});

  @override
  State<FilterChildcareResult> createState() => _FilterChildcareResultState();
}

class _FilterChildcareResultState extends State<FilterChildcareResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Results'),
      ),
      body: widget.uuidList.isEmpty
          ? const Center(
              child: Text('No matched users found.'),
            )
          : Padding(
            padding: const EdgeInsets.all(18.0),
            child: ListView.builder(
                itemCount: widget.uuidList.length,
                itemBuilder: (context, index) {
                  final uuid = widget.uuidList[index];
                  return ChildcareCentreCardWidget(uuid: uuid, role: 'childcarecentres');
                },
              ),
          ),
    );
  }
}
