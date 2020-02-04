import 'package:flutter/material.dart';
import 'package:hacker_news/api/api.dart';
import 'package:hacker_news/models/item.dart';
import 'package:hacker_news/ui/widgets/error.dart';
import 'package:hacker_news/ui/widgets/item_row.dart';
import 'package:hacker_news/ui/widgets/loading.dart';

class ItemList extends StatefulWidget {
  final StoryType type;

  const ItemList({Key key, this.type}) : super(key: key);

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  HackerNewsApi _api = HackerNewsApi();
  bool _isLoading = false;
  String _errorLoading;
  List<dynamic> _ids = [];
  Map<int, Item> items = Map();

  @override
  void initState() {
    super.initState();
    fetchStories();
  }

  void fetchStories() async {
    setState(() {
      this._ids = [];
      this.items = Map();
      this._isLoading = true;
      this._errorLoading = null;
    });

    try {
      var ids = await _api.fetchStories(widget.type);
      print(ids);
      setState(() {
        this._isLoading = false;
        this._ids = ids.toList();
      });
    } catch (e) {
      setState(() {
        this._isLoading = false;
        this._errorLoading = "Failed to fetch stories";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return this._errorLoading != null
        ? ErrorHt(
      error: "ssss",
    )
        : this._isLoading
        ? LoadingIndicator()
        : ListView.builder(
      itemCount: this._ids.length,
      itemBuilder: (BuildContext context, int position) {
        return FutureBuilder(
          future: _api.getItem(this._ids[position]),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (items[position] != null) {
              var item = items[position];
              return ItemRow(item: item, key: Key(item.id.toString()),);
            }

            if (snapshot.hasData && snapshot.data != null) {
              var item = snapshot.data;
              items[position] = item;
              return ItemRow(item: item, key: Key(item.id.toString()),);
            } else if (snapshot.hasError) {
              return ErrorHt(error: "Error to load story",);
            } else {
              return LoadingIndicator();
            }
          },
        );
      },
    );
  }
}
