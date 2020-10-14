import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/auth/auth_bloc.dart';
import 'package:study_matching/mypage/my_page_content.dart';
import 'package:study_matching/offer/mypage_offer_list.dart';
import 'package:study_matching/tag/my_tag_bloc.dart';
import 'package:study_matching/tag/tag.dart';
import 'package:study_matching/user/user.dart';
import 'package:study_matching/user/user_api.dart';

class MyPage extends StatefulWidget {
  static const String name = 'マイページ';
  static const Icon icon = Icon(Icons.person);

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  final userApi = UserApi();
  MyTagBloc myTagBloc;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<AuthBloc>(context);
    //bloc.fetchAndSetUser();
    myTagBloc = Provider.of<MyTagBloc>(context);
    print(myTagBloc.tags.value.map((Tag x) => x.id).toList());
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: Text("マイページ"),
            brightness: Brightness.dark,
            bottom: TabBar(
              isScrollable: false,
              tabs: [
                Tab(
                  text: "プロフィール情報",
                ),
                Tab(text: "募集"),
              ],
            )),
        body: SafeArea(
          top: false,
          child: TabBarView(
            children: <Widget>[
              MyPageContent(bloc: bloc, myTagBloc: myTagBloc),
              AuthUserStreamBuilder(
                widgetUsingAuthUser: (User user) {
                  if (user != null && user.id != null) {
                    return MyPageOfferList(userId: user.id);
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileEditLabel extends StatelessWidget {
  ProfileEditLabel(
      {@required this.labelText, @required this.navigationDestination});

  final String labelText;
  final Widget navigationDestination;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        height: 32,
        color: Colors.grey[300],
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 16), child: Text(labelText)),
              FlatButton(
                color: Colors.lightBlue,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => navigationDestination));
                },
                child: Text(
                  '編集',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ]));
  }
}

typedef WidgetUsingAuthUser = Widget Function(User user);

class AuthUserStreamBuilder extends StatelessWidget {
  final WidgetUsingAuthUser widgetUsingAuthUser;

  AuthUserStreamBuilder({@required this.widgetUsingAuthUser});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<AuthBloc>(context);
    return StreamBuilder(
        stream: bloc.user,
        initialData: bloc.user.value,
        builder: (context, userSnapshot) {
          final User user = userSnapshot.data;
          return widgetUsingAuthUser(user);
        });
  }
}
