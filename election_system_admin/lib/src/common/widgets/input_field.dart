import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final String? title;
  final String hint;
  final String? Function(String?)? validator;
  final void Function(String)? onchange;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffix;
  final TextEditingController? controller;
  final bool? obscureText;
  final bool? readOnly;
  final Icon? icon;

  const InputField({
    this.title,
    required this.hint,
    this.validator,
    this.onchange,
    this.keyboardType,
    this.inputFormatters,
    this.suffix,
    this.controller,
    this.obscureText,
    this.readOnly,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: TextFormField(
        readOnly: readOnly ?? false,
        controller: controller,
        onChanged: onchange,
        onFieldSubmitted: onchange,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          prefixIcon: icon,
          prefixIconColor: MaterialStateColor.resolveWith((states) =>
              states.contains(MaterialState.focused)
                  ? Colors.blue
                  : Colors.grey),
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.green,
              width: 4,
            ),
          ),
          filled: true,
          hintText: hint,
          hintStyle: const TextStyle(fontWeight: FontWeight.normal),
          suffixIcon: suffix,
          errorStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(176, 0, 32, 1),
          ),
        ),
        obscureText: obscureText ?? false,
        validator: validator,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
      ),
    );
  }
}
