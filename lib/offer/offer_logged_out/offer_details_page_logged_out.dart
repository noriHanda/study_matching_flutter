/*
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/common/ui/standard_selectable_autolink_text.dart';
import 'package:study_matching/no_login_alert.dart';
import 'package:study_matching/offer/offer.dart';
import 'package:study_matching/offer/offer_bloc.dart';
import 'package:study_matching/offer/offer_update_page.dart';
import 'package:study_matching/profile_page.dart';
import 'package:study_matching/profile_page_logged_out.dart';
import 'package:study_matching/user/user_api.dart';

class OfferDetailsPageLoggedOut extends StatefulWidget {
  OfferDetailsPageLoggedOut({@required this.id});

  final int id;
  @override
  _OfferDetailsPageLoggedOutState createState() =>
      _OfferDetailsPageLoggedOutState(id: id);
}

class _OfferDetailsPageLoggedOutState extends State<OfferDetailsPageLoggedOut> {
  _OfferDetailsPageLoggedOutState({@required this.id});

  final int id;
  final _userApi = UserApi();

  @override
  Widget build(BuildContext context) {
    final offerBloc = Provider.of<OfferBloc>(context);
    offerBloc.fetchOffers();
    return Scaffold(
        appBar: AppBar(
            brightness: Brightness.dark,
            title: Text('募集'),
            actions: <Widget>[
              StreamBuilder(
                  initialData: offerBloc.offers.value,
                  stream: offerBloc.offers,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return Text('エラーが発生しました');
                    if (snapshot.hasData) {
                      if (snapshot.data != []) {
                        final List<Offer> offers = snapshot.data;
                        final List<Offer> offersFoundById =
                            offers.where((x) => x.id == id).toList();
                        if (offersFoundById != [] &&
                            offersFoundById.length == 1) {
                          final offer = offersFoundById[0];
                          return IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => OfferUpdatePage(),
                                        settings: RouteSettings(
                                          arguments: offer.id.toInt(),
                                        )),
                                  ));
                        }
                      }
                    }
                    return Container();
                  }),
            ]),
        body: SafeArea(
            top: false,
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: StreamBuilder(
                        initialData: offerBloc.offers.value,
                        stream: offerBloc.offers,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) return Text("エラーが発生しました");
                          if (snapshot.hasData) {
                            if (snapshot.data != []) {
                              final List<Offer> offers = snapshot.data;
                              final List<Offer> offersFoundById =
                                  offers.where((x) => x.id == id).toList();
                              if (offersFoundById != [] &&
                                  offersFoundById.length == 1) {
                                final offer = offersFoundById[0];
                                final futureUser =
                                    _userApi.fetchUserLoggedOut(offer.userId);
                                return FutureBuilder(
                                    future: futureUser,
                                    builder: (context, userSnapshot) {
                                      if (!userSnapshot.hasData)
                                        return Center(child: CircularProgressIndicator());
                                      else {
                                        final UserResult userResult =
                                            userSnapshot.data;
                                        if (userResult.statusCode != 200)
                                          return Center(child: CircularProgressIndicator());
                                        else {
                                          final user = userResult.user;
                                          return Column(children: <Widget>[
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 16.0),
                                                child: Center(
                                                    child: Container(
                                                  height: 150,
                                                  child: CachedNetworkImage(
                                                      imageUrl: offer.iconUrl ??
                                                          'http://design-ec.com/d/e_others_50/m_e_others_501.jpg'),
                                                ))),
                                            Row(children: <Widget>[
                                              Spacer(flex: 1),
                                              Flexible(
                                                  flex: 6,
                                                  child: Text(
                                                    offer.title,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline,
                                                  )),
                                              Spacer(flex: 1),
                                            ]),
                                            GestureDetector(
                                              onTap: () => Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfilePage(
                                                              userId:
                                                                  user.id))),
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 16.0),
                                                  child: Center(
                                                      child: Container(
                                                          height: 50,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              CachedNetworkImage(
                                                                  imageUrl: user
                                                                          .iconUrl ??
                                                                      'http://design-ec.com/d/e_others_50/m_e_others_501.jpg'),
                                                              Text(user
                                                                  .username),
                                                            ],
                                                          )))),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child:
                                                    StandardSelectableAutoLinkText(
                                                        offer.description)),
                                            Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child:
                                                    FakeMoveToChatPageButton()),
                                            Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: RaisedButton(
                                                    onPressed: () => Navigator
                                                            .of(context)
                                                        .push(MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProfilePageLoggedOut(
                                                                    userId: user
                                                                        .id))),
                                                    child: Text(
                                                        'このユーザのプロフィールを見てみる')))
                                          ]);
                                        }
                                      }
                                    });
                              } else
                                return Text('この募集は削除されました。もしくは一時的な問題が発生しています。');
                            } else
                              return Text("データアレイがありません");
                          } else
                            return Text("データがありません");
                        })))));
  }
}

class FakeMoveToChatPageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => RaisedButton(
      onPressed: () => noLoginAlert(context), child: Text('このユーザとチャットしてみる'));
}
*/
