import 'package:c0nnect/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoodsDetector extends StatelessWidget {
  const MoodsDetector({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      height: 70,
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: secondaryTextColor, blurRadius: 10),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: MoodsSelector(),
      ),
    );
  }
}

class MoodsSelector extends StatefulWidget {
  // MoodsSelector({Key key}) : super(key: key);

  @override
  _MoodsSelectorState createState() => _MoodsSelectorState();
}

class _MoodsSelectorState extends State<MoodsSelector> {
  //List<bool> isSelected = List.generate(5, (_) => false);
  List<bool> isSelected = [false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ToggleButtons(
        selectedColor: Colors.green,
        color: Colors.orangeAccent,
        borderColor: Colors.transparent,
        renderBorder: false,
        fillColor: Colors.transparent,
        children: <Widget>[
          Icon(
            Icons.directions_run,
            size: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Icon(
              Icons.favorite,
              size: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Icon(
              Icons.local_bar,
              size: 25,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Icon(
              Icons.live_tv,
              size: 25,
            ),
          ),
          Icon(
            Icons.assignment,
            size: 25,
          ),
        ],
        isSelected: isSelected,
        onPressed: (int index) {
          setState(() {
            // for (int buttonIndex = 0;
            //     buttonIndex < isSelected.length;
            //     buttonIndex++) {
            //   if (buttonIndex == index) {
            //     isSelected[buttonIndex] = true;
            //   } else {
            //     isSelected[buttonIndex] = false;
            //   }
            // }

            isSelected[index] = !isSelected[index];
            HapticFeedback.mediumImpact();
          });
        },
      ),
    );
  }
}
