import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/auth/auth_bloc.dart';
import 'package:study_matching/my_home_page.dart';
import 'package:study_matching/my_home_page_logged_out.dart';
import 'package:study_matching/update_prompt_alert.dart';
import 'package:study_matching/user_block/user_block_list_bloc.dart';

class RootPage extends StatelessWidget {
  void showUpdateAlertIfNeeded(BuildContext context) async {
    if (await UpdatePromptAlert.shouldUpdate()) showUpdatePromptAlert(context);
  }

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) showUpdateAlertIfNeeded(context);
    final authBloc = Provider.of<AuthBloc>(context);
    return StreamBuilder(
        initialData: authBloc.isLoadingLoginStatus.value,
        stream: authBloc.isLoadingLoginStatus,
        builder: (context, snapshot) {
          if (snapshot == null)
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          final isLoadingLoginStatus = snapshot.data as bool;
          if (isLoadingLoginStatus)
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          return StreamBuilder(
              stream: authBloc.userJwt,
              builder: (context, snapshot) {
                if (snapshot.data == null)
                  return MyHomePageLoggedOut();
                else {
                  final userBlockListBloc =
                      Provider.of<UserBlockListBloc>(context);
                  userBlockListBloc.fetchUserBlockList();
                  return ListenableProvider(
                      builder: (context) => ScrollController(),
                      child: MyHomePage());
                }
              });
        });
  }
}
