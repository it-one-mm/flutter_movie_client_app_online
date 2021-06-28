import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../screens/series_detail_screen.dart';
import '../screens/v_play_screen.dart';
import '../utils/route_handler.dart';
import '../ad_helper.dart';
import '../widgets/my_image_card.dart';
import '../models/movie.dart';
import '../models/series.dart';
import '../utils/constants.dart';
import '../models/genre.dart';
import '../widgets/my_drawer.dart';

class GenreScreen extends StatefulWidget {
  GenreScreen({@required this.genre}) : assert(genre != null);

  final Genre genre;

  @override
  _GenreScreenState createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  final logger = Logger();
  BannerAd _banner;
  bool _adLoaded = false;

  @override
  void dispose() {
    _banner?.dispose();
    _banner = null;

    super.dispose();
  }

  void _createBannerAd(BuildContext context) {
    AdHelper.createBannerAd(context, (ad) {
      logger.i('$BannerAd loaded.');
      setState(() {
        _banner = ad as BannerAd;
      });
    });
  }

  void _handleMovieTap(BuildContext context, Movie movie) {
    RouteHandler.buildMaterialRoute(
      context,
      VPlayScreen(
        path: movie.key,
        title: movie.title,
        isMovie: true,
        movieId: movie.id,
      ),
    );
  }

  void _handleSeriesTap(context, Series series) {
    AdHelper.showInterstitialAd();
    RouteHandler.buildMaterialRoute(
        context, SeriesDetailScreen(series: series));
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) {
        if (!_adLoaded) {
          _adLoaded = true;
          _createBannerAd(context);
        }
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            drawer: MyDrawer(),
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                // print('innerBoxIsScrolled: $innerBoxIsScrolled');
                return [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    title: Text('${widget.genre.name} Genre'),
                    bottom: TabBar(
                      // indicatorColor: Colors.amber,
                      tabs: [
                        Tab(text: '${widget.genre.name} Movies'),
                        Tab(text: '${widget.genre.name} Series'),
                      ],
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  _buildMoviesGenre(),
                  _buildSeriesGenre(),
                ],
              ),
            ),
            bottomNavigationBar: _banner != null
                ? Container(
                    width: _banner.size.width.toDouble(),
                    height: _banner.size.height.toDouble(),
                    child: AdWidget(ad: _banner),
                  )
                : Container(),
          ),
        );
      },
    );
  }

  Widget _buildMoviesGenre() {
    return Consumer<List<Movie>>(
      builder: (context, moviesList, _) {
        List<Movie> newMoviesList = [];
        if (widget.genre.id == '0')
          newMoviesList = [...moviesList];
        else
          newMoviesList =
              moviesList.where((m) => m.genreId == widget.genre.id).toList();

        if (newMoviesList.isEmpty) return Center(child: Text('No Movies'));

        return Column(
          children: [
            Flexible(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: kLeftScreenSpace),
                margin: const EdgeInsets.only(bottom: kBottomScreenSpace),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: newMoviesList.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: kGridItemMaxWidth,
                    crossAxisSpacing: kCardSpacing,
                    mainAxisSpacing: kCardSpacing,
                    childAspectRatio: (kCardWidth / kCardHeight),
                  ),
                  itemBuilder: (context, index) {
                    final movie = newMoviesList[index];

                    return GestureDetector(
                      child: MyImageCard(imageUrl: movie.imageUrl),
                      onTap: () {
                        _handleMovieTap(context, movie);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSeriesGenre() {
    return Consumer<List<Series>>(
      builder: (context, seriesList, _) {
        List<Series> newSeriesList = [];
        if (widget.genre.id == '0')
          newSeriesList = [...seriesList];
        else
          newSeriesList =
              seriesList.where((m) => m.genreId == widget.genre.id).toList();

        if (newSeriesList.isEmpty) return Center(child: Text('No Series'));

        return Column(
          children: [
            Flexible(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: kLeftScreenSpace),
                margin: const EdgeInsets.only(bottom: kBottomScreenSpace),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: newSeriesList.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: kGridItemMaxWidth,
                    crossAxisSpacing: kCardSpacing,
                    mainAxisSpacing: kCardSpacing,
                    childAspectRatio: (kCardWidth / kCardHeight),
                  ),
                  itemBuilder: (context, index) {
                    final series = newSeriesList[index];

                    return GestureDetector(
                      child: MyImageCard(
                        imageUrl: series.imageUrl,
                      ),
                      onTap: () {
                        _handleSeriesTap(context, series);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
