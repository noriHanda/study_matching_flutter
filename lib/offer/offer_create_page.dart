import 'package:flutter/material.dart';
import 'package:study_matching/offer/offer_create_form.dart';

class OfferCreatePage extends StatelessWidget {
  static const String name = '募集作成';
  static const Icon icon = Icon(Icons.create);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: OfferCreateForm());
  }
}
