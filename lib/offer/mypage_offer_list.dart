import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/offer/mypage_offer_list_bloc.dart';
import 'package:study_matching/offer/offer_list.dart';

class MyPageOfferList extends StatelessWidget {
  MyPageOfferList({this.userId});
  final int userId;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<MyPageOfferListBloc>(context);
    bloc.fetchOffers(userId);
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
                padding: EdgeInsets.all(8.0),
                child: RefreshIndicator(
                    child: OfferList(offers: offers),
                    onRefresh: () async {
                      await bloc.fetchOffers(userId);
                    }));
          } else {
            return Text("has no data");
          }
        });
  }
}
