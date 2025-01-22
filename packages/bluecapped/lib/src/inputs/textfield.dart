import 'package:flutter/material.dart';

// FIXME: add more properties to this textfield

class BCTextField extends StatelessWidget {
  const BCTextField({
    super.key,
    required this.onChanged,
    this.hintText = 'Digite para buscar',
    this.prefixIcon,
  });

  final ValueChanged<String> onChanged;
  final String hintText;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8.0),
        filled: true,
        hintText: hintText,
        prefixIcon: prefixIcon ?? Icon(Icons.search),
      ),
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      onChanged: onChanged,
    );
  }
}
