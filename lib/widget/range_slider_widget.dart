import 'package:flutter/material.dart';

class RangeSliderWidget extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;

  const RangeSliderWidget({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.values,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<RangeSliderWidget> createState() => _RangeSliderWidgetState();
}

class _RangeSliderWidgetState extends State<RangeSliderWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.values.start.round().toString(),
          style: const TextStyle(fontSize: 16),
        ),
        Expanded(
          child: RangeSlider(
            values: widget.values,
            min: widget.minValue,
            max: widget.maxValue,
            onChanged: widget.onChanged,
          ),
        ),
        Text(
          "> ${widget.values.end.round()}",
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
