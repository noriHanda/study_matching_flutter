import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import "package:intl/intl.dart";
import 'package:provider/provider.dart';
import 'package:study_matching/auth/auth_bloc.dart';
import 'package:study_matching/chat/chat.dart';
import 'package:study_matching/chat/chat_api.dart';
import 'package:study_matching/chat/chat_form.dart';
import 'package:study_matching/chat/chat_post_bloc.dart';
import 'package:study_matching/chat/talk.dart';
import 'package:study_matching/chat/talk_list_bloc.dart';
import 'package:study_matching/common/ui/standard_selectable_autolink_text.dart';
import 'package:study_matching/profile_page.dart';
import 'package:study_matching/user/user.dart';

class ChatPage extends StatelessWidget {
  ChatPage({@required this.chat, @required this.chatPartner});
  final Chat chat;
  final User chatPartner;

  final _chatApi = ChatApi();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ChatPostBloc>(context);
    bloc.setChatData.add(chat);
    final authBloc = Provider.of<AuthBloc>(context);
    final talkListBloc = Provider.of<TalkListBloc>(context);
    talkListBloc.fetchAllTalks(chat.id);
    _chatApi.resetChatUnreadCount(chat.id);
    // final talks = [Talk(), Talk(), Talk()];
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text(chatPartner.username),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                talkListBloc.fetchAllTalks(chat.id);
              },
            )
          ],
        ),
        body: SafeArea(
            top: false,
            child: SingleChildScrollView(
                reverse: true,
                child: Column(children: <Widget>[
                  StreamBuilder(
                      initialData: talkListBloc.talks.value,
                      stream: talkListBloc.talks,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        } else {
                          final List<Talk> talks = snapshot.data;
                          return StreamBuilder(
                              initialData: authBloc.user.value,
                              stream: authBloc.user,
                              builder: (context, userSnapshot) {
                                if (userSnapshot.data == null) {
                                  return Container();
                                } else {
                                  return ListView.builder(
                                      itemCount: talks.length,
                                      shrinkWrap: true,
                                      primary: false,
                                      itemBuilder: (context, int index) {
                                        if (talks[index].userId ==
                                            chatPartner.id) {
                                          return PartnerTalk(
                                              talk: talks[index],
                                              chatPartner: chatPartner);
                                        } else {
                                          final user = userSnapshot.data;
                                          return MyTalk(
                                              talk: talks[index], user: user);
                                        }
                                      });
                                }
                              });
                        }
                      }),
                  ChatForm(),
                ]))));
  }
}

class MyTalk extends StatelessWidget {
  MyTalk({@required this.talk, @required this.user});

  final Talk talk;
  final User user;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("ja_JP");
    return Padding(
        padding: EdgeInsets.only(left: 32.0, top: 8.0, bottom: 8.0),
        child: ListTile(
          trailing: Column(children: <Widget>[
            Text(user.username),
            Expanded(
                child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfilePage(
                          userId: user.id,
                        )));
              },
              child: CachedNetworkImage(
                  imageUrl: user.iconUrl ??
                      'http://design-ec.com/d/e_others_50/m_e_others_501.jpg'),
            )),
          ]),
          title: Container(
              margin: const EdgeInsets.all(3.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: .5,
                        spreadRadius: 1.0,
                        color: Colors.black.withOpacity(.12))
                  ],
                  color: Colors.green[400],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(10.0),
                  )),
              child: StandardSelectableAutoLinkText(talk.sentence)),
          subtitle: Text(
              '${DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP").format(talk.createdDate)}'),
        ));
  }
}

class PartnerTalk extends StatelessWidget {
  PartnerTalk({@required this.talk, @required this.chatPartner});

  final Talk talk;
  final User chatPartner;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: 32.0, top: 8.0, bottom: 8.0),
        child: ListTile(
          leading: Column(children: <Widget>[
            Text(chatPartner.username),
            Expanded(
                child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfilePage(
                          userId: chatPartner.id,
                        )));
              },
              child: CachedNetworkImage(
                  imageUrl: chatPartner.iconUrl ??
                      'http://design-ec.com/d/e_others_50/m_e_others_501.jpg'),
            )),
          ]),
          title: Container(
              margin: const EdgeInsets.all(3.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: .5,
                      spreadRadius: 1.0,
                      color: Colors.black.withOpacity(.12))
                ],
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(5.0),
                ),
              ),
              child: StandardSelectableAutoLinkText(talk.sentence)),
          subtitle: Text(
              '${DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP").format(talk.createdDate)}'),
        ));
  }
}
