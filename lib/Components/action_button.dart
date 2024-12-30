import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Icon icon;
  final String toolTip;

  const ActionButton({super.key, required this.icon, required this.toolTip});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black38.withOpacity(0.8),
      ),
      child: IconButton(
        color: Colors.white,
        tooltip: toolTip,
        onPressed: () {},
        icon: icon,
        iconSize: 24,
      ),
    );
  }
}
