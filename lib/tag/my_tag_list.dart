import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/tag/my_tag_bloc.dart';

class MyTagList extends StatelessWidget {
  MyTagList({@required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context) {
    final myTagBloc = Provider.of<MyTagBloc>(context);
    myTagBloc.fetchUserHavingTags(userId);
    return StreamBuilder(
        initialData: myTagBloc.tags.value,
        stream: myTagBloc.tags,
        builder: (context, snapshot) {
          print(snapshot.data);
          final tagList = snapshot.data;
          if (tagList != null) {
            return ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: tagList.length ~/ 3 + 1,
                itemBuilder: (context, int index) {
                  return Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Container(
                          height: 28,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: tagList.length > (index + 1) * 3
                                  ? 3
                                  : tagList.length - (index) * 3,
                              itemBuilder: (context, int horizontalIndex) {
                                return Padding(
                                    padding: EdgeInsets.only(right: 4),
                                    child: ButtonTheme(
                                        minWidth: 60,
                                        child: FlatButton(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            onPressed: () {},
                                            child: Text(
                                              tagList[index * 3 +
                                                      horizontalIndex]
                                                  .name,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                            color: Colors.orange)));
                              })));
                });
          } else {
            return Container();
          }
        });
  }
}
