import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ToggleSwitchWidget extends StatefulWidget {
  final List<String> switchNames;
  final bool isGender;
  final Function(int)? onToggle;

  const ToggleSwitchWidget({
    Key? key,
    required this.switchNames,
    this.isGender = false,
    this.onToggle,
  }) : super(key: key);

  @override
  State<ToggleSwitchWidget> createState() => _ToggleSwitchWidgetState();
}

class _ToggleSwitchWidgetState extends State<ToggleSwitchWidget> {
  int _currentIndex = -1; // Initially, set the first switch as selected

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 6.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Center(
        child: ToggleSwitch(
          minWidth: 150, // Adjust this value as needed
          initialLabelIndex: _currentIndex,
          cornerRadius: 20.0,
          inactiveBgColor: Colors.white,
          totalSwitches: widget.switchNames.length,
          labels: widget.switchNames,
          icons: widget.isGender
              ? [Icons.male, Icons.female]
              : [Icons.child_care, Icons.house],
          onToggle: (index) {
            setState(() {
              _currentIndex = index!;
            });
      
            if (widget.onToggle != null) {
              widget.onToggle!(
                  index!); // Call the onToggle callback if provided
            }
          },
        ),
      ),
    );
  }
}
