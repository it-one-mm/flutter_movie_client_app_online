import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/my_card.dart';
import '../widgets/title_tile.dart';
import '../widgets/my_drawer.dart';
import '../models/genre.dart';
import '../models/movie.dart';
import '../models/series.dart';
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  int _computeLimit(int length) {
    return length < kShowLimit + 1 ? length : kShowLimit;
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {},
                title: 'Latest Movies',
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: kCardHeight,
                child: Consumer<List<Movie>>(
                  builder: (context, movies, _) {
                    final length = _computeLimit(movies.length);

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: length,
                      itemBuilder: (_, index) {
                        final movie = movies[index];

                        return MyCard(
                          length: length,
                          index: index,
                          imageUrl: movie.imageUrl,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: TitleTile(
                onPressed: () {},
                title: 'Latest Series',
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: kCardHeight,
                child: Consumer<List<Series>>(
                  builder: (context, seriesList, _) {
                    final length = _computeLimit(seriesList.length);

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: length,
                      itemBuilder: (_, index) {
                        final series = seriesList[index];

                        return MyCard(
                          length: length,
                          index: index,
                          imageUrl: series.imageUrl,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Consumer3<List<Genre>, List<Movie>, List<Series>>(
              builder: (context, genresList, moviesList, seriesList, child) {
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
                            _computeLimit(newMoviesList.length);

                        final newSeriesList = seriesList
                            .where((s) => s.genreId == genre.id)
                            .toList();
                        final seriesLength =
                            _computeLimit(newSeriesList.length);

                        return Column(
                          children: [
                            if (moviesLength > 0 && seriesLength > 0)
                              TitleTile(
                                title: genre.name,
                                titleStyle:
                                    Theme.of(context).textTheme.headline6,
                                onPressed: () {},
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
    );
  }
}
