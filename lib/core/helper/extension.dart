import 'package:flutter/material.dart';

extension ThemeText on BuildContext {
  TextTheme get style => Theme.of(this).textTheme;

  TextStyle get titleSmall => style.titleSmall!;

  TextStyle get titleMedium => style.titleMedium!;

  TextStyle get titleLarge => style.titleLarge!;
}

extension Navigation on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;

  double get screenWidth => MediaQuery.of(this).size.width;

  // navigation
  Future<dynamic> pushNamed(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
    required RoutePredicate predicate,
  }) {
    return Navigator.of(this).pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pop() => Navigator.of(this).pop();
}

// =============================================================================

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MagicRouter {
  static BuildContext currentContext = navigatorKey.currentContext!;

  static void navigateTo({required Widget page, bool withHistory = true}) {
    Navigator.pushAndRemoveUntil(
      currentContext,
      PageRouteBuilder(
        transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
        pageBuilder: (context, animation, secondaryAnimation) => page,
      ),
      (route) => withHistory,
    );
  }

  static void navigateReplacement({required Widget page}) {
    Navigator.pushReplacement(
      currentContext,
      PageRouteBuilder(
        transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
        pageBuilder: (context, animation, secondaryAnimation) => page,
      ),
    );
  }

  static void pop() {
    Navigator.pop(currentContext);
  }
}
