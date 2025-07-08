import 'package:flutter/material.dart';

extension ColorExtension on Color {
  /// Converts the [Color] to a hex string without the alpha value and with a leading '#'.
  String toHex() {
    // Convert the color value to a hexadecimal string and ensure it's 8 characters long
    String hex = value.toRadixString(16).toUpperCase().padLeft(8, '0');

    // Remove the alpha value (first two characters)
    hex = hex.substring(2);

    // Add leading '#'
    return '#$hex';
  }
}

extension HexColorExtension on String {
  /// Converts a hex color string to a [Color] object.
  ///
  /// Handles strings of length 2, 3, 4, 6, and 8 characters after removing the '#' character.
  /// Returns [defaultColor] if the input is invalid or an exception occurs.
  Color toColor({Color defaultColor = Colors.transparent}) {
    try {
      String hexColor = trim();

      // Remove the '#' character if present
      hexColor = hexColor.replaceAll('#', '');

      // Return default color if the string is empty
      if (hexColor.isEmpty) {
        return defaultColor;
      }

      // Handle shorthand hex codes
      if (hexColor.length == 2) {
        // Assume it's a grayscale value, duplicate it to form RGB
        hexColor = hexColor * 3;
        hexColor = 'FF$hexColor';
      } else if (hexColor.length == 3) {
        // Expand each character to two characters (e.g., 'abc' -> 'aabbcc')
        hexColor = hexColor.split('').map((char) => char * 2).join();
        hexColor = 'FF$hexColor';
      } else if (hexColor.length == 4) {
        // Expand ARGB shorthand (e.g., 'abcd' -> 'aabbccdd')
        hexColor = hexColor.split('').map((char) => char * 2).join();
      } else if (hexColor.length == 6) {
        // Assume full opacity
        hexColor = 'FF$hexColor';
      } else if (hexColor.length == 8) {
        // Use as is (ARGB)
      } else {
        // Invalid length
        return defaultColor;
      }

      // Parse the string and create a Color object
      return Color(int.parse('0x$hexColor'));
    } catch (e) {
      // Return default color in case of any exception
      return defaultColor;
    }
  }
}
