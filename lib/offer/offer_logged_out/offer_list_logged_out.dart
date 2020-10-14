import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_matching/no_login_alert.dart';
import 'package:study_matching/offer/offer.dart';
import 'package:study_matching/offer/offer_logged_out/offer_box_logged_out.dart';

class StreamOfferListLoggedOut extends StatelessWidget {
  StreamOfferListLoggedOut({this.bloc});

  final bloc;

  @override
  Widget build(BuildContext context) => StreamBuilder(
      initialData: bloc.offers.value,
      stream: bloc.offers,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text("エラーが発生しました");

        if (snapshot.hasData) {
          final offers = snapshot.data;
          return Padding(
              padding: EdgeInsets.all(8.0),
              child: OfferListLoggedOut(offers: offers));
        } else
          return Text("データがありません");
      });
}

class OfferListLoggedOut extends StatelessWidget {
  OfferListLoggedOut({@required this.offers});

  final List<Offer> offers;
  @override
  Widget build(BuildContext context) => InkWell(
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: offers.length,
              itemBuilder: (context, int index) => Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => noLoginAlert(context))),
                      child: OfferBoxLoggedOut(
                        offer: offers[index],
                      ))))));
}
