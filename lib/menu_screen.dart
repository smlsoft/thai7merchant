import 'package:flutter/material.dart';
import 'package:thai7merchant/Screens/config/config.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Menu'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Column(children: [
              const Text('กำหนดค่าเริ่มต้น'),
              Wrap(children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UnitScreen()),
                    );
                  },
                  child: const Text('หน่วยนับสินค้า'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CategoryScreen()),
                    );
                  },
                  child: const Text('กลุ่มสินค้า'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ColorScreen()),
                    );
                  },
                  child: const Text('สีสินค้า'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PatternScreen()),
                    );
                  },
                  child: const Text('รูปแบบสินค้า'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ColorScreen()),
                    );
                  },
                  child: const Text('โครงสร้างสินค้า'),
                ),
              ]),
            ]),
          ]),
        ));
  }
}
