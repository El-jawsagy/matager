import 'package:flutter/material.dart';

class SearchScreen extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Colors.lightBlue[800],
      primaryIconTheme: theme.primaryIconTheme.copyWith(
          color: Colors.grey[200]),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
    );
  }

  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => 'Search By Name';

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () {query='';})
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
      close(context, null);
    });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(

    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text('');
  }
}