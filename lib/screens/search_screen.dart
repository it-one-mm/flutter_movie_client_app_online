import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/my_image_card.dart';
import '../models/movie.dart';
import '../models/series.dart';
import '../utils/constants.dart';
import '../widgets/my_drawer.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const double _topSearchBarPadding = 16.0;

  final _movieSearchController = TextEditingController();
  final _seriesSearchController = TextEditingController();

  List<Movie> _filteredMoviesList = [];
  bool _movieNotFound = false;
  List<Series> _filteredSeriesList = [];
  bool _seriesNotFound = false;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    final fsMoviesList = context.read<List<Movie>>();
    _filteredMoviesList = [...fsMoviesList];

    final fsSeriesList = context.read<List<Series>>();
    _filteredSeriesList = [...fsSeriesList];
  }

  @override
  void dispose() {
    _movieSearchController.dispose();
    _seriesSearchController.dispose();

    super.dispose();
  }

  InputDecoration _buildSearchInputDecoration() {
    return InputDecoration(
      hintText: 'Search...',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      prefixIcon: Icon(Icons.search),
    );
  }

  Container _buildHorizontalListView(
      {int itemCount, @required IndexedWidgetBuilder itemBuilder}) {
    assert(itemCount == null || itemCount >= 0);
    assert(itemBuilder != null);

    return Container(
      constraints: BoxConstraints(
        minHeight: 180.0,
        maxHeight: 200.0,
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }

  Container _buildListItem({
    @required int index,
    @required int length,
    @required String imageUrl,
    @required String title,
    Function onTap,
  }) {
    assert(index != null);
    assert(length != null);
    assert(imageUrl != null);
    assert(title != null);

    return Container(
      margin: EdgeInsets.only(
        left: index == 0 ? kLeftScreenSpace : kCardSpacing,
        right: length - 1 == index ? kLeftScreenSpace : 0,
      ),
      width: kCardWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: kCardHeight,
              child: MyImageCard(
                imageUrl: imageUrl,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      drawer: MyDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: kBottomScreenSpace),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: _topSearchBarPadding,
                  left: kLeftScreenSpace,
                  right: kLeftScreenSpace,
                ),
                child: TextFormField(
                  controller: _movieSearchController,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: _buildSearchInputDecoration().copyWith(
                    hintText: 'Search Movies...',
                    suffixIcon: _movieSearchController.text.trim().isEmpty
                        ? null
                        : GestureDetector(
                            onTap: () {
                              _movieSearchController.text = '';

                              final fsMoviesList = context.read<List<Movie>>();
                              _filteredMoviesList = [...fsMoviesList];
                              _movieNotFound = false;

                              setState(() {});
                            },
                            child: Icon(Icons.clear),
                          ),
                  ),
                  onChanged: (val) {
                    final fsMoviesList = context.read<List<Movie>>();

                    if (val.trim().isNotEmpty) {
                      _filteredMoviesList = [...fsMoviesList]
                          .where((movie) => movie.title
                              .toLowerCase()
                              .startsWith(val.trim().toLowerCase()))
                          .toList();

                      if (_filteredMoviesList.length == 0)
                        _movieNotFound = true;
                      else
                        _movieNotFound = false;
                    } else {
                      _filteredMoviesList = [...fsMoviesList];
                      _movieNotFound = false;
                    }

                    setState(() {});
                  },
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.only(left: kLeftScreenSpace),
                title: Text('Movies'),
              ),
              if (_movieNotFound)
                Center(
                  child: Text('Movie Not Found'),
                ),
              if (!_movieNotFound)
                _buildHorizontalListView(
                  itemCount: _filteredMoviesList.length,
                  itemBuilder: (context, index) {
                    final movie = _filteredMoviesList[index];

                    return _buildListItem(
                      index: index,
                      length: _filteredMoviesList.length,
                      imageUrl: movie.imageUrl,
                      title: movie.title,
                      onTap: () {},
                    );
                  },
                ),
              Padding(
                padding: const EdgeInsets.only(
                  top: _topSearchBarPadding,
                  left: kLeftScreenSpace,
                  right: kLeftScreenSpace,
                ),
                child: TextFormField(
                  controller: _seriesSearchController,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: _buildSearchInputDecoration().copyWith(
                    hintText: 'Search Series...',
                    suffixIcon: _seriesSearchController.text.trim().isEmpty
                        ? null
                        : GestureDetector(
                            onTap: () {
                              _seriesSearchController.text = '';

                              final fsSeriesList = context.read<List<Series>>();
                              _filteredSeriesList = [...fsSeriesList];
                              _seriesNotFound = false;

                              setState(() {});
                            },
                            child: Icon(Icons.clear),
                          ),
                  ),
                  onChanged: (val) {
                    final fsSeriesList = context.read<List<Series>>();

                    if (val.trim().isNotEmpty) {
                      _filteredSeriesList = [...fsSeriesList]
                          .where((series) => series.title
                              .toLowerCase()
                              .startsWith(val.trim().toLowerCase()))
                          .toList();

                      if (_filteredSeriesList.length == 0)
                        _seriesNotFound = true;
                      else
                        _seriesNotFound = false;
                    } else {
                      _filteredSeriesList = [...fsSeriesList];
                      _seriesNotFound = false;
                    }

                    setState(() {});
                  },
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.only(left: kLeftScreenSpace),
                title: Text('Series'),
              ),
              if (_seriesNotFound)
                Center(
                  child: Text('Series Not Found'),
                ),
              if (!_seriesNotFound)
                _buildHorizontalListView(
                  itemCount: _filteredSeriesList.length,
                  itemBuilder: (context, index) {
                    final series = _filteredSeriesList[index];

                    return _buildListItem(
                      index: index,
                      length: _filteredSeriesList.length,
                      imageUrl: series.imageUrl,
                      title: series.title,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
