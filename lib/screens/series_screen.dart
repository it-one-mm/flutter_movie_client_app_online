import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/series_detail_screen.dart';
import '../utils/route_handler.dart';
import '../widgets/my_card.dart';
import '../widgets/my_image_card.dart';
import '../models/series.dart';
import '../widgets/my_drawer.dart';
import '../utils/constants.dart';

class SeriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final seriesList = Provider.of<List<Series>>(context);

    final popularSeriesList = [...seriesList];
    popularSeriesList.sort((b, a) => a.viewCount.compareTo(b.viewCount));

    final popularSeriesListLength = computeLimit(popularSeriesList.length);

    List<Series> allSeriesList = [...seriesList];
    allSeriesList.shuffle(Random());

    return Scaffold(
      drawer: MyDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text('Series'),
          ),
        ],
        body: seriesList.length == 0
            ? Center(
                child: Text('No Series'),
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: kBottomScreenSpace),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.only(left: kLeftScreenSpace),
                      title: Text('Popular Series'),
                    ),
                    Container(
                      height: kCardHeight,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: popularSeriesListLength,
                        itemBuilder: (context, index) {
                          final popularSeries = popularSeriesList[index];

                          return MyCard(
                            length: popularSeriesListLength,
                            index: index,
                            imageUrl: popularSeries.imageUrl,
                            onTap: () {
                              RouteHandler.buildMaterialRoute(
                                context,
                                SeriesDetailScreen(
                                  seriesId: popularSeries.id,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('All Series'),
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
                          itemCount: allSeriesList.length,
                          itemBuilder: (context, index) {
                            final series = allSeriesList[index];
                            return GestureDetector(
                              child: MyImageCard(
                                imageUrl: series.imageUrl,
                              ),
                              onTap: () {
                                RouteHandler.buildMaterialRoute(
                                  context,
                                  SeriesDetailScreen(
                                    seriesId: series.id,
                                  ),
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
      ),
    );
  }
}
