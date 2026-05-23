// responsive_utils.dart
// Utility helpers for responsive layout and scaled typography.

import 'package:flutter/material.dart';

// Breakpoints
const double mobileBreakpoint = 600;
const double tabletBreakpoint = 1024;

bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < mobileBreakpoint;
bool isTablet(BuildContext context) =>
    MediaQuery.of(context).size.width >= mobileBreakpoint && MediaQuery.of(context).size.width < tabletBreakpoint;
bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= tabletBreakpoint;

// Adaptive padding based on screen size.
EdgeInsets responsivePadding(BuildContext context) {
  if (isDesktop(context)) {
    return const EdgeInsets.symmetric(horizontal: 48, vertical: 24);
  } else if (isTablet(context)) {
    return const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
  } else {
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
  }
}

// Scaled font size utility.
double scaledFontSize(BuildContext context, double baseSize) {
  double width = MediaQuery.of(context).size.width;
  if (isDesktop(context)) {
    return baseSize * 1.2;
  } else if (isTablet(context)) {
    return baseSize * 1.1;
  } else {
    return baseSize;
  }
}

// Extension for easy padding usage.
extension ResponsivePadding on Widget {
  Widget withResponsivePadding(BuildContext context) => Padding(
        padding: responsivePadding(context),
        child: this,
      );
}
