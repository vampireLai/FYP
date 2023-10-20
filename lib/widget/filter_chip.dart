import 'package:flutter/material.dart';
import '../model/filterchip_state.dart';

class FilterChipWidget extends StatefulWidget {
  final List<FilterChipState> chipStates;

  const FilterChipWidget({
    Key? key,
    required this.chipStates,
  }) : super(key: key);

  @override
  State<FilterChipWidget> createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5.0,
      children: List.generate(
        widget.chipStates.length,
        (index) {
          final chipState = widget.chipStates[index];
          return FilterChip(
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
