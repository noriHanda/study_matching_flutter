import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import "package:intl/intl.dart";
import 'package:provider/provider.dart';
import 'package:study_matching/notice/notice.dart';
import 'package:study_matching/notice/notice_bloc.dart';

class NoticePage extends StatelessWidget {
  static const String name = 'お知らせ';
  static const Icon icon = Icon(Icons.notifications);

  Future<void> fetchMyNoticeList(BuildContext context) async {
    await Provider.of<NoticeBloc>(context).fetchMyNoticeList();
    return;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<NoticeBloc>(context);
    bloc.fetchMyNoticeList();
    bloc.resetMyUnreadNoticeCount();

    initializeDateFormatting("ja_JP");
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('お知らせ'),
      ),
      body: StreamBuilder(
          initialData: bloc.notices.value,
          stream: bloc.notices,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              if (snapshot.hasError) {
                return Text('エラーが発生しました');
              } else {
                return Center(child: CircularProgressIndicator());
              }
            } else {
              final notices = snapshot.data as List<Notice>;
              if (notices.length == 0) {
                return Text('お知らせはまだ届いていません。');
              } else {
                return RefreshIndicator(
                  onRefresh: () => fetchMyNoticeList(context),
                  child: ListView.builder(
                    itemCount: notices.length,
                    itemBuilder: (context, int index) {
                      return ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: notices[index].imageUrl ??
                              'http://design-ec.com/d/e_others_50/m_e_others_501.jpg',
                        ),
                        title: Text(
                          notices[index].body,
                        ),
                        subtitle: Text(
                            '${DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP").format(notices[index].createdDate)}'),
                      );
                    },
                  ),
                );
              }
            }
          }),
    );
  }
}
