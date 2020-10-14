import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/chat/chat_api.dart';
import 'package:study_matching/chat/chat_list_bloc.dart';
import 'package:study_matching/chat/chat_list_page.dart';
import 'package:study_matching/common/ui/badge.dart';
import 'package:study_matching/firebase_messaging/utils.dart';
import 'package:study_matching/mypage/my_page.dart';
import 'package:study_matching/offer/offer_create_page.dart';
import 'package:study_matching/offer/user_offers_set_list_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _bottomNavigationBarIndex = 0;
  static const _appBarTitleList = [
    UserOffersSetListPage.name,
    OfferCreatePage.name,
    ChatListPage.name,
    MyPage.name,
  ];
  String _appBarTitle = _appBarTitleList[0];
  bool onBardingFlag = false;

  final List<Widget> _widgetOptions = <Widget>[
    UserOffersSetListPage(),
    OfferCreatePage(),
    ChatListPage(),
    MyPage(),
  ];

  AppBar buildAppBar() {
    if (_bottomNavigationBarIndex == 0 ||
        _bottomNavigationBarIndex == _widgetOptions.length - 1) {
      return null;
    } else {
      return AppBar(
        brightness: Brightness.dark,
        title: Text(_appBarTitle),
      );
    }
  }

  void changeBottomNavigationIndex(int index) {
    _bottomNavigationBarIndex = index;
    _appBarTitle = _appBarTitleList[_bottomNavigationBarIndex];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUpFCM();
  }

  //AuthBloc authBloc;
  ChatListBloc chatListBloc;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    chatListBloc = Provider.of<ChatListBloc>(context);
    //authBloc = Provider.of<AuthBloc>(context);
    //authBloc.fetchAndSetUser();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = Provider.of<ScrollController>(context);

    return Scaffold(
        appBar: buildAppBar(),
        body: SafeArea(
            top: false,
            child: Stack(children: <Widget>[
              _buildVisiblePage(0, _widgetOptions[0]),
              _buildVisiblePage(1, _widgetOptions[1]),
              _buildVisiblePage(2, _widgetOptions[2]),
              _buildVisiblePage(3, _widgetOptions[3]),
              //_buildVisiblePage(4, _widgetOptions[4]),
            ])),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            if (index == _bottomNavigationBarIndex) {
              scrollController.animateTo(
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            }
            setState(() {
              changeBottomNavigationIndex(index);
            });
          },
          currentIndex: _bottomNavigationBarIndex,
          items: [
            BottomNavigationBarItem(
              icon: UserOffersSetListPage.icon,
              title: Text(UserOffersSetListPage.name),
            ),
            BottomNavigationBarItem(
                icon: OfferCreatePage.icon, title: Text(OfferCreatePage.name)),
            BottomNavigationBarItem(
              icon: ChatListPageTabIcon(),
              title: Text(ChatListPage.name),
            ),
            BottomNavigationBarItem(
              icon: MyPage.icon,
              title: Text(MyPage.name),
            ),
          ],
        ));
  }

// BottomNavigationBarのindexと対応する場合だけ見える状態のWidgetを返す
  Widget _buildVisiblePage(int index, Widget page) {
    // 似たようなWidget Visibilityを使うと子Widgetがリビルドされるが、Offstageだとリビルドされない
    // TickerModeを使うとOffstageで見えていない部分のアニメーションを動かないようにできる
    return Offstage(
      offstage: index != _bottomNavigationBarIndex,
      child: TickerMode(
        enabled: index == _bottomNavigationBarIndex,
        child: page,
      ),
    );
  }
}

class ChatListPageTabIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatApi = ChatApi();
    return FutureBuilder<int>(
      future: chatApi.fetchChatUnreadTotalCount(),
      initialData: 0,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError || snapshot.data == 0) {
          return ChatListPage.icon;
        }
        return Badge(
          icon: ChatListPage.icon,
          number: snapshot.data,
          badgeRightMargin: 16,
        );
      },
    );
  }
}
