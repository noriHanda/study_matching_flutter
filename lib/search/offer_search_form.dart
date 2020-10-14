import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/offer/offer.dart';
import 'package:study_matching/search/offer_search_result_page.dart';
import 'package:study_matching/tag/offer_search_selectable_tag_list.dart';
import 'package:study_matching/tag/offer_search_selected_tag_bloc.dart';

class OfferSearchForm extends StatefulWidget {
  final Offer offer;

  OfferSearchForm({Key key, this.offer}) : super(key: key);

  @override
  OfferSearchFormState createState() => OfferSearchFormState();
}

class OfferSearchFormState extends State<OfferSearchForm> {
  /*
  String dropdownValue = '経済学部';
  List<String> dropdownValueList = ['経済学部', '文学部', '工学部', '理学部'];
  */

  @override
  Widget build(BuildContext context) {
    final selectedTagBloc = Provider.of<OfferSearchSelectedTagBloc>(context);
    // TODO: implement build
    return Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(children: <Widget>[
          SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                /*
                OfferSearchFormSectionLabel(labelText: '学部'),
                Padding(
                    padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: dropdownValueList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )),
                    */
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                  child:
                      Text('検索機能は後日アップデート予定です。「相談にのれること」以外の条件でも検索可能になる予定です。'),
                ),
                OfferSearchFormSectionLabel(labelText: '相談にのれること'),
                Padding(
                    padding: EdgeInsets.only(left: 16, top: 16, bottom: 64),
                    child: OfferSearchSelectableTagList()),
              ])),
          Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    color: Colors.white,
                  ),
                  height: 52,
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: [
                    RaisedButton(
                        child: Text('検索'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OfferSearchResultPage(
                                  queryTagList: selectedTagBloc.ids.value),
                              settings:
                                  RouteSettings(name: 'OfferSearchResultPage'),
                            ),
                          );
                        })
                    /*
                    Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Align(
                                alignment: Alignment.center,
                                child: Text('x件'))),
                        Expanded(
                            flex: 2,
                            child: RaisedButton(
                              child: Text('絞り込む'),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => OfferSearchResultPage(
                                        queryTagList:
                                            selectedTagBloc.ids.value)));
                              },
                            ))
                      ],
                    )
                    */
                  ])))
        ]));
  }
}

class OfferSearchFormSectionLabel extends StatelessWidget {
  OfferSearchFormSectionLabel({@required this.labelText});

  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 32,
        color: Colors.grey[300],
        child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsets.only(left: 16), child: Text(labelText))));
  }
}
