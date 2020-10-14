import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/notice/notice_icon_button.dart';
import 'package:study_matching/offer/user_offers_set_bloc.dart';
import 'package:study_matching/offer/user_offers_set_list.dart';
import 'package:study_matching/search/offer_search_page.dart';

class UserOffersSetListPage extends StatelessWidget {
  static const String name = '募集を探す';
  static const Icon icon = Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<UserOffersSetBloc>(context);
    return Scaffold(
        appBar: AppBar(
            title: Text(name),
            brightness: Brightness.dark,
            leading: NoticeIconButton(),
            actions: <Widget>[
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
        body: StreamUserOffersSetList(bloc: bloc));
  }
}
