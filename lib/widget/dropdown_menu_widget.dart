import 'package:flutter/material.dart';

class DropdownMenuWidget extends StatefulWidget {
  final List<String> menuNames;
  final ValueChanged<String?> onChanged;

  const DropdownMenuWidget({
    Key? key,
    required this.menuNames,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<DropdownMenuWidget> createState() => _DropdownMenuWidgetState();
}

class _DropdownMenuWidgetState extends State<DropdownMenuWidget> {
  String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          iconSize: 36,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.orange,),
          isExpanded: true,
          items: widget.menuNames.map(buildMenuItem).toList(),
          onChanged: (newValue) {
            setState(() {
              value = newValue;
            });
            widget.onChanged(newValue); 
          },
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      );
}
