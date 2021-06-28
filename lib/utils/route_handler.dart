import 'package:flutter/material.dart';
import '../ad_helper.dart';
import '../models/genre.dart';
import '../config/my_router.dart';

class RouteHandler {
  static Future<void> buildMaterialRoute(BuildContext context, Widget widget,
      [bool fullScreenDialog = false]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
        fullscreenDialog: fullScreenDialog,
      ),
    );
  }

  static void changeRoute(BuildContext context, String newRouteName,
      {Object arguments}) {
    // Close drawer
    Navigator.pop(context);

    // Check current screen status
    bool currentRouteIsHome = false;
    bool currentRouteIsNewRoute = false;

    Genre currentRouteArgs;

    Navigator.popUntil(context, (currentRoute) {
      // print('currentRoute: ${currentRoute.settings.name}');

      currentRouteArgs = currentRoute.settings?.arguments;
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

    // print('newRouteName: $newRouteName');
    // print('currentRouteIsHome: $currentRouteIsHome');
    // print('currentRouteIsNewRoute: $currentRouteIsNewRoute');

    // Switch screen
    if (!currentRouteIsNewRoute) {
      // Only switch screen if new route is different from current route.
      if (currentRouteIsHome) {
        AdHelper.showInterstitialAd();
        // Navigate from home to non-home screen.
        Navigator.pushNamed(context, newRouteName, arguments: arguments);
      } else {
        if (newRouteName == MyRouter.HOME_SCREEN) {
          // Navigate from non-home screen to home.
          Navigator.pop(context);
        } else {
          AdHelper.showInterstitialAd();
          // Navigate from non-home screen to non-home screen.
          Navigator.popAndPushNamed(context, newRouteName,
              arguments: arguments);
        }
      }
    } else {
      if (newRouteName == MyRouter.GENRE_SCREEN) {
        final Genre newRouteArgs = arguments;
        if (currentRouteArgs?.id != newRouteArgs.id) {
          AdHelper.showInterstitialAd();
          Navigator.popAndPushNamed(context, newRouteName,
              arguments: arguments);
        }
      }
    }
  }
}
