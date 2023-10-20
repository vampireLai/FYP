import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double value;
  final ValueChanged<double> onChanged;

  const SliderWidget({
    Key? key,
    required this.onChanged,
    required this.value,
    required this.minValue,
    required this.maxValue,
  }) : super(key: key);

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.minValue.round().toString(),
          style: const TextStyle(fontSize: 16),
        ),
        Expanded(
          child: Slider(
            value: widget.value,
            min: widget.minValue,
            max: widget.maxValue,
            onChanged: widget.onChanged,
          ),
        ),
        Text(
          "> ${widget.maxValue.round()}",
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
