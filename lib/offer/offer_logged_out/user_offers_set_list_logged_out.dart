import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:study_matching/no_login_alert.dart';
import 'package:study_matching/offer/offer_logged_out/offer_box_logged_out.dart';
import 'package:study_matching/offer/offer_logged_out/user_offers_set_bloc_logged_out.dart';
import 'package:study_matching/offer/user_offers_set.dart';
import 'package:study_matching/user/user.dart';

class StreamUserOffersSetListLoggedOut extends StatelessWidget {
  StreamUserOffersSetListLoggedOut({this.bloc});
  final UserOffersSetBlocLoggedOut bloc;

  Future<void> _onRefreshUserOfferSetStaggeredList() async =>
      await bloc.fetchUserOffersSets();

  @override
  Widget build(BuildContext context) {
    bloc.fetchUserOffersSets();
    return StreamBuilder(
        initialData: bloc.userOffersSetList.value,
        stream: bloc.userOffersSetList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          assert(context != null);
          if (snapshot.hasError)
            return Text("エラーが発生しました");
          else if (snapshot.hasData) {
            final userOffersSetList = snapshot.data;
            return Padding(
                padding: EdgeInsets.all(8.0),
                child: RefreshIndicator(
                    onRefresh: _onRefreshUserOfferSetStaggeredList,
                    child: UserOfferSetStaggeredListLoggedOut(
                        userOffersSetList: userOffersSetList)));
          } else
            return Center(child: Text("データがありません"));
        });
  }
}

class UserOfferSetStaggeredListLoggedOut extends StatelessWidget {
  UserOfferSetStaggeredListLoggedOut({@required this.userOffersSetList});
  final List<UserOffersSet> userOffersSetList;

  @override
  Widget build(BuildContext context) {
    final List<UserOffersSet> emptyCheckedUserOffersSetList = userOffersSetList
        .where((UserOffersSet v) => v.offers.length != 0)
        .toList();
    return StaggeredGridView.countBuilder(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        staggeredTileBuilder: (int index) {
          if (emptyCheckedUserOffersSetList[index].offers.length == 1)
            return StaggeredTile.count(1, 2);
          else if (emptyCheckedUserOffersSetList[index].offers.length == 2)
            return StaggeredTile.count(1, 3);
          else if (emptyCheckedUserOffersSetList[index].offers.length >= 3)
            return StaggeredTile.count(1, 3.2);
          else
            return null;
        },
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        scrollDirection: Axis.vertical,
        itemCount: emptyCheckedUserOffersSetList.length,
        itemBuilder: (context, int index) {
          if (emptyCheckedUserOffersSetList[index].offers.length == 1)
            return Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: ListView.builder(
                    primary: false,
                    itemCount: 2,
                    itemBuilder: (context, int _index) {
                      if (_index == 0)
                        return UserBoxLoggedOut(
                            user: emptyCheckedUserOffersSetList[index].user);
                      else
                        return OfferBoxLoggedOut(
                            offer: emptyCheckedUserOffersSetList[index]
                                .offers[_index - 1]);
                    }));
          else if (emptyCheckedUserOffersSetList[index].offers.length == 2)
            return Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: ListView.builder(
                    primary: false,
                    itemCount: 3,
                    itemBuilder: (context, int _index) {
                      if (_index == 0)
                        return UserBoxLoggedOut(
                            user: emptyCheckedUserOffersSetList[index].user);
                      else
                        return OfferBoxLoggedOut(
                            offer: emptyCheckedUserOffersSetList[index]
                                .offers[_index - 1]);
                    }));
          else if (emptyCheckedUserOffersSetList[index].offers.length >= 3) {
            final latestTwoUserOfferSet = [
              emptyCheckedUserOffersSetList[index].offers[0],
              emptyCheckedUserOffersSetList[index].offers[1]
            ];
            return Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: ListView.builder(
                    primary: false,
                    itemCount: 4,
                    itemBuilder: (context, int _index) {
                      if (_index == 0)
                        return UserBoxLoggedOut(
                            user: emptyCheckedUserOffersSetList[index].user);
                      else if (0 < _index && _index < 3)
                        return OfferBoxLoggedOut(
                            offer: latestTwoUserOfferSet[_index - 1]);
                      else
                        return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: RaisedButton(
                                child: Text("もっと見る"),
                                color: Colors.white,
                                shape: Border(
                                  top: BorderSide(color: Colors.lightBlue),
                                  left: BorderSide(color: Colors.lightBlue),
                                  right: BorderSide(color: Colors.lightBlue),
                                  bottom: BorderSide(color: Colors.lightBlue),
                                ),
                                splashColor: Colors.lightBlue,
                                onPressed: () => noLoginAlert(context)));
                    }));
          } else
            return null;
        });
  }
}

class UserBoxLoggedOut extends StatelessWidget {
  UserBoxLoggedOut({@required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => noLoginAlert(context),
        child: AspectRatio(
            aspectRatio: 1,
            child: Card(
              child: Container(
                child: Column(children: <Widget>[
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: CachedNetworkImageProvider(user.iconUrl ??
                          'http://design-ec.com/d/e_others_50/m_e_others_501.jpg'),
                      fit: BoxFit.contain,
                    )),
                  )),
                  Padding(
                      padding: EdgeInsets.only(right: 8.0, left: 8.0),
                      child: Text(
                        user.username,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(),
                      child: Text(user.faculty != '' ? user.faculty : '学部未設定')),
                  Padding(
                      padding: EdgeInsets.only(),
                      child: Text(user.grade != '' ? user.grade : '学年未設定')),
                ]),
              ),
            )));
  }
}
