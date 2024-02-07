import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 10,
      height: 50,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          press();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 4,
                blurRadius: 6,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BoldButton extends StatelessWidget {
  const BoldButton({
    Key key,
    this.text,
    this.icon,
    this.press,
  }) : super(key: key);
  final String text;
  final IconData icon;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xFFF5F6F9),
        onPressed: () {
          HapticFeedback.mediumImpact();
          press();
        },
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.green.shade300,
              size: 22.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
            SizedBox(width: 20),
            Expanded(child: Text(text)),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}


