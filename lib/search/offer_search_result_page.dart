import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/offer/offer_list.dart';
import 'package:study_matching/search/offer_search_result_bloc.dart';

class OfferSearchResultPage extends StatelessWidget {
  OfferSearchResultPage({this.queryTagList});

  static const String name = '検索結果';

  final List<int> queryTagList;

  @override
  Widget build(BuildContext context) {
    final offerSearchResultBloc = Provider.of<OfferSearchResultBloc>(context);
    offerSearchResultBloc.searchOffers(queryTagList: queryTagList);
    return Scaffold(
        appBar: AppBar(brightness: Brightness.dark, title: Text(name)),
        body: SafeArea(
            top: false,
            child: StreamBuilder(
                initialData: offerSearchResultBloc.offers.value,
                stream: offerSearchResultBloc.offers,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(child: OfferList(offers: snapshot.data));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })));
  }
}
