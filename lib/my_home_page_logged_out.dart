import 'package:flutter/material.dart'
    show
        AppBar,
        BottomNavigationBar,
        BottomNavigationBarItem,
        BottomNavigationBarType,
        Brightness,
        BuildContext,
        Key,
        SafeArea,
        Scaffold,
        State,
        StatefulWidget,
        Text,
        Widget;
import 'package:study_matching/chat/chat_list_page.dart' show ChatListPage;
import 'package:study_matching/mypage/my_page.dart' show MyPage;
import 'package:study_matching/no_login_alert.dart' show noLoginAlert;
import 'package:study_matching/offer/offer_create_page.dart'
    show OfferCreatePage;
import 'package:study_matching/offer/offer_logged_out/user_offers_set_list_page_logged_out.dart'
    show UserOffersSetListPageLoggedOut;
import 'package:study_matching/offer/user_offers_set_list_page.dart'
    show UserOffersSetListPage;

class MyHomePageLoggedOut extends StatefulWidget {
  MyHomePageLoggedOut({Key key}) : super(key: key);

  @override
  _MyHomePageLoggedOutState createState() => _MyHomePageLoggedOutState();
}

class _MyHomePageLoggedOutState extends State<MyHomePageLoggedOut> {
  int _bottomNavigationBarIndex = 0;
  String _appBarTitle = _appBarTitleList[0];
  static const _appBarTitleList = [
    UserOffersSetListPage.name,
    OfferCreatePage.name,
    ChatListPage.name,
    MyPage.name,
  ];
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: SafeArea(top: false, child: UserOffersSetListPageLoggedOut()),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (int index) => noLoginAlert(context),
          currentIndex: _bottomNavigationBarIndex,
          items: [
            BottomNavigationBarItem(
              icon: UserOffersSetListPage.icon,
              title: Text(UserOffersSetListPage.name),
            ),
            BottomNavigationBarItem(
                icon: OfferCreatePage.icon, title: Text(OfferCreatePage.name)),
            BottomNavigationBarItem(
              icon: ChatListPage.icon,
              title: Text(ChatListPage.name),
            ),
            BottomNavigationBarItem(
              icon: MyPage.icon,
              title: Text(MyPage.name),
            ),
          ],
        ));
  }
}
