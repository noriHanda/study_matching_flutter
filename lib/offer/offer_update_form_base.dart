import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:study_matching/common/ui/load_indicator.dart';
import 'package:study_matching/offer/matching_way_radio_button.dart';
import 'package:study_matching/offer/offer.dart';
import 'package:study_matching/offer/offer_create_confirmation_page.dart';

abstract class AbstractOfferUpdateformState<T extends StatefulWidget>
    extends State<T> {
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  final _titleFocus = FocusNode();
  final _detailsFocus = FocusNode();

  bool isSubmitting = false;
  File image;
  String imageErrorText = '';
  String iconUrl;

  TextEditingController titleInputController;
  TextEditingController detailsInputController;

  KeyboardActionsConfig _keyboardActionsConfig(BuildContext context) =>
      KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey[200],
        nextFocus: true,
        actions: [
          KeyboardAction(focusNode: _titleFocus),
          KeyboardAction(focusNode: _detailsFocus),
        ],
      );

  Future getPhotoLibraryImage() async {
    var galleryImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = galleryImage;
    });
  }

  void validateEmptyImage() {
    if (image == null && iconUrl == null) {
      setState(() {
        imageErrorText = '画像を選択してください';
      });
    } else {
      setState(() {
        imageErrorText = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 900,
      child: KeyboardActions(
        config: _keyboardActionsConfig(context),
        child: Stack(children: <Widget>[
          GestureDetector(
              // enable gesture detection on invisible child(e.g. SizedBox)
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(top: 16, left: 16),
                        child: Text(
                          '画像',
                          style: Theme.of(context).textTheme.subtitle1,
                        )),

                    image != null
                        ? Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              top: 16,
                            ),
                            child: Container(
                                height: 100, child: Image.file(image)))
                        : Padding(
                            padding: const EdgeInsets.only(top: 16, left: 16),
                            child: Container(
                              height: 100,
                              child: CachedNetworkImage(
                                  imageUrl: iconUrl ??
                                      'http://design-ec.com/d/e_others_50/m_e_others_501.jpg'),
                            )),
//'https://d2h9822qykb13q.cloudfront.net/media/public/__sized__/account/B218C267-83C1-47DD-BA92-D9CC00C00383-thumbnail-200x200-70.jpeg')),
                    Padding(
                        padding: const EdgeInsets.only(top: 16, left: 16),
                        child: RaisedButton(
                          child: Text('募集画像を選択'),
                          color: Colors.white,
                          shape: Border(
                            top: BorderSide(color: Colors.lightBlue),
                            left: BorderSide(color: Colors.lightBlue),
                            right: BorderSide(color: Colors.lightBlue),
                            bottom: BorderSide(color: Colors.lightBlue),
                          ),
                          splashColor: Colors.lightBlue,
                          onPressed: getPhotoLibraryImage,
                        )),
                    imageErrorText != ''
                        ? Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(imageErrorText,
                                style: TextStyle(color: Colors.red)))
                        : Container(),
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                            child: TextFormField(
                          decoration: InputDecoration(
                            labelText: '募集タイトル',
                          ),
                          autofocus: false,
                          focusNode: _titleFocus,
                          textInputAction: TextInputAction.done,
                          controller: titleInputController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Paalease enter some text';
                            } else {
                              return null;
                            }
                          },
                        ))),
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                            child: TextFormField(
                          decoration: InputDecoration(
                            labelText: '詳細',
                          ),
                          controller: detailsInputController,
                          focusNode: _detailsFocus,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            } else {
                              return null;
                            }
                          },
                          maxLines: 10,
                        ))),
//                Padding(
//                    padding: const EdgeInsets.all(16.0),
//                    child: Center(
//                        child: TextFormField(
//                      keyboardType: TextInputType.number,
//                      decoration: InputDecoration(
//                        labelText: '値段',
//                        hintText: '(例) 100',
//                      ),
//                      validator: (value) {
//                        if (value.isEmpty) {
//                          return 'Please enter some text';
//                        } else {
//                          if (RegExp(r'^[0-9]+$').hasMatch(value) &&
//                              value.length <= 6) {
//                            return null;
//                          } else {
//                            return '6桁以下の数字を入力してください';
//                          }
//                        }
//                      },
//                    ))),
                    Padding(
                        padding: const EdgeInsets.only(top: 12, left: 12),
                        child: Text(
                          'マッチ方法',
                          style: Theme.of(context).textTheme.subtitle1,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: RadioButton(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Center(
                          child: RaisedButton(
                        onPressed: isSubmitting
                            ? null
                            : () async {
                                // Validate will return true if the form is valid, or false if
                                // the form is invalid.
                                validateEmptyImage();
                                if (isSubmitting == false) {
                                  if (_formKey.currentState.validate()) {
                                    // If the form is valid, we want to show a Snackbar
                                    //Scaffold.of(context)
                                    //    .showSnackBar(SnackBar(content: Text('Processing Data')));
                                    isSubmitting = true;
                                    final createdPageId = await this.submit();
                                    if (createdPageId != -1) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OfferCreateConfirmationPage(
                                                  id: createdPageId),
                                          settings: RouteSettings(
                                              name:
                                                  'OfferCreateConfirmationPage'),
                                        ),
                                      );
                                    } else {
                                      final snackBar = SnackBar(
                                          content: Text(
                                        '編集に失敗しました。もう一度送信してください。',
                                      ));
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                    setState(() {
                                      isSubmitting = false;
                                    });
                                    print(createdPageId);
                                  }
                                }
                              },
                        child: Text('　更新　'),
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
              )),
          Positioned.fill(
              child: Align(
                  alignment: Alignment.center,
                  child: LoadIndicator(
                    visible: isSubmitting,
                  )))
        ]),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    titleInputController.dispose();
    detailsInputController.dispose();
    _titleFocus.dispose();
    _detailsFocus.dispose();

    super.dispose();
  }

  Future<int> submit() async {
    UnimplementedError("submit function is not override!");
    await Future.delayed(Duration(seconds: 1));
    return 1;
  }

  void setInitialData(Offer offer) {
    UnimplementedError(
        "setinitialdata(Offer Offer, Bloc bloc) function is not override!");
  }
}
