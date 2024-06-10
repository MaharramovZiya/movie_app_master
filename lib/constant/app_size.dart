import 'package:flutter/widgets.dart';

class AppWidgetsSize {
  final BuildContext context;

  AppWidgetsSize(this.context);

  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;

  double heightPercentage(double percentage) {
    return height * (percentage / 100);
  }

  double widthPercentage(double percentage) {
    return width * (percentage / 100);
  }
}
