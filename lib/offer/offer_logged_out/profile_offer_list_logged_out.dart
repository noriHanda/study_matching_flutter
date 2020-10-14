import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/offer/offer_logged_out/offer_list_logged_out.dart';
import 'package:study_matching/offer/profile_offer_list_bloc.dart';

class ProfileUserOfferListLoggedOut extends StatelessWidget {
  ProfileUserOfferListLoggedOut({this.userId});
  final int userId;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ProfileOfferListBloc>(context);
    return StreamBuilder(
        stream: bloc.isLoadingOffer,
        builder: (context, snapshot) {
          final isLoadingOffer = snapshot.data as bool;
          if (isLoadingOffer)
            return Center(child: CircularProgressIndicator());
          else
            return StreamBuilder(
                initialData: bloc.offers.value,
                stream: bloc.offers,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final offers = snapshot.data;
                    return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: RefreshIndicator(
                            child: OfferListLoggedOut(offers: offers),
                            onRefresh: () async =>
                                await bloc.fetchOffers(userId)));
                  } else
                    return Text("データがありません");
                });
        });
  }
}
