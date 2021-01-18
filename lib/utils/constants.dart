const String kErrorLoadingImageText = '😢';

const double kCardHeight = 150.0;
const double kCardWidth = 100.0;
const double kCardSpacing = 10.0;

const int kShowLimit = 10;

const double kLeftScreenSpace = 20.0;
const double kBottomScreenSpace = 50.0;

const double kGridItemMaxWidth = 150.0;

int computeLimit(int length) {
  return length < kShowLimit + 1 ? length : kShowLimit;
}
