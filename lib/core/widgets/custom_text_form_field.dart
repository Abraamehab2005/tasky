import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.maxLines,
      this.validator,
      required this.title});
  final TextEditingController controller;
  final String hintText;
  final int? maxLines;
  final Function(String?)? validator;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: controller,
          style: Theme.of(context).textTheme.labelMedium,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
          ),
          validator:
              validator != null ? (String? value) => validator!(value) : null,
        ),
      ],
    );
  }
}
