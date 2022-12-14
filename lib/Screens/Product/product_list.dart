import 'package:thai7merchant/Screens/Dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:thai7merchant/Screens/Product/components/body.dart';
import 'package:thai7merchant/Screens/Product/product_add.dart';
import 'package:thai7merchant/components/appbar.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: const Text('ทะเบียนสินค้า'),
        appBar: AppBar(),
        leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => DashboardScreen()));
            }),
        widgets: const <Widget>[],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const ProductAdd();
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
