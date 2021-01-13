import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/my_card.dart';
import '../widgets/title_tile.dart';
import '../widgets/my_drawer.dart';
import '../models/movie.dart';
import '../models/series.dart';

class HomeScreen extends StatelessWidget {
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
                height: 150.0,
                child: Consumer<List<Movie>>(
                  builder: (context, movies, _) {
                    final length = movies.length < 11 ? movies.length : 10;

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
                height: 150.0,
                child: Consumer<List<Series>>(
                  builder: (context, seriesList, _) {
                    final length =
                        seriesList.length < 11 ? seriesList.length : 10;

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
          ],
        ),
      ),
    );
  }
}
