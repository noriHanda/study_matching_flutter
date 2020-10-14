import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_matching/offer/offer.dart';
import 'package:study_matching/offer/offer_box.dart';
import 'package:study_matching/offer/offer_details_page.dart';

class StreamOfferList extends StatelessWidget {
  StreamOfferList({this.bloc});

  final bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: bloc.offers.value,
        stream: bloc.offers,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("error occured");
          }
          if (snapshot.hasData) {
            final offers = snapshot.data;
            print(offers);

            return Padding(
                padding: EdgeInsets.all(8.0), child: OfferList(offers: offers));
          } else {
            return Text("has no data");
          }
        });
  }
}

class OfferList extends StatelessWidget {
  OfferList({@required this.offers});

  final List<Offer> offers; //
  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: offers.length,
                itemBuilder: (context, int index) {
                  //offers[index].title =
                  //    'プログラミング教えます。Webサイト作成できるようになりたい方へ！';
                  return Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    OfferDetailsPage(id: offers[index].id),
                                settings:
                                    RouteSettings(name: 'OfferDetailsPage'),
                              ),
                            );
                          },
                          child: OfferBox(
                            offer: offers[index],
                          )));
                })));
  }
}
