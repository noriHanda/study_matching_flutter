import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:study_matching/offer/offer.dart';
import 'package:study_matching/offer/offer_details_page.dart';

class OfferBox extends StatelessWidget {
  OfferBox({@required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OfferDetailsPage(
                id: offer.id,
              ),
              settings: RouteSettings(name: 'OfferDetailsPage'),
            ),
          );
        },
        child: AspectRatio(
          aspectRatio: 1,
          child: Card(
            child: Container(
                child: Column(
              children: <Widget>[
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: CachedNetworkImageProvider(offer.iconUrl ??
                        'http://design-ec.com/d/e_others_50/m_e_others_501.jpg'),
                    fit: BoxFit.contain,
                  )),
                )),
                Padding(
                    padding: EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Text(
                      offer.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ],
            )),
          ),
        ));
  }
}
