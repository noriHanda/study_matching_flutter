import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadIndicator extends StatelessWidget {
  const LoadIndicator({this.visible});
  final bool visible;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: IgnorePointer(
        ignoring: !visible,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: visible ? 1 : 0,
          child: SizedBox(
            width: 60,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.58),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Stack(
                children: const <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: CupertinoActivityIndicator(
                      radius: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
