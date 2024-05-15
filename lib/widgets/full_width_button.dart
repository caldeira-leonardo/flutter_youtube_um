import 'package:flutter/material.dart';

class FullWidthButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function()? onPressed;

  final buttonStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 18),
      padding: const EdgeInsets.all(18));

  FullWidthButton(
      {super.key,
      required this.label,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton.icon(
        style: buttonStyle,
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
