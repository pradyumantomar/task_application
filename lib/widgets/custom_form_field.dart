import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_application/widgets/textfield_decoration.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField(
      {Key? key, required this.hintText, this.inputFormatters, this.validator})
      : super(key: key);

  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        inputFormatters: inputFormatters,
        validator: validator,
        decoration: textFieldDecoration(hintText: hintText),
      ),
    );
  }
}
