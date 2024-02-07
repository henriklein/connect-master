
import 'package:c0nnect/helper/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomizeEmojiWidget extends StatefulWidget {

  final ValueChanged<Color> backgroundColorListener;
  final ValueChanged<String> editListener;
  final String selectedEmoji;

  const CustomizeEmojiWidget({Key key, this.backgroundColorListener, this.selectedEmoji, this.editListener}) : super(key: key);

  @override
  _CustomizeEmojiWidgetState createState() => _CustomizeEmojiWidgetState();
}

class _CustomizeEmojiWidgetState extends State<CustomizeEmojiWidget> {

  Color emojiBackgroundColor = Colors.grey.withOpacity(0.5);

  List<ColorModel> emojiColorList = [
    ColorModel(true,Colors.grey.withOpacity(0.5)),
     ColorModel(false,Colors.pink.withOpacity(0.5)),
    ColorModel(false,Colors.red.withOpacity(0.5)),
    ColorModel(false,Colors.orange.withOpacity(0.5)),
  ColorModel(false,Colors.yellow.withOpacity(0.5)),
  ColorModel(false,Colors.amber.withOpacity(0.5)),
    ColorModel(false,Colors.green.withOpacity(0.5)),
    ColorModel(false,Colors.lightBlue.withOpacity(0.5)),
    ColorModel(false,Colors.blue.withOpacity(0.5)),
    ColorModel(false,Colors.purple.withOpacity(0.5))
  ];


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 10,
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey[300]),
          ),
          Text(
            Strings.emoji_profile_image,
            style: TextStyle(
                color: Colors.black,
                letterSpacing: 1.0,
                fontSize: 22,
                fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            Strings.emoji_profile_des,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[700],
                letterSpacing: 1.0,
                fontSize: 18,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120.0,
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: emojiBackgroundColor,
                      ),
                      child: Center(
                        child: Text(
                          widget.selectedEmoji ?? "",
                          style: TextStyle(
                              letterSpacing: 1.0,
                              fontSize: 45,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 20,
                      child: InkWell(
                        onTap: () {
                          widget.editListener("edit");
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              color: Colors.white,
                              boxShadow: [BoxShadow(blurRadius: 2)]),
                          child: Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Wrap(
                      children: emojiColorList.map((e) {
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              deselectBackgroundColor();
                              e.isSelected = true;
                              emojiBackgroundColor = e.color;
                            });
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(22)),
                              border: Border.all(
                                width: 3,
                                color: e.isSelected ? e.color : Colors.transparent,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                color: e.color,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
          ),

          InkWell(
            onTap: (){
              widget.backgroundColorListener(emojiBackgroundColor);
            },
            child: Container(
              width: Get.width,
              margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.blue[500]),
              child: Center(
                child: Text(Strings.save,
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.0,
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deselectBackgroundColor(){
    for(int i=0;i<emojiColorList.length;i++){
      emojiColorList[i].isSelected = false;
    }
  }

}

class ColorModel {
  bool _isSelected = false;
  Color _color;


  ColorModel(this._isSelected, this._color);

  bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
  }

  Color get color => _color;

  set color(Color value) {
    _color = value;
  }


}

