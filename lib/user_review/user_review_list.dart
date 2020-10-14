import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import "package:intl/intl.dart";
import 'package:provider/provider.dart';
import 'package:study_matching/user/user.dart';
import 'package:study_matching/user/user_api.dart';
import 'package:study_matching/user_review/user_review.dart';
import 'package:study_matching/user_review/user_review_list_bloc.dart';

class UserReviewList extends StatelessWidget {
  UserReviewList({this.userId});

  final int userId;
  final List<Future<User>> futureUserReviewUserList = [];

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

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("ja_JP");
    final bloc = Provider.of<UserReviewListBloc>(context);
    bloc.fetchMyUserReviewList(userId);
    return StreamBuilder(
        stream: bloc.userReviewList,
        initialData: bloc.userReviewList.value,
        builder: (context, snapshot) {
          final List<UserReview> userReviews = snapshot.data;
          if (userReviews == null) {
            return Container();
          } else {
            for (var userReview in userReviews) {
              futureUserReviewUserList.add(fetchUser(userReview.reviewer));
            }
            return ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: userReviews.length,
              itemBuilder: (context, int index) {
                return ListTile(
                  title: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: FutureBuilder<User>(
                              future: futureUserReviewUserList[index],
                              builder: (context, snapshot) {
                                final User reviewer = snapshot.data;
                                if (reviewer == null) {
                                  return Container();
                                } else {
                                  return Text(
                                    reviewer.username,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  );
                                }
                              })),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(children: <Widget>[
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                Text(userReviews[index].rating.toString())
                              ]),
                              Text(
                                  '${DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP").format(userReviews[index].createdAt)}'),
                            ],
                          )),
                    ],
                  ),
                  subtitle: Text(userReviews[index].text),
                );
              },
            );
          }
        });
  }
}
