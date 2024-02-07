import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfileTextWidget extends StatelessWidget {

  final TextEditingController controller;
  final String label;
  final int maxLine;
  final int minLine;

  const EditProfileTextWidget({Key key, this.controller, this.label, this.maxLine, this.minLine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: new InputDecoration(
        labelText: label,
        //fillColor: Colors.green
      ),
      maxLines: maxLine ?? 1,
      minLines: minLine ?? 1,
    );
  }
}
