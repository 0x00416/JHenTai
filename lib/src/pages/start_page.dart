import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:jhentai/src/config/theme_config.dart';
import 'package:jhentai/src/pages/blank_page.dart';
import 'package:jhentai/src/pages/home/home_page.dart';
import 'package:jhentai/src/routes/routes.dart';
import 'package:jhentai/src/setting/advanced_setting.dart';
import 'package:jhentai/src/setting/style_setting.dart';
import 'package:jhentai/src/utils/size_util.dart';
import 'package:local_auth/local_auth.dart';

import 'lock_page.dart';

const int left = 1;
const int right = 2;
const int fullScreen = 3;

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (StyleSetting.enableTabletLayout.isFalse || screenWidth < 600) {
        return HomePage();
      }

      /// tablet layout
      return Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _leftScreen()),
                Container(width: 0.3, color: Colors.black),
              ],
            ),
          ),
          Expanded(child: _rightScreen()),
        ],
      );
    });
  }

  Widget _leftScreen() {
    return Navigator(
      key: Get.nestedKey(left),

      /// make sure controller is destroyed automatically and route args is passed properly
      observers: [GetObserver(null, Get.routing)],
      onGenerateInitialRoutes: (_, __) => [
        GetPageRoute(
          settings: const RouteSettings(name: Routes.home),
          page: () => HomePage(),
          popGesture: true,
          transition: Transition.fadeIn,
          showCupertinoParallax: false,
        ),
      ],
      onGenerateRoute: (settings) {
        Get.parameters = Get.routeTree.matchRoute(settings.name!).parameters;

        return GetPageRoute(
          settings: settings,

          /// setting name may include path params
          page: Routes.pages.firstWhere((page) => settings.name!.split('?')[0] == page.name).page,

          popGesture: true,
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 150),
        );
      },
    );
  }

  Widget _rightScreen() {
    return Navigator(
      key: Get.nestedKey(right),
      observers: [GetObserver(null, Get.routing)],
      onGenerateInitialRoutes: (_, __) => [
        GetPageRoute(
          settings: const RouteSettings(name: Routes.blank),
          page: () => const BlankPage(),
          popGesture: false,
          transition: Transition.fadeIn,
          showCupertinoParallax: false,
        ),
      ],
      onGenerateRoute: (settings) {
        Get.parameters = Get.routeTree.matchRoute(settings.name!).parameters;
        return GetPageRoute(
          settings: settings,

          /// setting name may include path params
          page: Routes.pages.firstWhere((page) => settings.name!.split('?')[0] == page.name).page,

          /// do not use swipe back in tablet layout!
          popGesture: false,
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 150),
          showCupertinoParallax: false,
        );
      },
    );
  }
}
