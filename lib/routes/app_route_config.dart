import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:translator/pages/error_page.dart';
import 'package:translator/pages/home_page.dart';
import 'package:translator/pages/sign_up_page.dart';
import 'package:translator/routes/app_route_constants.dart';
import 'package:translator/pages/login_page.dart';

class MyAppRouter {
  static GoRouter returnRouter(bool isAuth) {
    GoRouter router = GoRouter(
    routes: [
      GoRoute(
          name: MyAppRouteConstants.homeRouteName,
          path: '/',
          pageBuilder: (context, state) {
            return const MaterialPage(child: HomePage());
          }),
      GoRoute(
          name: MyAppRouteConstants.loginRouteName,
          path: '/login',
          pageBuilder: (context, state) {
            return const MaterialPage(child: LoginPage());
          }),
      GoRoute(
          name: MyAppRouteConstants.signUpRouteName,
          path: '/signUp',
          pageBuilder: (context, state) {
            return const MaterialPage(child: SignUpPage());
          }),
    ],
    errorPageBuilder: (context, state) {
        return const MaterialPage(child: ErrorPage());
    },
    redirect: (context, state) {
      if (!isAuth &&
          state.location.startsWith(MyAppRouteConstants.homeRouteName)) {
        return context.namedLocation(MyAppRouteConstants.loginRouteName);
      } else {
        return null;
      }
    },
  );
    return router;
  }
}
