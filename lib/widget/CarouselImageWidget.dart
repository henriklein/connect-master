import 'package:flutter/cupertino.dart';

class CarouselImageWidget extends StatelessWidget {
  final String media;
  final double topRight;
  final double topLeft;
  final double bottomRight;
  final double bottomLeft;

  const CarouselImageWidget({Key key, this.media, this.topRight, this.topLeft, this.bottomRight, this.bottomLeft}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(topRight),
          topLeft: Radius.circular(topLeft),
          bottomRight: Radius.circular(bottomRight),
          bottomLeft: Radius.circular(bottomLeft),
        ),
        child: Image.network(
          media,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
