import 'package:flutter/material.dart';
import '../../widget/babysitter_card_widget.dart';

class FilterBabysitterResult extends StatefulWidget {
  final List<String> uuidList;

  const FilterBabysitterResult({super.key, required this.uuidList});

  @override
  State<FilterBabysitterResult> createState() => _FilterBabysitterResultState();
}

class _FilterBabysitterResultState extends State<FilterBabysitterResult> {
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
            padding: const EdgeInsets.all(15.0),
            child: ListView.builder(
                itemCount: widget.uuidList.length,
                itemBuilder: (context, index) {
                  final uuid = widget.uuidList[index];
                  return BabysitterCardWidget(uuid: uuid, role: 'babysitter');
                },
              ),
          ),
    );
  }
}
