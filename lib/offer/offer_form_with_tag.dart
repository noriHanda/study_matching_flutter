import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:study_matching/common/ui/load_indicator.dart';
import 'package:study_matching/offer/matching_way_description.dart';
import 'package:study_matching/offer/matching_way_radio_button.dart';
import 'package:study_matching/offer/offer.dart';
import 'package:study_matching/offer/offer_create_confirmation_page.dart';

abstract class AbstractOfferInputFormState<T extends StatefulWidget>
    extends State<T> {
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  final _titleFocus = FocusNode();
  final _detailsFocus = FocusNode();

  bool isSubmitting = false;
  File image;
  String imageErrorText = '';

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
    if (image == null) {
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
    // This container is required when using keyboard actions. Change the height if necessary
    return Container(
      height: 750,
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '画像',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    RaisedButton(
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
                    ),
                    image != null
                        ? Center(
                            child: Container(
                                height: 100, child: Image.file(image)))
                        : Container(),
                    imageErrorText != ''
                        ? Text(imageErrorText,
                            style: TextStyle(color: Colors.red))
                        : Container(),
                    Center(
                        child: TextFormField(
                      decoration: InputDecoration(
                        labelText: '募集タイトル',
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      autofocus: false,
                      focusNode: _titleFocus,
                      controller: titleInputController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Paalease enter some text';
                        } else {
                          return null;
                        }
                      },
                    )),
                    Center(
                        child: TextFormField(
                      decoration: InputDecoration(
                        labelText: '詳細',
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.newline,
                      focusNode: _detailsFocus,
                      controller: detailsInputController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        } else {
                          return null;
                        }
                      },
                      maxLines: 10,
                    )),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      'マッチ方法',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    RadioButton(),
                    Center(
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
                                                      id: createdPageId)));
                                    } else {
                                      final snackBar = SnackBar(
                                          content: Text(
                                        '投稿に失敗しました。もう一度送信してください。',
                                      ));
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                    isSubmitting = false;
                                    print(createdPageId);
                                  }
                                }
                              },
                        child: Text('作成'),
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
                    SizedBox(
                      height: 16.0,
                    ),
                    MatchingWayDescription(),
                  ],
                ),
              ),
//          ),
            ),
          ),
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
