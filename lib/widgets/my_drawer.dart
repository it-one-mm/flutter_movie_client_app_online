import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/genre.dart';
import '../utils/route_handler.dart';
import '../config/my_router.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool _expanded = false;

  ListTile _buildDrawerItem(
    BuildContext context, {
    @required String title,
    @required String routeName,
    IconData icon,
  }) {
    return ListTile(
      leading: icon != null ? Icon(icon) : null,
      title: Text(title),
      onTap: () {
        RouteHandler.changeRoute(context, routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 80.0,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset('assets/logo.png'),
                ),
                Text(
                  'App Name',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Version 1.0.0',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Theme.of(context).textTheme.caption.color,
                        fontSize: 12.0,
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home,
                  title: 'Home',
                  routeName: MyRouter.HOME_SCREEN,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.movie,
                  title: 'Movies',
                  routeName: MyRouter.MOVIES_SCREEN,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.playlist_play,
                  title: 'Series',
                  routeName: MyRouter.SERIES_SCREEN,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.search,
                  title: 'Search',
                  routeName: MyRouter.SEARCH_SCREEN,
                ),
                Consumer<List<Genre>>(
                  builder: (context, genresList, _) {
                    // copy genre List
                    final newGenresList = [...genresList];
                    newGenresList.insert(
                      0,
                      Genre(id: '0', name: 'All'),
                    );

                    // List<Genre> => List<ListTile>
                    final listTileWidgetsList = newGenresList
                        .map(
                          (genre) => ListTile(
                            title: Text(genre.name),
                            onTap: () {
                              RouteHandler.changeRoute(
                                context,
                                MyRouter.GENRE_SCREEN,
                                arguments: genre,
                              );
                            },
                          ),
                        )
                        .toList();

                    return ExpansionTile(
                      title: Text('Genres'),
                      leading: Icon(Icons.border_all),
                      maintainState: true,
                      children: listTileWidgetsList,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
