import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/my_image_card.dart';
import '../models/movie.dart';
import '../models/series.dart';
import '../utils/constants.dart';
import '../models/genre.dart';
import '../widgets/my_drawer.dart';

class GenreScreen extends StatelessWidget {
  GenreScreen({@required this.genre}) : assert(genre != null);

  final Genre genre;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: MyDrawer(),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // print('innerBoxIsScrolled: $innerBoxIsScrolled');
            return [
              SliverAppBar(
                floating: true,
                snap: true,
                title: Text('${genre.name} Genre'),
                bottom: TabBar(
                  // indicatorColor: Colors.amber,
                  tabs: [
                    Tab(text: '${genre.name} Movies'),
                    Tab(text: '${genre.name} Series'),
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
      ),
    );
  }

  Widget _buildMoviesGenre() {
    return Consumer<List<Movie>>(
      builder: (context, moviesList, _) {
        List<Movie> newMoviesList = [];
        if (genre.id == '0')
          newMoviesList = [...moviesList];
        else
          newMoviesList =
              moviesList.where((m) => m.genreId == genre.id).toList();

        if (newMoviesList.isEmpty) return Center(child: Text('No Movies'));

        return Column(
          children: [
            Flexible(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: kLeftScreenSpace),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: newMoviesList.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150.0,
                    crossAxisSpacing: kCardSpacing,
                    mainAxisSpacing: kCardSpacing,
                    childAspectRatio: (kCardWidth / kCardHeight),
                  ),
                  itemBuilder: (context, index) {
                    final movie = newMoviesList[index];

                    return GestureDetector(
                      child: MyImageCard(imageUrl: movie.imageUrl),
                      onTap: () {},
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
        if (genre.id == '0')
          newSeriesList = [...seriesList];
        else
          newSeriesList =
              seriesList.where((m) => m.genreId == genre.id).toList();

        if (newSeriesList.isEmpty) return Center(child: Text('No Movies'));

        return Column(
          children: [
            Flexible(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: kLeftScreenSpace),
                child: GridView.builder(
                  itemCount: newSeriesList.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150.0,
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
                      onTap: () {},
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
