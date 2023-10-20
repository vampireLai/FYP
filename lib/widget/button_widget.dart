import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final bool isIcon;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
    this.isIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: isIcon ? const Color.fromARGB(255, 255, 196, 59) : Colors.orange,
          //padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        ),
        onPressed: onClicked,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text),
            if (isIcon)
              const SizedBox(width: 4), // Add some space between text and icon
            if (isIcon)
              const Icon(Icons.filter_alt_outlined), // Your filter icon here
          ],
        ),
      );
}
