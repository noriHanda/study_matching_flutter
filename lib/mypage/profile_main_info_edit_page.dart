import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/auth/auth_bloc.dart';
import 'package:study_matching/user/user_api.dart';

class ProfileMainInfoEditPage extends StatefulWidget {
  @override
  _ProfileMainInfoEditPage createState() => _ProfileMainInfoEditPage();
}

class _ProfileMainInfoEditPage extends State<ProfileMainInfoEditPage> {
  final userApi = UserApi();

  File _image;
  Future getPhotoLibraryImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  // ProfileBloc bloc;
  AuthBloc bloc;

  String gradeDropdownValue = '学部1年';
  String facultyDropdownValue = '文学部';
  String departmentDropdownValue = '人文科学科';
  List<String> gradeList = [];
  List<String> facultyList = [];
  List<String> departmentList = [];
  Map<String, dynamic> departmentMap;
  /*
  String dropdownValue = '経済学部';
  List<String> dropdownValueList = ['経済学部', '文学部', '工学部', '理学部'];
  String dropdownValue = '経済学部';
  List<String> dropdownValueList = ['経済学部', '文学部', '工学部', '理学部'];
  */

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadJson() async {
    print(facultyList);
    print(departmentList);
    print(gradeList);
    if (gradeList.isEmpty && facultyList.isEmpty && departmentList.isEmpty) {
      final facultiesJson = await DefaultAssetBundle.of(context)
          .loadString('assets/json/faculties.json');
      print(facultiesJson);
      final gradesJson = await DefaultAssetBundle.of(context)
          .loadString('assets/json/grades.json');
      print(gradesJson);
      final tagsJson = await DefaultAssetBundle.of(context)
          .loadString('assets/json/tags.json');
      print(tagsJson);
      print((jsonDecode(facultiesJson)['faculties'] as Map<String, dynamic>)
          .keys
          .toList());
      facultyList =
          (jsonDecode(facultiesJson)['faculties'] as Map<String, dynamic>)
              .keys
              .toList();
      departmentMap =
          Map<String, dynamic>.from(jsonDecode(facultiesJson)['faculties']);
      departmentList = departmentMap[facultyDropdownValue].cast<String>();
      print(departmentMap);
      gradeList = jsonDecode(gradesJson)['grades'].cast<String>();
      setState(() {});
      print(facultyList);
      print(departmentMap);
      print(gradeList);
    }
    /*
    setState(() {
      gradeList = jsonDecode(gradesJson)['grades'].cast<String>();
      //facultyList = jsonDecode(gradesJson)['faculties'];
      print(jsonDecode(gradesJson)['faculties']);
      //departmentList = jsonDecode(gradesJson)['faculties'] as List<String>;
    });
    */
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    bloc = Provider.of<AuthBloc>(context);
    _usernameController = TextEditingController(text: bloc.user.value.username);
    facultyDropdownValue =
        bloc.user.value.faculty != '' ? bloc.user.value.faculty : '文学部';
    departmentDropdownValue =
        bloc.user.value.department != '' ? bloc.user.value.department : '人文科学科';
    gradeDropdownValue =
        bloc.user.value.grade != '' ? bloc.user.value.grade : '学部1年';
  }

  TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<AuthBloc>(context);
    loadJson();

    return Scaffold(
        appBar: AppBar(title: Text('基本情報'), brightness: Brightness.dark),
        body: SafeArea(
            top: false,
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(children: <Widget>[
                  Container(
                      height: 100,
                      child: StreamBuilder(
                        stream: bloc.user,
                        initialData: bloc.user.value,
                        builder: (context, userSnapshot) => userSnapshot.data ==
                                null
                            ? Container()
                            : CachedNetworkImage(
                                imageUrl: userSnapshot.data.iconUrl ??
                                    'http://design-ec.com/d/e_others_50/m_e_others_501.jpg'),
                      )),
                  //'https://d2h9822qykb13q.cloudfront.net/media/public/__sized__/account/B218C267-83C1-47DD-BA92-D9CC00C00383-thumbnail-200x200-70.jpeg')),
                  RaisedButton(
                    child: Text('アイコンの変更'),
                    color: Colors.white,
                    shape: Border(
                      top: BorderSide(color: Colors.lightBlue),
                      left: BorderSide(color: Colors.lightBlue),
                      right: BorderSide(color: Colors.lightBlue),
                      bottom: BorderSide(color: Colors.lightBlue),
                    ),
                    splashColor: Colors.lightBlue,
                    onPressed: getPhotoLibraryImage,
                  ),
                  _image != null
                      ? RaisedButton(
                          child: Text('アップロード'),
                          onPressed: () async {
                            final result = await userApi.updateUserIcon(
                                bloc.user.value.id, _image);
                            if (result.statusCode == 200) {
                              bloc.fetchAndSetUser();
                            }
                          },
                        )
                      : Container(),
                ]),
                SectionLabel(labelText: 'ユーザーネーム'),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                        child: TextFormField(
                      decoration: InputDecoration(
                        labelText: '英数のみ使用可',
                      ),
                      controller: _usernameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'ユーザーネームを入力してください';
                        } else {
                          return null;
                        }
                      },
                    ))),
                SectionLabel(labelText: '学部'),
                Padding(
                    padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: DropdownButton<String>(
                      value: facultyDropdownValue,
                      onChanged: (String newValue) {
                        /*
                        setState(() {
                          facultyDropdownValue = newValue;
                        });
                        */
                        setState(() {
                          facultyDropdownValue = newValue;
                          departmentDropdownValue =
                              departmentMap[facultyDropdownValue]
                                  .cast<String>()[0];
                          departmentList = departmentMap[facultyDropdownValue]
                              .cast<String>();
                        });
                      },
                      items: facultyList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )),
                SectionLabel(labelText: '学科'),
                Padding(
                    padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: DropdownButton<String>(
                      value: departmentDropdownValue,
                      onChanged: (String newValue) {
                        setState(() {
                          departmentDropdownValue = newValue;
                        });
                      },
                      items: departmentList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )),
                SectionLabel(labelText: '学年'),
                Padding(
                    padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: DropdownButton<String>(
                      value: gradeDropdownValue,
                      onChanged: (String newValue) {
                        setState(() {
                          gradeDropdownValue = newValue;
                        });
                      },
                      items: gradeList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                      child: RaisedButton(
                    onPressed: () async {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      final isSuccess = await submit();
                      if (isSuccess) {
                        await bloc.fetchAndSetUser();
                        Navigator.of(context).pop();
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
            ))));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> submit() async {
    print(_usernameController.text);
    print(facultyDropdownValue);
    print(departmentDropdownValue);
    print(gradeDropdownValue);
    final userResult = await userApi.updateUser(bloc.user.value.id, {
      'username': _usernameController.text,
      'faculty': facultyDropdownValue,
      'department': departmentDropdownValue,
      'grade': gradeDropdownValue
    });
    if (userResult.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

class SectionLabel extends StatelessWidget {
  SectionLabel({@required this.labelText});

  final String labelText;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 32,
      width: double.infinity,
      color: Colors.grey[300],
      child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.only(left: 16), child: Text(labelText))),
    );
  }
}
