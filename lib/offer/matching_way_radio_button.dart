import 'package:flutter/material.dart';

var matchingWays = {
  'Offline': 'ぜひ会いましょう！',
  'ChatMainly': 'オンラインで！',
  'Either': 'どちらでも！'
};

class RadioButton extends StatefulWidget {
  RadioButton({Key key}) : super(key: key);

  @override
  RadioButtonState createState() => RadioButtonState();
}

class RadioButtonState extends State<RadioButton> {
  static String matchingWay = matchingWays['ChatMainly'];

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RadioListTile(
          title: Text(matchingWays['Offline']),
          value: matchingWays['Offline'],
          groupValue: matchingWay,
          onChanged: (value) {
            setState(() {
              matchingWay = value;
            });
          },
        ),
        RadioListTile(
          title: Text(matchingWays['ChatMainly']),
          value: matchingWays['ChatMainly'],
          groupValue: matchingWay,
          onChanged: (value) {
            setState(() {
              matchingWay = value;
            });
          },
        ),
        RadioListTile(
          title: Text(matchingWays['Either']),
          value: matchingWays['Either'],
          groupValue: matchingWay,
          onChanged: (value) {
            setState(() {
              matchingWay = value;
            });
          },
        ),
      ],
    );
  }
}
