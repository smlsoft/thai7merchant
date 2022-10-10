import 'package:flutter/material.dart';
import 'package:thai7merchant/Screens/Category/category_add.dart';
import 'package:thai7merchant/Screens/Category/components/body.dart';
import 'package:thai7merchant/Screens/Dashboard/dashboard_screen.dart';
import 'package:thai7merchant/components/appbar.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: const Text('ค้นหาหมวดหมู่สินค้า'),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const CategoryAdd();
              },
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
