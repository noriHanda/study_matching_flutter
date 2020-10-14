import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/auth/auth_bloc.dart';
import 'package:study_matching/chat/chat_api.dart';
import 'package:study_matching/chat/chat_page.dart';
import 'package:study_matching/common/ui/standard_selectable_autolink_text.dart';
import 'package:study_matching/offer/offer.dart';
import 'package:study_matching/offer/offer_bloc.dart';
import 'package:study_matching/offer/offer_update_page.dart';
import 'package:study_matching/profile_page.dart';
import 'package:study_matching/user/user_api.dart';

class OfferDetailsPage extends StatefulWidget {
  OfferDetailsPage({@required this.id});

  final int id;
  @override
  _OfferDetailsPageState createState() => _OfferDetailsPageState(id: id);
}

class _OfferDetailsPageState extends State<OfferDetailsPage> {
  _OfferDetailsPageState({@required this.id});

  final int id;
  final _userApi = UserApi();

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = Provider.of<AuthBloc>(context);
    final bloc = Provider.of<OfferBloc>(context);
    bloc.fetchOffers();
    return Scaffold(
      appBar: AppBar(
          brightness: Brightness.dark,
          title: Text('募集'),
          actions: <Widget>[
            StreamBuilder(
                initialData: bloc.offers.value,
                stream: bloc.offers,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {}
                  if (snapshot.hasData) {
                    if (snapshot.data != []) {
                      final List<Offer> offers = snapshot.data;
                      // 以下は基本的には一つしかないが、言語機能的にこうするしかない
                      final List<Offer> offersFoundbyId =
                          offers.where((x) => x.id == id).toList();
                      if (offersFoundbyId != [] &&
                          offersFoundbyId.length == 1) {
                        final offer = offersFoundbyId[0];
                        if (authBloc.user.value != null &&
                            authBloc.user.value.id == offer.userId) {
                          return IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => OfferUpdatePage(),
                                      settings: RouteSettings(
                                        name: 'OfferUpdatePage',
                                        arguments: offer.id.toInt(),
                                      )),
                                );
                              });
                        }
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
                    if (offersFoundbyId != [] && offersFoundbyId.length == 1) {
                      final offer = offersFoundbyId[0];
                      print(offer);
                      final futureUser = _userApi.fetchUser(offer.userId);
                      print(offer.userId);
                      return FutureBuilder(
                          future: futureUser,
                          builder: (context, userSnapshot) {
                            if (!userSnapshot.hasData) {
                              return Center(
                                child: Container(
                                  height: 480,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator()),
                                ),
                              );
                            } else {
                              final UserResult userResult = userSnapshot.data;
                              print(userResult.statusCode);
                              if (userResult.statusCode != 200) {
                                return Center(
                                  child: Container(
                                    height: 480,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator()),
                                  ),
                                );
                              } else {
                                final user = userResult.user;
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                        )),
                                    Spacer(flex: 1),
                                  ]),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => ProfilePage(
                                                  userId: user.id)));
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.only(top: 16.0),
                                        child: Center(
                                            child: Container(
                                                height: 50,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    CachedNetworkImage(
                                                        imageUrl: user
                                                                .iconUrl ??
                                                            'http://design-ec.com/d/e_others_50/m_e_others_501.jpg'),
                                                    Text(user.username),
                                                  ],
                                                )))),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 16.0, bottom: 4.0),
                                    child: ProfileLabel(
                                      labelText: '詳細',
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: StandardSelectableAutoLinkText(
                                          offer.description)),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 16.0, bottom: 4.0),
                                    child: ProfileLabel(labelText: 'マッチ方法'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(offer.matchingWay),
                                  ),
                                  authBloc.user.value != null &&
                                          authBloc.user.value.id != offer.userId
                                      ? Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: MoveToChatPageButton(
                                            loginUserId: authBloc.user.value.id,
                                            partnerUserId: offer.userId,
                                          ))
                                      : Container(),
                                  authBloc.user.value != null &&
                                          authBloc.user.value.id != offer.userId
                                      ? Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: RaisedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfilePage(
                                                              userId:
                                                                  user.id)));
                                            },
                                            child: Text('このユーザのプロフィールを見てみる'),
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
                                          ),
                                        )
                                      : Container(),
                                ]);
                              }
                            }
                          });
                      // offer.userId = 1;
                    } else {
                      return Text('この募集は削除されました。もしくは一時的な問題が発生しています。');
                    }
                  } else {
                    return Text("has no array data");
                  }
                } else {
                  return Text("has no data");
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MoveToChatPageButton extends StatelessWidget {
  MoveToChatPageButton({this.loginUserId, this.partnerUserId});

  final int partnerUserId;
  final int loginUserId;
  final _chatApi = ChatApi();
  final _userApi = UserApi();

  @override
  Widget build(BuildContext context) {
    bool isAlreadyLoading = false;
    final authBloc = Provider.of<AuthBloc>(context);
    return RaisedButton(
      onPressed: () async {
        if (isAlreadyLoading == false) {
          isAlreadyLoading = true;
          final partnerUserResult = await _userApi.fetchUser(partnerUserId);
          if (partnerUserResult.user != null) {
            final chat = await _chatApi.fetchOrCreateChatRoom(
                loginUserId, partnerUserId, authBloc.userJwt.value);
            if (chat != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ChatPage(chat: chat, chatPartner: partnerUserResult.user),
                  settings: RouteSettings(name: 'ChatPage'),
                ),
              );
            }
          }
        }
        isAlreadyLoading = false;
      },
      child: Text('チャットを送る'),
      color: Colors.white,
      shape: Border(
        top: BorderSide(color: Colors.lightBlue),
        left: BorderSide(color: Colors.lightBlue),
        right: BorderSide(color: Colors.lightBlue),
        bottom: BorderSide(color: Colors.lightBlue),
      ),
      splashColor: Colors.lightBlue,
    );
  }
}
