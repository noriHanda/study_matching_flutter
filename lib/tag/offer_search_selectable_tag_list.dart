import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/tag/offer_search_selected_tag_bloc.dart';
import 'package:study_matching/tag/tag_bloc.dart';

class OfferSearchSelectableTagList extends StatefulWidget {
  @override
  _OfferSearchSelectableTagListState createState() {
    return _OfferSearchSelectableTagListState();
  }
}

class _OfferSearchSelectableTagListState
    extends State<OfferSearchSelectableTagList> {
  List<int> selectedTagIdList = [];

  OfferSearchSelectedTagBloc selectedTagBloc;

  @override
  Widget build(BuildContext context) {
    final tagListBloc = Provider.of<TagBloc>(context);
    selectedTagBloc = Provider.of<OfferSearchSelectedTagBloc>(context);
    tagListBloc.fetchTags();
    //print(tagList);
    return StreamBuilder(
        initialData: selectedTagBloc.ids.value,
        stream: selectedTagBloc.ids,
        builder: (parentCntext, selectedTagIdsSnapshot) {
          final fetchedSelectedTagIdList = selectedTagIdsSnapshot.data;
          if (fetchedSelectedTagIdList != null) {
            selectedTagIdList = fetchedSelectedTagIdList;
          }
          return StreamBuilder(
              initialData: tagListBloc.tags.value,
              stream: tagListBloc.tags,
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
                                    itemBuilder:
                                        (context, int horizontalIndex) {
                                      return Padding(
                                          padding: EdgeInsets.only(right: 4),
                                          child: ButtonTheme(
                                              minWidth: 60,
                                              child: FlatButton(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8),
                                                onPressed: () {
                                                  final id = index * 3 +
                                                      horizontalIndex;
                                                  if (selectedTagIdList
                                                      .contains(
                                                          tagList[id].id)) {
                                                    selectedTagIdList
                                                        .remove(tagList[id].id);
                                                  } else {
                                                    selectedTagIdList
                                                        .add(tagList[id].id);
                                                  }
                                                  setState(() {
                                                    selectedTagBloc
                                                        .setSelectedTagIdList
                                                        .add(selectedTagIdList);
                                                  });
                                                },
                                                child: Text(
                                                  tagList[index * 3 +
                                                          horizontalIndex]
                                                      .name,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                                color: selectedTagIdList
                                                        .contains(tagList[index *
                                                                    3 +
                                                                horizontalIndex]
                                                            .id)
                                                    ? Colors.orange
                                                    : Colors.grey,
                                              )));
                                    })));
                      });
                } else {
                  return Container();
                }
              });
        });
  }
}
