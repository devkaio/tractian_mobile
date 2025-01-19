import 'package:flutter/material.dart';

class BCFilterButton extends StatelessWidget {
  const BCFilterButton.withIcon({
    super.key,
    this.active = false,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final bool active;
  final VoidCallback onPressed;
  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    // FIXME: fix material state properties
    return ElevatedButton.icon(
      icon: icon,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        elevation: 0,
        backgroundColor: active ? Colors.blue : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: active ? Colors.transparent : Colors.grey),
          borderRadius: BorderRadius.circular(4.0),
        ),
        foregroundColor: active ? Colors.white : null,
      ),
      onPressed: onPressed,
      label: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: active ? Colors.white : Colors.grey,
            ),
      ),
    );
  }
}
