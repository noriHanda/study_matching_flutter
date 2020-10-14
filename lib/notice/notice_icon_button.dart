import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/common/ui/badge.dart';
import 'package:study_matching/notice/notice_bloc.dart';
import 'package:study_matching/notice/notice_page.dart';

class NoticeIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<NoticeBloc>(context);
    bloc.fetchMyUnreadNoticeCount();
    return StreamBuilder<int>(
      initialData: bloc.unreadNoticeCount.value,
      stream: bloc.unreadNoticeCount,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == 0) {
          return IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => NoticePage()));
            },
          );
        } else {
          return IconButton(
            icon: Badge(
              icon: Icon(Icons.notifications),
              number: snapshot.data,
              badgeRightMargin: 0,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => NoticePage()));
            },
          );
        }
      },
    );
  }
}
