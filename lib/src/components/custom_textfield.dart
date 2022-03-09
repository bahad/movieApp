import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  const CustomTextField({Key? key, this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
          prefixIcon:
              IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          isDense: true,
          hintText: 'Enter a movie name ...',
          border: const OutlineInputBorder()),
    );
  }
}
