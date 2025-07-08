import 'package:flutter/material.dart';

import 'package:time_attend_recognition/features/auth/presentation/screens/login_screen.dart';
import 'package:time_attend_recognition/features/auth/presentation/screens/register_screen.dart';
import 'package:time_attend_recognition/features/home/presentation/screens/home_screen.dart';
import 'package:time_attend_recognition/features/members/presentation/screens/employees_screen.dart';

import 'package:time_attend_recognition/features/users/presentation/screens/users_screen.dart';

import 'routes.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.login:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return const LoginScreen();
          },
        );
      case Routes.register:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return const RegisterScreen();
          },
        );
      case Routes.home:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return arguments == null
                ? const HomeScreen()
                : HomeScreen(
                    getAllEmployees: arguments as bool,
                  );
          },
        );
      case Routes.employees:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return const EmployeesScreen();
          },
        );
      case Routes.usersEmployees:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return const UsersEmployeesScreen();
          },
        );
      // case Routes.cachedData:
      //   return PageRouteBuilder(
      //     settings: settings,
      //     pageBuilder: (context, animation, secondaryAnimation) {
      //       return const CachedDataScreen();
      //     },
      //   );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
