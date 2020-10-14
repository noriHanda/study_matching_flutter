import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/offer/offer_api.dart';
import 'package:study_matching/offer/offer_bloc.dart';
import 'package:study_matching/offer/offer_update_form.dart';

import 'matching_way_description.dart';

class OfferUpdatePage extends StatelessWidget {
  final offerApi = OfferApi();

  @override
  Widget build(BuildContext context) {
    final offerId = ModalRoute.of(context).settings.arguments as int;
    final bloc = Provider.of<OfferBloc>(context);
    return Scaffold(
        appBar: AppBar(brightness: Brightness.dark, title: Text('募集編集')),
        body: SafeArea(
            top: false,
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                OfferUpdateForm(offerId: offerId),
                Padding(
                    padding: EdgeInsets.only(bottom: 32),
                    child: RaisedButton(
                        child: Text(
                          '　削除　',
                          style: TextStyle(color: Colors.black),
                        ),
                        color: Colors.white,
                        shape: Border(
                          top: BorderSide(color: Colors.red),
                          left: BorderSide(color: Colors.red),
                          right: BorderSide(color: Colors.red),
                          bottom: BorderSide(color: Colors.red),
                        ),
                        splashColor: Colors.red,
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => AlertDialog(
                                    title: Text("確認"),
                                    content: Text("本当に削除しますか？"),
                                    actions: <Widget>[
                                      // ボタン領域
                                      FlatButton(
                                        child: Text("キャンセル"),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      FlatButton(
                                          child: Text(
                                            "削除",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () async {
                                            final isSuccess =
                                                await offerApi.delete(offerId);
                                            if (isSuccess) {
                                              bloc.fetchOffers();
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (_) => AlertDialog(
                                                          title: Text("削除完了"),
                                                          content: Text(
                                                              "正常に削除されました。"),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                                child: Text(
                                                                  "確認",
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.popUntil(
                                                                      context,
                                                                      (Route<dynamic>
                                                                              route) =>
                                                                          route
                                                                              .isFirst);
                                                                })
                                                          ]));
                                            } else {
                                              final snackBar = SnackBar(
                                                  content:
                                                      Text('募集の削除に失敗しました。'));
                                              Scaffold.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          }),
                                    ],
                                  ));
                        })),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: MatchingWayDescription(),
                ),
              ],
            ))));
  }
}
