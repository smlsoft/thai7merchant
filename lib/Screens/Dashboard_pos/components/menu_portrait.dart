import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:thai7merchant/screens/Member/member_list.dart';
import 'package:thai7merchant/screens/Product/product_list.dart';
import 'package:thai7merchant/screens/Purchase/purchase_list.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MenuListPortraitPos extends StatefulWidget {
  const MenuListPortraitPos({Key? key}) : super(key: key);

  @override
  _MenuListPortraitPosState createState() => _MenuListPortraitPosState();
}

class _MenuListPortraitPosState extends State<MenuListPortraitPos> {
  List MenuListProduct = [
    _MenuItem(Icons.work_outline, 'สินค้า', 'product'),
    _MenuItem(Icons.description, 'ซื้อสินค้า', 'purchase'),
    _MenuItem(Icons.point_of_sale, 'POS', 'pos'),
    _MenuItem(Icons.person_outline, 'สมาชิก', 'member'),
    _MenuItem(Icons.add_chart, 'รับจ่ายสินค้า', 'receive'),
    _MenuItem(Icons.list_alt, 'เบิกสินค้า', 'receive'),
    _MenuItem(Icons.add_chart, 'หมวดหมู่สินค้า', 'category'),
    _MenuItem(Icons.list_alt, 'ปรับปรุง', 'member'),
    _MenuItem(Icons.add_chart, 'รายงานสินค้า ', 'report'),
  ];

  @override
  void dispose() {
    super.dispose();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Card(
          child: Container(
            height: size.height * 0.3,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: MenuListProduct.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: size.height / (size.width / 0.6),
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: InkWell(
                    onTap: () {
                      goTo(MenuListProduct[index].page);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          MenuListProduct[index].icon,
                          size: 30,
                          color: const Color(0xFFF56045),
                        ),
                        AutoSizeText(
                          MenuListProduct[index].title,
                          textAlign: TextAlign.center,
                          // overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void goTo(page) {
    if (page == 'member') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MemberScreen();
          },
        ),
      );
    } else if (page == 'purchase') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return PurchaseScreen();
          },
        ),
      );
    } else if (page == 'product') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ProductScreen();
          },
        ),
      );
    }
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String page;

  _MenuItem(this.icon, this.title, this.page);
}
