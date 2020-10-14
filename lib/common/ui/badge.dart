import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Badge extends StatelessWidget {
  final Widget icon;
  final int number;
  final double badgeRightMargin;

  Badge(
      {@required this.icon,
      @required this.number,
      @required this.badgeRightMargin});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Stack(children: <Widget>[
          Center(child: icon),
          Positioned(
              right: badgeRightMargin,
              child: Container(
                padding: EdgeInsets.all(1),
                decoration: new BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  number.toString(),
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ))
        ]));
  }
}
