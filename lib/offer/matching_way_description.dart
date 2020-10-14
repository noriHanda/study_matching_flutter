import 'package:flutter/material.dart';

class MatchingWayDescription extends StatelessWidget {
  final double descriptionFontSize = 10.0;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.help,
          size: 12.0,
        ),
        SizedBox(
          width: 4.0,
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: '・会って話したい場合、',
                  style: TextStyle(fontSize: descriptionFontSize),
                ),
                TextSpan(
                  text: 'ぜひ会いましょう！',
                  style: TextStyle(
                      fontSize: descriptionFontSize,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: 'に\n'
                      '・ビデオ通話かチャットをメインにしたい場合、',
                  style: TextStyle(fontSize: descriptionFontSize),
                ),
                TextSpan(
                  text: 'オンラインで！',
                  style: TextStyle(
                      fontSize: descriptionFontSize,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: 'に\n'
                      '・どちらでもいい場合、',
                  style: TextStyle(fontSize: descriptionFontSize),
                ),
                TextSpan(
                  text: 'どちらでも！',
                  style: TextStyle(
                      fontSize: descriptionFontSize,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: 'に',
                  style: TextStyle(fontSize: descriptionFontSize),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
