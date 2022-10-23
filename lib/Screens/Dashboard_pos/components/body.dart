import 'package:flutter/material.dart';
import 'package:thai7merchant/Screens/dashboard_pos/components/menu_landscape.dart';
import 'package:thai7merchant/components/background_dashboard.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      child: BackgroudDashboard(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.15,
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "บ้านหนองแวงซิตี้ช็อป",
                    style: TextStyle(
                      fontSize: 38.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const MenuListLandscapePos(),
            ],
          ),
        ),
      ),
    );
  }
}
