import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/auth/auth_bloc.dart';
import 'package:study_matching/common/ui/standard_selectable_autolink_text.dart';
import 'package:study_matching/offer/offer_details_page.dart';
import 'package:study_matching/offer/profile_offer_list.dart';
import 'package:study_matching/offer/profile_offer_list_bloc.dart';
import 'package:study_matching/report/report_form.dart';
import 'package:study_matching/tag/user_having_tag_list.dart';
import 'package:study_matching/user/user.dart';
import 'package:study_matching/user/user_bloc.dart';
import 'package:study_matching/user_block/user_block.dart';
import 'package:study_matching/user_block/user_block_api.dart';
import 'package:study_matching/user_block/user_block_list_bloc.dart';
import 'package:study_matching/user_review/user_review_list.dart';
import 'package:study_matching/user_review/user_review_page.dart';
import 'package:study_matching/user_review/user_review_page_arguments.dart';

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon});

  String title;
  IconData icon;
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  // CustomPopupMenu(title: 'シェア'),
  CustomPopupMenu(title: '非表示にする'),
  CustomPopupMenu(title: '不適切なユーザーの報告'),
];

class ProfilePage extends StatefulWidget {
  ProfilePage({@required this.userId});
  final int userId;

  @override
  _ProfilePageState createState() => _ProfilePageState(id: userId);
}

class _ProfilePageState extends State<ProfilePage> {
  _ProfilePageState({@required this.id});
  final int id;
  UserBlockListBloc userBlockListBloc;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<UserBloc>(context);
    userBlockListBloc = Provider.of<UserBlockListBloc>(context);
    final authBloc = Provider.of<AuthBloc>(context);
    bloc.fetchUser(widget.userId);
    final profileOfferListBloc = Provider.of<ProfileOfferListBloc>(context);
    profileOfferListBloc.fetchOffers(widget.userId);
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
                    initialData: bloc.user.value,
                    stream: bloc.user,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        final User user = snapshot.data;
                        if (authBloc.user.value != null &&
                            authBloc.user.value.id != user.id) {
                          return PopupMenuButton(
                            tooltip: 'ブロック・報告',
                            icon: Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                            onSelected: _select,
                            itemBuilder: (BuildContext context) {
                              return choices.map((CustomPopupMenu choice) {
                                return PopupMenuItem<CustomPopupMenu>(
                                  value: choice,
                                  child: Text(choice.title),
                                );
                              }).toList();
                            },
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    })
              ],
            ),
            body: SafeArea(
              top: false,
              child: StreamBuilder(
                  stream: bloc.isLoading,
                  builder: (context, snapshot) {
                    final isLoading = snapshot.data as bool;
                    if (isLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else
                      return StreamBuilder(
                          initialData: bloc.user.value,
                          stream: bloc.user,
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
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    )),
                                UserBlockLabel(
                                  userBlockListBloc: userBlockListBloc,
                                  profileUserId: widget.userId,
                                ),
                                authBloc.user.value != null &&
                                        authBloc.user.value.id != user.id
                                    ? Padding(
                                        padding: EdgeInsets.only(bottom: 16),
                                        child: MoveToChatPageButton(
                                          loginUserId: authBloc.user.value.id,
                                          partnerUserId: user.id,
                                        ))
                                    : Container(),
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
                                authBloc.user.value != null &&
                                        authBloc.user.value.id != user.id
                                    ? Padding(
                                        padding: EdgeInsets.all(16),
                                        child: RaisedButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  UserReviewPage(),
                                              settings: RouteSettings(
                                                  arguments:
                                                      UserReviewPageArguments(
                                                          reviewee: user.id
                                                              .toString(),
                                                          revieweeUserName:
                                                              user.username),
                                                  name: 'UserReviewPage'),
                                            ));
                                          },
                                          child: Text('このユーザをレビューする'),
                                          color: Colors.white,
                                          shape: Border(
                                            top: BorderSide(
                                                color: Colors.lightBlue),
                                            left: BorderSide(
                                                color: Colors.lightBlue),
                                            right: BorderSide(
                                                color: Colors.lightBlue),
                                            bottom: BorderSide(
                                                color: Colors.lightBlue),
                                          ),
                                          splashColor: Colors.lightBlue,
                                        ))
                                    : Container(),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: UserReviewList(userId: user.id),
                                ),
                              ]))),
                              ProfileUserOfferList(userId: user.id)
                            ]);
                          });
                  }),
            )));
  }

  CustomPopupMenu _selectedChoices = choices[0];

  void _select(CustomPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
    });
    if (_selectedChoices == choices[0]) {
      showUserBlockConfirmationDialog(
          context, widget.userId, userBlockListBloc);
    }
    if (_selectedChoices == choices[1]) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) {
                return ReportForm(
                  offererId: id,
                );
              },
              fullscreenDialog: true));
    }
  }
}

void showUserBlockConfirmationDialog(
    BuildContext context, int blockedUserId, userBlockListBloc) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
              title: Text("確認"),
              content: Text(
                  "このユーザをブロックしますか？\nブロックしたユーザの募集は今後表示されなくなります。\nブロックしたユーザは、マイページの「ブロックユーザ一覧」から確認できます。"),
              actions: <Widget>[
                FlatButton(
                  child: Text("キャンセル"),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                    child: Text("ブロック"),
                    onPressed: () async {
                      Navigator.pop(context);
                      final isSuccess = await blockUser(blockedUserId);
                      userBlockListBloc.fetchUserBlockList();
                      if (isSuccess) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                    title: Text("確認"),
                                    content: Text('ブロックしました。'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("OK"),
                                        onPressed: () => Navigator.pop(context),
                                      )
                                    ]));
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                    title: Text("確認"),
                                    content:
                                        Text('ブロックに失敗しました。もう一度操作を行ってください。'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("OK"),
                                        onPressed: () => Navigator.pop(context),
                                      )
                                    ]));
                      }
                    }),
              ]));
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

Future<bool> blockUser(int blockedUserId) async {
  final userBlockApi = UserBlockApi();
  final result =
      await userBlockApi.create(blockedUserId: blockedUserId.toString());
  if (result.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}

class UserBlockLabel extends StatelessWidget {
  UserBlockLabel({this.userBlockListBloc, this.profileUserId});

  final UserBlockListBloc userBlockListBloc;
  final int profileUserId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: userBlockListBloc.userBlockList.value,
        stream: userBlockListBloc.userBlockList,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final List<UserBlock> userBlockList = snapshot.data;
            if (userBlockList
                .where((UserBlock userBlock) =>
                    userBlock.blockedUser == profileUserId)
                .isNotEmpty) {
              return Text('このユーザをブロックしています',
                  style: TextStyle(color: Colors.red));
            }
          }
          return Container();
        });
  }
}
