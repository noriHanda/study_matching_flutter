import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/offer/offer_bloc.dart';
import 'package:study_matching/offer/offer_list.dart';
import 'package:study_matching/search/offer_search_page.dart';

class OfferListPage extends StatelessWidget {
  static const String name = '募集を探す';
  static const Icon icon = Icon(Icons.search);
  //List<Offer> offers;

  //OfferListPage({this.offers});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<OfferBloc>(context);
    return Scaffold(
        appBar: AppBar(
            title: Text(name),
            brightness: Brightness.dark,
            actions: <Widget>[
              // action button
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OfferSearchPage(),
                        settings: RouteSettings(name: 'OfferSearchPage'),
                      ),
                    );
                  })
            ]),
        body: StreamOfferList(bloc: bloc));
  }
}
