// Uncomment this to allow access on profile page w/o log-in

/*
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/common/ui/standard_selectable_autolink_text.dart';
import 'package:study_matching/offer/offer_details_page_logged_out.dart';
import 'package:study_matching/offer/profile_offer_list_logged_out.dart';
import 'package:study_matching/tag/user_having_tag_list.dart';
import 'package:study_matching/user/user.dart';
import 'package:study_matching/user/user_bloc.dart';
import 'package:study_matching/user_review/user_review_list.dart';
import 'package:study_matching/user_review/user_review_page.dart';
import 'package:study_matching/user_review/user_review_page_arguments.dart';

import 'offer/profile_offer_list_bloc_logged_out.dart';

class ProfilePageLoggedOut extends StatefulWidget {
  ProfilePageLoggedOut({@required this.userId});
  final int userId;

  @override
  _ProfilePageLoggedOutState createState() =>
      _ProfilePageLoggedOutState(id: userId);
}

class _ProfilePageLoggedOutState extends State<ProfilePageLoggedOut> {
  _ProfilePageLoggedOutState({@required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    final userBloc = Provider.of<UserBloc>(context);
    userBloc.fetchUser(widget.userId);
    final profileOfferListBlocLoggedOut =
        Provider.of<ProfileOfferListBlocLoggedOut>(context);
    profileOfferListBlocLoggedOut.fetchOffersLoggedOut(widget.userId);
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              brightness: Brightness.dark,
              title: Text('プロフィール'),
              bottom: TabBar(
                isScrollable: false,
                tabs: [
                  Tab(
                    text: "プロフィール情報",
                  ),
                  Tab(text: "募集"),
                ],
              ),
              actions: <Widget>[
                StreamBuilder(
                  initialData: userBloc.user.value,
                  stream: userBloc.user,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data != null)
                      return PopupMenuButton(
                        icon: Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                        ),
                      );
                    else
                      return Container();
                  },
                )
              ],
            ),
            body: SafeArea(
              top: false,
              child: StreamBuilder(
                  stream: userBloc.isLoading,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    final isLoading = snapshot.data as bool;
                    if (isLoading)
                      return Center(child: CircularProgressIndicator());
                    else
                      return StreamBuilder(
                          initialData: userBloc.user.value,
                          stream: userBloc.user,
                          builder: (context, snapshot) {
                            if (snapshot.data == null)
                              return Center(child: CircularProgressIndicator());
                            final User user = snapshot.data;
                            return TabBarView(children: <Widget>[
                              SingleChildScrollView(
                                  child: Center(
                                      child: Column(children: <Widget>[
                                SizedBox(height: 10),
                                Container(
                                    height: 100,
                                    child: CachedNetworkImage(
                                        imageUrl: user.iconUrl ??
                                            'http://design-ec.com/d/e_others_50/m_e_others_501.jpg')),
                                Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      user.username,
                                      style: Theme.of(context).textTheme.title,
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 16),
                                    child: FakeMoveToChatPageButton()),
                                ProfileLabel(labelText: 'プロフィール'),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: StandardSelectableAutoLinkText(
                                    user.description,
                                  ),
                                ),
                                ProfileLabel(labelText: '相談にのれること'),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child:
                                      UserHavingTagList(userId: widget.userId),
                                ),
                                ProfileLabel(labelText: 'レビュー'),
                                Padding(
                                    padding: EdgeInsets.all(16),
                                    child: RaisedButton(
                                      onPressed: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => UserReviewPage(),
                                        settings: RouteSettings(
                                            arguments: UserReviewPageArguments(
                                                reviewee: user.id.toString(),
                                                revieweeUserName:
                                                    user.username)),
                                      )),
                                      child: Text('このユーザのレビューを書く'),
                                    )),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: UserReviewList(userId: user.id),
                                ),
                              ]))),
                              ProfileUserOfferListLoggedOut(userId: user.id)
                            ]);
                          });
                  }),
            )));
  }
}

class ProfileLabel extends StatelessWidget {
  ProfileLabel({@required this.labelText});

  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: double.infinity,
      color: Colors.grey[300],
      child: Padding(
          padding: EdgeInsets.only(left: 16),
          child:
              Align(alignment: Alignment.centerLeft, child: Text(labelText))),
    );
  }
}
*/
