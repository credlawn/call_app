import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_color.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.label,
    this.prefixIcon,
    this.hint,
    super.key,
    this.controller,
    this.keyboardType,
    this.maxLength,
    this.enable = false,

  });

  final String label;
  final String? hint;
  final Icon? prefixIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      decoration:
      BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(8.0), boxShadow: [
        BoxShadow(
            color: Colors.grey.withAlpha(100),
            blurRadius: 1.5,
            spreadRadius: 1.5,
            offset: Offset(0.3, 0.3))
      ]),
      child: TextField(
        inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
        keyboardType: keyboardType,
        controller: controller,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          enabled: enable,
          prefixIcon: prefixIcon,
          prefixIconColor: CustomColor.MainColor,
          hintText: hint,
          label: Text(
            label,
            style: GoogleFonts.poppins(
              color: CustomColor.MainColor,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: CustomColor.MainColor)),
        ),
      ),
    );
  }
}
