import 'package:flutter/material.dart';
import 'package:kiddie_care_app/model/checkbox_state.dart';

class CheckboxGridWidget extends StatefulWidget {
  final List<String> checkboxTitles;
  final ValueChanged<String>? onChanged; // Add this line

  const CheckboxGridWidget({
    required this.checkboxTitles,
     this.onChanged, // Add this line
    Key? key,
  }) : super(key: key);

  @override
  State<CheckboxGridWidget> createState() => _CheckboxGridWidgetState();
}

class _CheckboxGridWidgetState extends State<CheckboxGridWidget> {
  List<CheckBoxState> notifications = [];

  @override
  void initState() {
    super.initState();
    notifications = widget.checkboxTitles.map((title) => CheckBoxState(title: title)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...notifications.map(buildSingleCheckbox).toList(),
      ],
    );
  }

  Widget buildSingleCheckbox(CheckBoxState checkbox) => CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        value: checkbox.value,
        title: Text(
          checkbox.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onChanged: (value) {
          setState(() {
            checkbox.value = value!;
            widget.onChanged!(checkbox.title); // Call the onChanged callback
          });
        },
      );
}
