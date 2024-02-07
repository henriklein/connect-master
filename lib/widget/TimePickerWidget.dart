import 'package:c0nnect/components/default_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TimePickerWidget extends StatelessWidget {

  final ValueChanged<Duration> selectionListener;

  TimePickerWidget({Key key, this.selectionListener}) : super(key: key);

  Duration duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            minuteInterval: 1,
            secondInterval: 1,
            onTimerDurationChanged: (Duration changedTimer) {
              duration = changedTimer;
            },
          ),
          Container(
            width: Get.width,
            margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: DefaultButton(text: "Select",press: (){
              selectionListener(duration);
            },),
          )
        ],
      ),
    );
  }
}
