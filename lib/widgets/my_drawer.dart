import 'package:flutter/material.dart';
import '../config/my_router.dart';

class MyDrawer extends StatelessWidget {
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
        _changeRoute(context, routeName);
      },
    );
  }

  void _changeRoute(BuildContext context, String newRouteName) {
    // Close drawer
    Navigator.pop(context);

    // Check current screen status
    bool currentRouteIsHome = false;
    bool currentRouteIsNewRoute = false;

    Navigator.popUntil(context, (currentRoute) {
      print('currentRoute: ${currentRoute.settings.name}');
      // This is just a way to access currentRoute; the top route in the
      // Navigator stack.
      if (currentRoute.settings.name == MyRouter.HOME_SCREEN) {
        currentRouteIsHome = true;
      }
      if (currentRoute.settings.name == newRouteName) {
        currentRouteIsNewRoute = true;
      }

      // Return true so popUntil() pops nothing.
      return true;
    });

    print('newRouteName: $newRouteName');
    print('currentRouteIsHome: $currentRouteIsHome');
    print('currentRouteIsNewRoute: $currentRouteIsNewRoute');

    // Switch screen
    if (!currentRouteIsNewRoute) {
      // Only switch screen if new route is different from current route.
      if (currentRouteIsHome) {
        // Navigate from home to non-home screen.
        Navigator.pushNamed(context, newRouteName);
      } else {
        if (newRouteName == MyRouter.HOME_SCREEN) {
          // Navigate from non-home screen to home.
          Navigator.pop(context);
        } else {
          // Navigate from non-home screen to non-home screen.
          Navigator.popAndPushNamed(context, newRouteName);
        }
      }
    }
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
