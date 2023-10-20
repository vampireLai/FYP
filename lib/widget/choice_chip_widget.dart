import 'package:flutter/material.dart';
import '../model/choicechip_state.dart';

class ChoiceChipWidget extends StatefulWidget {
  final List<ChoiceChipState> chipStates;

  const ChoiceChipWidget({
    Key? key,
    required this.chipStates,
  }) : super(key: key);

  @override
  State<ChoiceChipWidget> createState() => _ChoiceChipWidgetState();
}

class _ChoiceChipWidgetState extends State<ChoiceChipWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5.0,
      children: List.generate(
        widget.chipStates.length,
        (index) {
          final chipState = widget.chipStates[index];
          return ChoiceChip(
            label: Text(chipState.title),
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            selectedColor: Colors.yellow,
            selected: chipState.isSelected,
            onSelected: (bool selected) {
              setState(() {
                chipState.isSelected = selected;
              });
            },
          );
        },
      ).toList(),
    );
  }
}

