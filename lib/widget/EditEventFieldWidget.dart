import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditEventFieldWidget extends StatelessWidget {

  final TextEditingController controller;
  final String label;
  final int minLine;
  final int maxLine;

  const EditEventFieldWidget({Key key, this.controller, this.label, this.minLine, this.maxLine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: TextFormField(
        controller: controller,
        minLines: minLine,
        maxLines: maxLine,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
                fontFamily: 'Montserrat', //First Name
                fontWeight: FontWeight.bold,
                color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green))),
      ),
    );

  }
}
