

import 'package:c0nnect/PageController.dart';
import 'package:c0nnect/Setup/loginScreen.dart';
import 'package:get/get.dart';

import '../splash_screen.dart';

class Routes {
  static final route = [
    GetPage(
      name: '/splash',
      page: () => SplashScreen(),
    ),
    GetPage(
      name: '/controller',
      page: () => Controller(),
    ),
    GetPage(
      name: '/login',
      page: () => LoginPage(),
    ),


  ];
}