import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';

/// Counter to show counter incrementing value
class CounterWidget extends StatelessWidget {
  const CounterWidget({
    super.key,
    required this.counter,
    required this.counterName,
  });

  final int counter;
  final String counterName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedFlipCounter(
          duration: const Duration(milliseconds: 300),
          value: counter,
          textStyle: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        ),
        Text(
          counterName,
          style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
