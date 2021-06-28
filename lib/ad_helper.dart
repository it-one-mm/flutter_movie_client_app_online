import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';

const int maxFailedLoadAttempts = 3;

class AdHelper {
  static final logger = Logger();
  static InterstitialAd _interstitialAd;
  static int _numInterstitialLoadAttempts = 0;
  static RewardedAd _rewardedAd;
  static int _numRewardedLoadAttempts = 0;

  static final AdRequest _request = AdRequest();

  static String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  static String get interstitialAdUnitId => Platform.isAndroid
      ? "ca-app-pub-3940256099942544/1033173712"
      : "ca-app-pub-3940256099942544/4411468910";

  static String get rewardedAdUnitId => Platform.isAndroid
      ? "ca-app-pub-3940256099942544/5224354917"
      : "ca-app-pub-3940256099942544/1712485313";

  static Future<void> createBannerAd(
      BuildContext context, void Function(Ad ad) onAdLoaded) async {
    final AnchoredAdaptiveBannerAdSize size =
        await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      logger.e('Unable to get height of anchored banner.');
      return;
    }

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: size,
      request: _request,
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          logger.e('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  static void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: _request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          logger.i('$ad loaded');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          logger.e('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            createInterstitialAd();
          }
        },
      ),
    );
  }

  static void showInterstitialAd() {
    if (_interstitialAd == null) {
      logger.w('Attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          logger.i('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        logger.i('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        logger.e('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    _interstitialAd.show();
    _interstitialAd = null;
  }

  static void createRewardedAd() {
    RewardedAd.load(
        adUnitId: RewardedAd.testAdUnitId,
        request: _request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            logger.i('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            logger.e('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              createRewardedAd();
            }
          },
        ));
  }

  static void showRewardedAd(
      {void Function(RewardedAd, RewardItem) onUserEarnedReward}) {
    if (_rewardedAd == null) {
      logger.w('Attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          logger.i('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        logger.i('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        logger.e('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createRewardedAd();
      },
    );

    _rewardedAd.show(onUserEarnedReward: onUserEarnedReward);
    _rewardedAd = null;
  }

  static void releaseAdResource() {
    releaseInterstitialAd();
    releaseRewardedAd();
  }

  static void releaseInterstitialAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }

  static void releaseRewardedAd() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }
}
