
import 'package:c0nnect/widget/EditProfileTextWidget.dart';
import 'package:flutter/cupertino.dart';

class EditProfileTextWidget2 extends StatelessWidget {

  final String image;
  final TextEditingController controller;
  final String  label;

  const EditProfileTextWidget2({Key key, this.image, this.controller, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: EditProfileTextWidget(controller: controller,label: label)
        ),
        Image.asset(image,width: 24,height: 24,),
        SizedBox(width: 10,),
      ],
    );
  }
}
