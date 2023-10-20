import 'package:flutter/material.dart';

class StatusButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final bool isClicked;

  const StatusButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
    this.isClicked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: BorderSide(width: 1.0, color: isClicked? Colors.orange: Colors.grey,),
         
          // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        ),
        onPressed: onClicked,
        child: Text(text, style: TextStyle(color: isClicked? Colors.orange: Colors.grey),),
      );
}
