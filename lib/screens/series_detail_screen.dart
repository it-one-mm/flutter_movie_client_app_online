import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:readmore/readmore.dart';
import '../ad_helper.dart';
import '../screens/v_play_screen.dart';
import '../utils/route_handler.dart';
import '../config/service_locator.dart';
import '../services/episode_service.dart';
import '../services/series_service.dart';
import '../widgets/my_image_card.dart';
import '../models/series.dart';
import '../models/episode.dart';
import '../utils/constants.dart';

class SeriesDetailScreen extends StatefulWidget {
  SeriesDetailScreen({@required this.series}) : assert(series != null);
  final Series series;
  @override
  _SeriesDetailScreenState createState() => _SeriesDetailScreenState();
}

class _SeriesDetailScreenState extends State<SeriesDetailScreen> {
  Series _series;
  Future<List<Episode>> _episodesListFuture;

  final logger = Logger();
  BannerAd _banner;
  bool _adLoaded = false;

  @override
  void initState() {
    super.initState();

    _series = widget.series;
    _init();
  }

  void _init() async {
    _episodesListFuture = getIt<EpisodeService>().getSeriesEpisodes(_series.id);

    await getIt<SeriesService>().updateViewCount(_series.id);
  }

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

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) {
        if (!_adLoaded) {
          _adLoaded = true;
          _createBannerAd(context);
        }
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: SafeArea(
            child: FutureBuilder<List<Episode>>(
              future: _episodesListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error Loading Episodes'),
                    );
                  } else {
                    final episodesList = snapshot.data ?? <Episode>[];

                    return NestedScrollView(
                      headerSliverBuilder: (_, __) => [
                        SliverAppBar(),
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Container(
                                padding: EdgeInsets.only(
                                    top: 20.0,
                                    left: kLeftScreenSpace,
                                    right: kLeftScreenSpace,
                                    bottom: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: kCardWidth,
                                      height: kCardHeight,
                                      child: MyImageCard(
                                        imageUrl: _series.imageUrl,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      _series.title,
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${episodesList.length} Episodes',
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.remove_red_eye),
                                        SizedBox(width: 5.0),
                                        Text('${_series.viewCount}'),
                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                    if (_series.description.isNotEmpty)
                                      ReadMoreText(
                                        _series.description,
                                        trimLength: 100,
                                      ),
                                    if (_series.description.isEmpty)
                                      Text('No Description'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      body: Column(
                        children: [
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: kLeftScreenSpace),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                              ),
                              child: ListView.builder(
                                itemCount: episodesList.length,
                                itemBuilder: (context, index) {
                                  final episode = episodesList[index];
                                  return Container(
                                    margin: EdgeInsets.only(
                                        top: 20.0,
                                        bottom: episodesList.length - 1 == index
                                            ? kBottomScreenSpace
                                            : 0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    child: ListTile(
                                      title: Text('Episode ${episode.no}'),
                                      trailing: Icon(Icons.play_circle_filled),
                                      onTap: () {
                                        RouteHandler.buildMaterialRoute(
                                          context,
                                          VPlayScreen(
                                            title:
                                                '${_series.title}\nEpisode ${episode.no}',
                                            path: episode.key,
                                          ),
                                          true,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
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
