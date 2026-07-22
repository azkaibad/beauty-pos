// lib/core/utils/responsive.dart

import 'package:flutter/widgets.dart';

class Responsive {
  Responsive._();

  static const double _mobileBreakpoint = 600;
  static const double _desktopBreakpoint = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < _mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= _mobileBreakpoint && width < _desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= _desktopBreakpoint;
}
