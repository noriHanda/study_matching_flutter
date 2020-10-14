import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/auth/auth_bloc.dart';
import 'package:study_matching/chat/chat_list_bloc.dart';
import 'package:study_matching/chat/chat_post_bloc.dart';
import 'package:study_matching/chat/talk_list_bloc.dart';
import 'package:study_matching/notice/notice_bloc.dart';
import 'package:study_matching/offer/mypage_offer_list_bloc.dart';
import 'package:study_matching/offer/offer_bloc.dart';
import 'package:study_matching/offer/offer_logged_out/user_offers_set_bloc_logged_out.dart';
import 'package:study_matching/offer/profile_offer_list_bloc.dart';
import 'package:study_matching/offer/user_offers_set_bloc.dart';
import 'package:study_matching/root_page.dart';
import 'package:study_matching/search/offer_search_result_bloc.dart';
import 'package:study_matching/tag/my_tag_bloc.dart';
import 'package:study_matching/tag/offer_search_selected_tag_bloc.dart';
import 'package:study_matching/tag/selected_tag_bloc.dart';
import 'package:study_matching/tag/tag_bloc.dart';
import 'package:study_matching/tag/user_having_tag_bloc.dart';
import 'package:study_matching/user/user_bloc.dart';
import 'package:study_matching/user_block/user_block_list_bloc.dart';
import 'package:study_matching/user_review/user_review_list_bloc.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          Provider<OfferBloc>(
              builder: (_) => OfferBloc(),
              dispose: (_, bloc) => bloc.dispose()),
          Provider<TagBloc>(
              builder: (_) => TagBloc(), dispose: (_, bloc) => bloc.dispose()),
          Provider<SelectedTagBloc>(
              builder: (_) => SelectedTagBloc(),
              dispose: (_, bloc) => bloc.dispose()),
          Provider<ChatPostBloc>(
              builder: (_) => ChatPostBloc(),
              dispose: (_, bloc) => bloc.dispose()),
          Provider<ChatListBloc>(
              builder: (_) => ChatListBloc(),
              dispose: (_, bloc) => bloc.dispose()),
          Provider<TalkListBloc>(
              builder: (_) => TalkListBloc(),
              dispose: (_, bloc) => bloc.dispose()),
          Provider<AuthBloc>(
              builder: (_) => AuthBloc(), dispose: (_, bloc) => bloc.dispose()),
          Provider<UserBloc>(
              builder: (_) => UserBloc(), dispose: (_, bloc) => bloc.dispose()),
          Provider<UserHavingTagBloc>(
              builder: (_) => UserHavingTagBloc(),
              dispose: (_, bloc) => bloc.dispose()),
          Provider<MyTagBloc>(
              builder: (_) => MyTagBloc(),
              dispose: (_, bloc) => bloc.dispose()),
          Provider<OfferSearchSelectedTagBloc>(
              builder: (_) => OfferSearchSelectedTagBloc(),
              dispose: (_, bloc) => bloc.dispose()),
          Provider<OfferSearchResultBloc>(
              builder: (_) => OfferSearchResultBloc(),
              dispose: (_, bloc) => bloc.dispose()),
          Provider<UserOffersSetBloc>(
              builder: (_) => UserOffersSetBloc(),
              dispose: (_, bloc) => bloc.dispose()),
          Provider<UserReviewListBloc>(
              builder: (_) => UserReviewListBloc(),
              dispose: (_, bloc) => bloc.dispose()),
          Provider<ProfileOfferListBloc>(
              builder: (_) => ProfileOfferListBloc(),
              dispose: (_, bloc) => bloc.dispose()),
          Provider<MyPageOfferListBloc>(
              builder: (_) => MyPageOfferListBloc(),
              dispose: (_, bloc) => bloc.dispose()),
          Provider<UserBlockListBloc>(
              builder: (_) => UserBlockListBloc(),
              dispose: (_, bloc) => bloc.dispose()),
          Provider<UserOffersSetBlocLoggedOut>(
            builder: (_) => UserOffersSetBlocLoggedOut(),
            dispose: (_, bloc) => bloc.dispose(),
          ),
          Provider<NoticeBloc>(
            builder: (_) => NoticeBloc(),
            dispose: (_, bloc) => bloc.dispose(),
          )
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final newTextTheme = Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        );
    return MaterialApp(
      title: 'スタマチ',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ja', 'JP'),
      ],
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.lightBlue,
        accentColor: Colors.lightBlue,
        //textTheme: newTextTheme,
        primaryIconTheme: const IconThemeData.fallback().copyWith(
          color: Colors.white,
        ),
        primaryTextTheme: newTextTheme,
        //primarySwatch: Colors.lightBlue,
      ),
      home: RootPage(),
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
    );
  }
}
