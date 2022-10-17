import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:thai7merchant/screens/Member/member_list.dart';
import 'package:thai7merchant/screens/Product/product_list.dart';
import 'package:thai7merchant/screens/Purchase/purchase_list.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MenuListLandscapePos extends StatefulWidget {
  const MenuListLandscapePos({Key? key}) : super(key: key);

  @override
  _MenuListLandscapePosState createState() => _MenuListLandscapePosState();
}

class _MenuListLandscapePosState extends State<MenuListLandscapePos> {
  List MenuListProduct = [
    _MenuItem(Icons.point_of_sale, 'POS', 'product'),
    _MenuItem(Icons.description, 'ORDER', 'purchase'),
    _MenuItem(Icons.request_quote, 'รับเงินทอน', 'pos'),
    _MenuItem(Icons.person_outline, 'ส่งยอดขาย', 'member'),
    _MenuItem(Icons.work_outline, 'พิมพ์สำเนาใบเสร็จ', 'product'),
    _MenuItem(Icons.description, 'ยกเลิกใบเสร็จ', 'purchase'),
    _MenuItem(Icons.point_of_sale, 'คืนสินค้า', 'pos'),
    _MenuItem(Icons.person_outline, 'พิมพ์ใบกำกับภาษี(แบบเต็ม)', 'member'),
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
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  // height: size.height * 0.7,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: MenuListProduct.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: size.width / (size.height / 0.7),
                      crossAxisCount: 4,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
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
            ),
          ],
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
