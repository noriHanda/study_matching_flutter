import 'package:flutter/material.dart';
import 'package:study_matching/search/offer_search_form.dart';
/*
import 'package:provider/provider.dart';
import 'package:study_matching/search/offer_search_result_page.dart';
import 'package:study_matching/tag/selected_tag_bloc.dart';
import 'package:study_matching/tag/tag_bloc.dart';
*/

class OfferSearchPage extends StatefulWidget {
  @override
  _OfferSearchPageState createState() => _OfferSearchPageState();
}

class _OfferSearchPageState extends State<OfferSearchPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*
    final tagBloc = Provider.of<TagBloc>(context);
    tagBloc.fetchTags();
    final selectedTagIdBloc = Provider.of<SelectedTagBloc>(context);
    */

    return Scaffold(
      appBar: AppBar(brightness: Brightness.dark, title: Text('検索')),
      body: SafeArea(top: false, child: OfferSearchForm()),
    );
  }
}
