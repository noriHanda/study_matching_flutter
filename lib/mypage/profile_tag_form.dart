import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/auth/auth_bloc.dart';
import 'package:study_matching/tag/my_selectable_tag_list.dart';
import 'package:study_matching/tag/selected_tag_bloc.dart';
import 'package:study_matching/user/user_api.dart';

class ProfileTagEditPage extends StatefulWidget {
  ProfileTagEditPage({@required this.initialUserHavingTagIds});
  final List<int> initialUserHavingTagIds;

  @override
  _ProfileTagEditPageState createState() => _ProfileTagEditPageState(
      initialUserHavingTagIds: initialUserHavingTagIds);
}

class _ProfileTagEditPageState extends State<ProfileTagEditPage> {
  _ProfileTagEditPageState({@required this.initialUserHavingTagIds});
  final List<int> initialUserHavingTagIds;

  final _formKey = GlobalKey<FormState>();

  final userApi = UserApi();

  AuthBloc authBloc;
  SelectedTagBloc selectedTagIdBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedTagIdBloc = Provider.of<SelectedTagBloc>(context);
    print(initialUserHavingTagIds);
    selectedTagIdBloc.setSelectedTagIdList.add(initialUserHavingTagIds);
  }

  @override
  Widget build(BuildContext context) {
    authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
        appBar: AppBar(title: Text('相談に乗れること'), brightness: Brightness.dark),
        body: SafeArea(
            top: false,
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('相談に乗れること')),
                      MySelectableTagList(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                            child: RaisedButton(
                          onPressed: () async {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.
                            if (_formKey.currentState.validate()) {
                              final isSuccess = await submit();
                              if (isSuccess) {
                                await authBloc.fetchAndSetUser();
                                Navigator.of(context).pop();
                              }
                            }
                          },
                          child: Text('更新'),
                          color: Colors.white,
                          shape: Border(
                            top: BorderSide(color: Colors.lightBlue),
                            left: BorderSide(color: Colors.lightBlue),
                            right: BorderSide(color: Colors.lightBlue),
                            bottom: BorderSide(color: Colors.lightBlue),
                          ),
                          splashColor: Colors.lightBlue,
                        )),
                      ),
                    ],
                  ),
                ))));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> submit() async {
    final userResult = await userApi.updateUser(
        authBloc.user.value.id, {'user_tags': selectedTagIdBloc.ids.value});
    if (userResult.statusCode == 200) {
      selectedTagIdBloc.setSelectedTagIdList.add(userResult.user.tags);
      return true;
    } else {
      return false;
    }
  }
}
