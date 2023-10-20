import 'package:flutter/material.dart';

import '../../widget/parent_card_widget.dart';

class FilterParentResult extends StatefulWidget {
  final List<String> uuidList;

  const FilterParentResult({super.key, required this.uuidList});

  @override
  State<FilterParentResult> createState() => _FilterParentResultState();
}

class _FilterParentResultState extends State<FilterParentResult> {
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
                  return ParentCardWidget(uuid: uuid, role: 'parents');
                },
              ),
          ),
    );
  }
}
