import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/offer/offer.dart';
import 'package:study_matching/offer/offer_bloc.dart';
import 'package:study_matching/offer/offer_update_page.dart';

class OfferCreateConfirmationPage extends StatelessWidget {
  OfferCreateConfirmationPage({@required this.id});

  final int id;
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<OfferBloc>(context);

    bloc.fetchOffers();
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OfferUpdatePage(),
                  settings: RouteSettings(
                    name: 'OfferUpdatePage',
                    arguments: id,
                  ),
                ),
              ),
              tooltip: "投稿の編集",
            )
          ],
          title: Text('募集'),
        ),
        body: SafeArea(
            top: false,
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: StreamBuilder(
                    initialData: bloc.offers.value,
                    stream: bloc.offers,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("error occured");
                      }
                      if (snapshot.hasData) {
                        if (snapshot.data != []) {
                          final List<Offer> offers = snapshot.data;
                          // 以下は基本的には一つしかないが、言語機能的にこうするしかない
                          final List<Offer> offersFoundbyId =
                              offers.where((x) => x.id == id).toList();
                          if (offersFoundbyId != [] &&
                              offersFoundbyId.length == 1) {
                            final offer = offersFoundbyId[0];
                            print(offer);
                            return Column(children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(top: 16.0),
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
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    )),
                                Spacer(flex: 1),
                              ]),
                              Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(offer.description)),
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: 12, left: 12),
                                  child: Text(
                                    'マッチ方法: ' + offer.matchingWay,
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  )),
                            ]);
                          } else {
                            return Text('この募集は削除されました。もしくは一時的な問題が発生しています。');
                          }
                        } else {
                          return Text("has no array data");
                        }
                      } else {
                        return Text("has no data");
                      }
                    }))));
  }
}
