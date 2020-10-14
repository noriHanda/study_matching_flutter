import 'package:flutter/material.dart';
import 'package:study_matching/offer/offer.dart';
import 'package:study_matching/offer/offer_api.dart';
import 'package:study_matching/offer/offer_form_with_tag.dart';
import 'package:study_matching/offer/matching_way_radio_button.dart';

class OfferCreateForm extends StatefulWidget {
  final Offer offer;

  OfferCreateForm({Key key, this.offer}) : super(key: key);

  @override
  CreateOfferFormState createState() => CreateOfferFormState();
}

class CreateOfferFormState
    extends AbstractOfferInputFormState<OfferCreateForm> {
  @override
  void initState() {
    super.initState();
    titleInputController = TextEditingController(text: "");
    detailsInputController = TextEditingController(text: "");
  }

  @override
  Future<int> submit() async {
    final title = titleInputController.text;
    final details = detailsInputController.text;
    final matchingWay = RadioButtonState.matchingWay;
    final offerApi = OfferApi();
    final offer = await offerApi.create(title, details, image, matchingWay);
    if (offer.statusCode == 201) {
      titleInputController.text = '';
      detailsInputController.text = '';
      return offer.offer.id;
    } else {
      return -1;
    }
  }
}
