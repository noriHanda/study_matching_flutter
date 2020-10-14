import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/offer/offer.dart';
import 'package:study_matching/offer/offer_api.dart';
import 'package:study_matching/offer/offer_bloc.dart';
import 'package:study_matching/offer/offer_update_form_base.dart';
import 'package:study_matching/offer/matching_way_radio_button.dart';

class OfferUpdateForm extends StatefulWidget {
  final int offerId;
  OfferUpdateForm({this.offerId});

  @override
  CreateOfferFormState createState() => CreateOfferFormState(offerId: offerId);
}

class CreateOfferFormState
    extends AbstractOfferUpdateformState<OfferUpdateForm> {
  CreateOfferFormState({this.offerId});

  final int offerId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final offerBloc = Provider.of<OfferBloc>(context);
    final List<Offer> offersFoundbyId =
        offerBloc.offers.value.where((x) => x.id == offerId).toList();
    if (offersFoundbyId != [] && offersFoundbyId.length == 1) {
      final offer = offersFoundbyId[0];
      titleInputController = TextEditingController(text: offer.title ?? "");
      detailsInputController =
          TextEditingController(text: offer.description ?? "");
      iconUrl = offer.iconUrl;
    } else {
      titleInputController = TextEditingController(text: "");
      detailsInputController = TextEditingController(text: "");
    }
  }

  @override
  Future<int> submit() async {
    final title = titleInputController.text;
    final details = detailsInputController.text;
    final matchingWay = RadioButtonState.matchingWay;
    final offerApi = OfferApi();
    final offer =
        await offerApi.update(offerId, title, details, image, matchingWay);
    if (offer.statusCode == 200) {
      titleInputController.text = '';
      detailsInputController.text = '';
      return offer.offer.id;
    } else {
      return -1;
    }
  }
}
