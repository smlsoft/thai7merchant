import 'package:flutter/material.dart';
import 'package:thai7merchant/screens/Dashboard/components/menu_landscape.dart';
import 'package:thai7merchant/screens/Dashboard/components/menu_portrait.dart';
import 'package:thai7merchant/components/background_dashboard.dart';
import 'package:thai7merchant/util.dart';
import 'package:thai7merchant/components/background_dashboard.dart';
import 'package:get_storage/get_storage.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Widget screenSize = Container();

    if (Util.isLandscape(context)) {
      screenSize = const MenuListLandscape();
    } else {
      screenSize = const MenuListPortrait();
    }

    final appConfig = GetStorage("AppConfig");
    String shopid = appConfig.read("shopid");
    String name = appConfig.read("name");

    // This size provide us totl height and width of our screen
    return BackgroudDashboard(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.15,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 38.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            screenSize,
          ],
        ),
      ),
    );
  }
}
