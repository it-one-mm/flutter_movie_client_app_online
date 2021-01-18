import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../widgets/my_card.dart';
import '../widgets/my_image_card.dart';
import '../models/movie.dart';
import '../widgets/my_drawer.dart';

class MoviesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moviesList = Provider.of<List<Movie>>(context);

    final popularMoviesList = [...moviesList];
    popularMoviesList.sort((b, a) => a.viewCount.compareTo(b.viewCount));

    final popularMoviesListLength = computeLimit(popularMoviesList.length);

    List<Movie> allMoviesList = [...moviesList];
    allMoviesList.shuffle(Random());

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
                      contentPadding: EdgeInsets.only(left: kLeftScreenSpace),
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
                            onTap: () {},
                          );
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('All Movies'),
                      contentPadding: EdgeInsets.only(left: kLeftScreenSpace),
                    ),
                    Flexible(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: kLeftScreenSpace),
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
                            return GestureDetector(
                              child: MyImageCard(
                                imageUrl: allMoviesList[index].imageUrl,
                              ),
                              onTap: () {},
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
