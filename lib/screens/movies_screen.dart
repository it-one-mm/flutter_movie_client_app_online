import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../ad_helper.dart';
import '../utils/constants.dart';
import '../widgets/my_card.dart';
import '../widgets/my_image_card.dart';
import '../models/movie.dart';
import '../widgets/my_drawer.dart';
import '../screens/v_play_screen.dart';
import '../utils/route_handler.dart';

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
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

  @override
  Widget build(BuildContext context) {
    final moviesList = Provider.of<List<Movie>>(context);

    final popularMoviesList = [...moviesList];
    popularMoviesList.sort((b, a) => a.viewCount.compareTo(b.viewCount));

    final popularMoviesListLength = computeLimit(popularMoviesList.length);

    List<Movie> allMoviesList = [...moviesList];
    allMoviesList.shuffle(Random());

    return Builder(
      builder: (ctx) {
        if (!_adLoaded) {
          _adLoaded = true;
          _createBannerAd(ctx);
        }
        return Scaffold(
          drawer: MyDrawer(),
          body: NestedScrollView(
            headerSliverBuilder: (_, __) => [
              SliverAppBar(
                floating: true,
                snap: true,
                title: Text('Movies'),
              ),
            ],
            body: moviesList.length == 0
                ? Center(
                    child: Text('No Movies'),
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: kBottomScreenSpace),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          contentPadding:
                              EdgeInsets.only(left: kLeftScreenSpace),
                          title: Text('Popular Movies'),
                        ),
                        Container(
                          height: kCardHeight,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: popularMoviesListLength,
                            itemBuilder: (context, index) {
                              final popularMovie = popularMoviesList[index];

                              return MyCard(
                                length: popularMoviesListLength,
                                index: index,
                                imageUrl: popularMovie.imageUrl,
                                onTap: () {
                                  _handleMovieTap(context, popularMovie);
                                },
                              );
                            },
                          ),
                        ),
                        ListTile(
                          title: Text('All Movies'),
                          contentPadding:
                              EdgeInsets.only(left: kLeftScreenSpace),
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: kLeftScreenSpace),
                            child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: kGridItemMaxWidth,
                                crossAxisSpacing: kCardSpacing,
                                mainAxisSpacing: kCardSpacing,
                                childAspectRatio: (kCardWidth / kCardHeight),
                              ),
                              itemCount: allMoviesList.length,
                              itemBuilder: (context, index) {
                                final movie = allMoviesList[index];

                                return GestureDetector(
                                  child: MyImageCard(
                                    imageUrl: movie.imageUrl,
                                  ),
                                  onTap: () {
                                    _handleMovieTap(context, movie);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
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
