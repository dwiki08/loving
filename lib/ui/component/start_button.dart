import 'package:flutter/material.dart';

class StartButton extends StatelessWidget {
  const StartButton({
    super.key,
    required this.onStart,
    required this.onStop,
    required this.isRunning,
  });

  final Function onStart;
  final Function onStop;
  final bool isRunning;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (isRunning) {
          onStop();
        } else {
          onStart();
        }
      },
      icon:
          isRunning
              ? Icon(Icons.stop_circle_outlined, color: Colors.red)
              : Icon(Icons.play_circle_outline, color: Colors.green),
    );
  }
}
