import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:study_matching/auth/auth_bloc.dart';
import 'package:study_matching/auth/change_password_page.dart';
import 'package:study_matching/common/ui/standard_selectable_autolink_text.dart';
import 'package:study_matching/mypage/my_page.dart';
import 'package:study_matching/mypage/profile_description_edit_page.dart';
import 'package:study_matching/mypage/profile_main_info_edit_page.dart';
import 'package:study_matching/mypage/profile_tag_form.dart';
import 'package:study_matching/tag/my_tag_bloc.dart';
import 'package:study_matching/tag/my_tag_list.dart';
import 'package:study_matching/tag/tag.dart';
import 'package:study_matching/user/user.dart';
import 'package:study_matching/user_block/user_block_list_page.dart';

class MyPageContent extends StatelessWidget {
  const MyPageContent({
    Key key,
    @required this.bloc,
    @required this.myTagBloc,
  }) : super(key: key);

  final AuthBloc bloc;
  final MyTagBloc myTagBloc;

  Future<void> onRefresh() async {
    await bloc.fetchAndSetUser();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
          child: Center(
              child: Column(children: <Widget>[
        ProfileEditLabel(
          labelText: '基本情報',
          navigationDestination: ProfileMainInfoEditPage(),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.topLeft,
            child: StreamBuilder(
              stream: bloc.user,
              initialData: bloc.user.value,
              builder: (context, userSnapshot) {
                final User user = userSnapshot.data;
                if (user != null && user.username != null) {
                  return Row(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Container(
                              height: 100,
                              child: StreamBuilder(
                                stream: bloc.user,
                                initialData: bloc.user.value,
                                builder: (context, userSnapshot) => userSnapshot
                                            .data ==
                                        null
                                    ? Container()
                                    : CachedNetworkImage(
                                        imageUrl: userSnapshot.data.iconUrl ??
                                            'http://design-ec.com/d/e_others_50/m_e_others_501.jpg'),
                              ))),
                      Expanded(
                          flex: 3,
                          child: Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    user.username,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  Text(
                                      '${user.faculty ?? '学部未設定'} ${user.department ?? '学科未設定'}'),
                                  Text(user.grade ?? '学年未設定'),
                                ],
                              )))
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: ProfileEditLabel(
            labelText: 'プロフィール',
            navigationDestination: ProfileDescriptionEditPage(),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.topLeft,
            child: AuthUserStreamBuilder(
              widgetUsingAuthUser: (User user) {
                if (user != null && user.description != null) {
                  return StandardSelectableAutoLinkText(user.description);
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
        ProfileEditLabel(
          labelText: '相談にのれること',
          // 以下のWidgetが、1, 2が入る前に生成されてしまうため、コンストラクタに[]が必ず渡されてしまう場合がある？
          navigationDestination: ProfileTagEditPage(
            initialUserHavingTagIds: myTagBloc.tags.value != null
                ? myTagBloc.tags.value.map((Tag x) => x.id).toList()
                : [],
          ),
        ),
        AuthUserStreamBuilder(widgetUsingAuthUser: (User user) {
          if (user != null && user.id != null) {
            return Padding(
                padding: EdgeInsets.all(16), child: MyTagList(userId: user.id));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
        Padding(
          padding: EdgeInsets.only(top: 48),
          child: RaisedButton(
            onPressed: bloc.logout,
            child: const Text('　 　 ログアウト 　 　'),
            color: Colors.white,
            shape: Border(
              top: BorderSide(color: Colors.lightBlue),
              left: BorderSide(color: Colors.lightBlue),
              right: BorderSide(color: Colors.lightBlue),
              bottom: BorderSide(color: Colors.lightBlue),
            ),
            splashColor: Colors.lightBlue,
          ),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChangePasswordPage(),
                settings: RouteSettings(name: 'ChangePasswordPage'),
              ),
            );
          },
          child: const Text(' 　 パスワード変更 　 '),
          color: Colors.white,
          shape: Border(
            top: BorderSide(color: Colors.lightBlue),
            left: BorderSide(color: Colors.lightBlue),
            right: BorderSide(color: Colors.lightBlue),
            bottom: BorderSide(color: Colors.lightBlue),
          ),
          splashColor: Colors.lightBlue,
        ),
        RaisedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserBlockListPage(),
                settings: RouteSettings(name: 'UserBlockListPage'),
              ),
            );
          },
          child: const Text('ブロックしたユーザー'),
          color: Colors.white,
          shape: Border(
            top: BorderSide(color: Colors.lightBlue),
            left: BorderSide(color: Colors.lightBlue),
            right: BorderSide(color: Colors.lightBlue),
            bottom: BorderSide(color: Colors.lightBlue),
          ),
          splashColor: Colors.lightBlue,
        ),
      ]))),
    );
  }
}
