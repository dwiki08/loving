import 'package:flutter/material.dart';

import '../../model/socket_state.dart';

class SocketStatusIcon extends StatelessWidget {
  const SocketStatusIcon({super.key, required this.state});

  final SocketState state;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (state) {
      case SocketState.connecting:
        color = Colors.orange;
        break;
      case SocketState.connected:
        color = Colors.green;
        break;
      case SocketState.disconnected:
        color = Colors.red;
        break;
      case SocketState.error:
        color = Colors.red;
    }
    return Container(
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Icon(Icons.circle, color: color, size: 12),
    );
  }
}
