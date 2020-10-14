import 'package:flutter/material.dart'
    show
        AppBar,
        Brightness,
        BuildContext,
        Icon,
        IconButton,
        Icons,
        Scaffold,
        StatelessWidget,
        Text,
        Widget;
import 'package:provider/provider.dart' show Provider;
import 'package:study_matching/no_login_alert.dart';
import 'package:study_matching/offer/offer_logged_out/user_offers_set_bloc_logged_out.dart'
    show UserOffersSetBlocLoggedOut;
import 'package:study_matching/offer/offer_logged_out/user_offers_set_list_logged_out.dart'
    show StreamUserOffersSetListLoggedOut;

class UserOffersSetListPageLoggedOut extends StatelessWidget {
  static const String name = '募集を探す';
  static const Icon icon = Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<UserOffersSetBlocLoggedOut>(context);
    return Scaffold(
        appBar: AppBar(
            title: Text(name),
            brightness: Brightness.dark,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => noLoginAlert(context))
            ]),
        body: StreamUserOffersSetListLoggedOut(bloc: bloc));
  }
}
