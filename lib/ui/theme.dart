import 'package:flutter/material.dart';

const double defaultPadding = 16.0;

const defaultCircularRadius = Radius.circular(10);

const primaryColor = Color(0xFFE89595);
const appBarColor = primaryColor;
const navbarItemColor = Color(0xff42515a);
const navbarSelectedItemColor = Color(0xFF6394C4);

ColorScheme colorScheme(BuildContext context) {
  return ColorScheme.fromSeed(seedColor: primaryColor).copyWith(
    primary: const Color(0xff42515a),
    onPrimary: const Color(0xff24323b),
    secondary: const Color(0x0f83939b),
  );
}

InputDecoration textFieldDecoration({
  required BuildContext context,
  required String label,
  String? hint,
  Widget? icon,
  String? error,
  Widget? suffixIcon,
}) => InputDecoration(
  icon: icon,
  labelText: label,
  hintText: hint,
  hintStyle: Theme.of(context).textTheme.labelMedium,
  alignLabelWithHint: true,
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  errorText: error,
  suffixIcon: suffixIcon,
);
