import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/profile_page.dart';
import 'package:study_matching/user/user.dart';
import 'package:study_matching/user/user_api.dart';
import 'package:study_matching/user_block/user_block.dart';
import 'package:study_matching/user_block/user_block_api.dart';
import 'package:study_matching/user_block/user_block_list_bloc.dart';

class UserBlockListPage extends StatelessWidget {
  final List<Future<User>> futureBlockedUserList = [];

  Future<User> fetchUser(int userId) async {
    final result = await UserApi().fetchUser(userId);
    if (result.statusCode == 200) {
      final user = result.user;
      return user;
    } else if (result.statusCode == 401) {
      print("error");
      return null;
    } else {
      print("error");
      return null;
    }
  }

  Future<void> _onRefreshUserBlockList(BuildContext context) async {
    await Provider.of<UserBlockListBloc>(context).fetchUserBlockList();
  }

  @override
  Widget build(BuildContext context) {
    final userBlockListBloc = Provider.of<UserBlockListBloc>(context);
    return Scaffold(
        appBar: AppBar(title: Text('ブロックしたユーザー'), brightness: Brightness.dark),
        body: SafeArea(
            top: false,
            child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: StreamBuilder(
                    initialData: userBlockListBloc.userBlockList.value,
                    stream: userBlockListBloc.userBlockList,
                    builder: (context, snapshot) {
                      final List<UserBlock> userBlockList = snapshot.data;
                      if (userBlockListBloc == null) {
                        return Container();
                      } else {
                        return RefreshIndicator(
                            onRefresh: () => _onRefreshUserBlockList(context),
                            child: ListView.separated(
                                separatorBuilder: (context, index) => Divider(),
                                itemCount: userBlockList.length,
                                itemBuilder: (context, int index) {
                                  futureBlockedUserList.add(fetchUser(
                                      userBlockList[index].blockedUser));
                                  return FutureBuilder<User>(
                                      future: futureBlockedUserList[index],
                                      builder: (context, snapshot) {
                                        final blockedUser = snapshot.data;
                                        if (blockedUser == null) {
                                          return Container();
                                        } else {
                                          return BlockedUserListTile(
                                              blockedUser: blockedUser,
                                              unblockAction: () {
                                                showUnBlockConfirmationDialog(
                                                    context, blockedUser.id);
                                              });
                                        }
                                      });
                                }));
                      }
                    }))));
  }

  void showUnBlockConfirmationDialog(BuildContext context, int blockedcUserId) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
                title: Text("確認"),
                content: Text("このユーザのブロックを解除しますか？"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("キャンセル"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                      child: Text("ブロック解除"),
                      onPressed: () async {
                        Navigator.pop(context);
                        final isSuccess = await unblockUser(blockedcUserId);
                        Provider.of<UserBlockListBloc>(context)
                            .fetchUserBlockList();
                        if (isSuccess) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                      title: Text("確認"),
                                      content: Text('ブロック解除しました。'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("OK"),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        )
                                      ]));
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                      title: Text("確認"),
                                      content:
                                          Text('ブロック解除に失敗しました。もう一度操作を行ってください。'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("OK"),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        )
                                      ]));
                        }
                      }),
                ]));
  }

  Future<bool> unblockUser(int blockedUserId) async {
    final userBlockApi = UserBlockApi();
    final result =
        await userBlockApi.unblock(blockedUserId: blockedUserId.toString());
    return result;
  }
}

class BlockedUserListTile extends StatelessWidget {
  BlockedUserListTile({this.blockedUser, this.unblockAction});
  final User blockedUser;
  final VoidCallback unblockAction;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfilePage(userId: blockedUser.id)));
      },
      leading: Column(children: <Widget>[
        Expanded(
            child: CachedNetworkImage(
                imageUrl: blockedUser.iconUrl ??
                    'http://design-ec.com/d/e_others_50/m_e_others_501.jpg')),
      ]),
      title: Text(blockedUser.username),
      trailing: FlatButton(
        onPressed: () {
          unblockAction();
        },
        child: Text('解除'),
        textColor: Colors.white,
        color: Colors.red,
      ),
    );
  }
}
