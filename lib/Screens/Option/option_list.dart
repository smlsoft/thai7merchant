import 'package:thai7merchant/Screens/Option/option_add.dart';
import 'package:flutter/material.dart';
import 'package:thai7merchant/Screens/Option/components/body.dart';
import 'package:thai7merchant/Screens/Dashboard/dashboard_screen.dart';
import 'package:thai7merchant/components/appbar.dart';

class OptionScreen extends StatelessWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: const Text('ตัวเลือกเสริม'),
        appBar: AppBar(),
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => DashboardScreen()));
          },
        ),
        widgets: const <Widget>[],
      ),
      body: const Body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => OptionAdd()));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
