import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../ad_helper.dart';
import '../screens/v_play_screen.dart';
import '../screens/series_detail_screen.dart';
import '../utils/route_handler.dart';
import '../config/my_router.dart';
import '../widgets/my_card.dart';
import '../widgets/title_tile.dart';
import '../widgets/my_drawer.dart';
import '../models/genre.dart';
import '../models/movie.dart';
import '../models/series.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final logger = Logger();
  BannerAd _banner;
  bool _adLoaded = false;

  @override
  void dispose() {
    _banner?.dispose();
    _banner = null;

    super.dispose();
  }

  void _createBanner(BuildContext context) {
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
    RouteHandler.buildMaterialRoute(
        context, SeriesDetailScreen(series: series));
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) {
        if (!_adLoaded) {
          _adLoaded = true;
          _createBanner(ctx);
        }
        return Scaffold(
          drawer: MyDrawer(),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  title: Text('Home'),
                ),
                SliverToBoxAdapter(
                  child: TitleTile(
                    onPressed: () {
                      Navigator.pushNamed(context, MyRouter.MOVIES_SCREEN);
                    },
                    title: 'Latest Movies',
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: kCardHeight,
                    child: Consumer<List<Movie>>(
                      builder: (context, movies, _) {
                        final length = computeLimit(movies.length);

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: length,
                          itemBuilder: (_, index) {
                            final movie = movies[index];

                            return MyCard(
                              length: length,
                              index: index,
                              imageUrl: movie.imageUrl,
                              onTap: () {
                                _handleMovieTap(context, movie);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: TitleTile(
                    onPressed: () {
                      Navigator.pushNamed(context, MyRouter.SERIES_SCREEN);
                    },
                    title: 'Latest Series',
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: kCardHeight,
                    child: Consumer<List<Series>>(
                      builder: (context, seriesList, _) {
                        final length = computeLimit(seriesList.length);

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: length,
                          itemBuilder: (_, index) {
                            final series = seriesList[index];

                            return MyCard(
                              length: length,
                              index: index,
                              imageUrl: series.imageUrl,
                              onTap: () {
                                _handleSeriesTap(context, series);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Consumer3<List<Genre>, List<Movie>, List<Series>>(
                  builder:
                      (context, genresList, moviesList, seriesList, child) {
                    return SliverPadding(
                      padding: EdgeInsets.only(bottom: kBottomScreenSpace),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final genre = genresList[index];

                            final newMoviesList = moviesList
                                .where((m) => m.genreId == genre.id)
                                .toList();
                            final moviesLength =
                                computeLimit(newMoviesList.length);

                            final newSeriesList = seriesList
                                .where((s) => s.genreId == genre.id)
                                .toList();
                            final seriesLength =
                                computeLimit(newSeriesList.length);

                            return Column(
                              children: [
                                if (moviesLength > 0 && seriesLength > 0)
                                  TitleTile(
                                    title: genre.name,
                                    titleStyle:
                                        Theme.of(context).textTheme.headline6,
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, MyRouter.GENRE_SCREEN,
                                          arguments: genre);
                                    },
                                  ),
                                if (moviesLength > 0)
                                  ListTile(
                                    contentPadding:
                                        EdgeInsets.only(left: kLeftScreenSpace),
                                    title: Text('${genre.name} Movies'),
                                  ),
                                if (moviesLength > 0)
                                  Container(
                                    height: kCardHeight,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: moviesLength,
                                      itemBuilder: (context, index) => MyCard(
                                        length: moviesLength,
                                        index: index,
                                        imageUrl: newMoviesList[index].imageUrl,
                                        onTap: () {
                                          _handleMovieTap(
                                              context, newMoviesList[index]);
                                        },
                                      ),
                                    ),
                                  ),
                                if (seriesLength > 0)
                                  ListTile(
                                    contentPadding:
                                        EdgeInsets.only(left: kLeftScreenSpace),
                                    title: Text('${genre.name} Series'),
                                  ),
                                if (seriesLength > 0)
                                  Container(
                                    height: kCardHeight,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: seriesLength,
                                      itemBuilder: (context, index) => MyCard(
                                        length: seriesLength,
                                        index: index,
                                        imageUrl: newSeriesList[index].imageUrl,
                                        onTap: () {
                                          _handleSeriesTap(
                                              context, newSeriesList[index]);
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                          childCount: genresList.length,
                        ),
                      ),
                    );
                  },
                ),
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
        );
      },
    );
  }
}
