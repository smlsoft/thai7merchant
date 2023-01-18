import 'package:flutter/material.dart';
import 'package:thai7merchant/screens/config/category_screen.dart';
import 'package:thai7merchant/screens/config/color_screen.dart';
import 'package:thai7merchant/screens/config/company_screen.dart';
import 'package:thai7merchant/screens/config/customer_group_screen.dart';
import 'package:thai7merchant/screens/config/customer_screen.dart';
import 'package:thai7merchant/screens/config/kitchen_screen.dart';
import 'package:thai7merchant/screens/config/pattern_screen.dart';
import 'package:thai7merchant/screens/config/printer_screen.dart';
import 'package:thai7merchant/screens/config/product_barcode_screen.dart';
import 'package:thai7merchant/screens/config/product_screen.dart';
import 'package:thai7merchant/screens/config/unit_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:thai7merchant/global.dart' as global;
import 'package:thai7merchant/select_language_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  int mainTabCurrentIndex = 2;
  int seupTabCurrentIndex = 0;
  String headTitle = "";
  late TabController mainTabController =
      TabController(length: 3, vsync: this, initialIndex: mainTabCurrentIndex);
  late TabController setupTabController =
      TabController(length: 3, vsync: this, initialIndex: seupTabCurrentIndex);
  late List<Widget> productMenuList;
  late List<Widget> customerMenuList;
  late List<Widget> configMenuList;

  void buildMenu() {
    configMenuList = [
      menu(
          title: global.language("config"),
          description: "กำหนดค่าของระบบ",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CompanyScreen()),
            );
          }),
      menu(
          title: global.language("workday"),
          description: "วันทำการ",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CustomerGroupScreen()),
            );
          }),
      menu(
          title: global.language("วันหยุดพิเศษ"),
          description: "กำหนดค่าของระบบ",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CustomerGroupScreen()),
            );
          }),
      menu(
          title: global.language("printer"),
          description:
              "กำหนดเครื่องพิมพ์ สำหรับใช้พิมพ์ใบเสร็จ ใบสั่งทำอาหารห้องครัว ใบสั่งบาร์น้ำ",
          icon: "menu_printer.jpg",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrinterScreen()),
            );
          }),
      menu(
          title: global.language("table"),
          description: "กำหนดโซน และโต๊ะ",
          icon: "menu_printer.jpg",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrinterScreen()),
            );
          }),
      menu(
          title: global.language("kitchen"),
          description:
              "กำหนดห้องครัว กำหนดเครื่องพิมพ์ที่เกี่ยวของ โซนโต๊ะที่เกี่ยวข้อง และกำหนดรายการอาหารที่เกี่ยวข้อง",
          icon: "menu_kitchen.jpeg",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const KitchenScreen()),
            );
          }),
      menu(
          title: global.language("chef"),
          icon: "menu_chef.webp",
          description:
              "ผู้ประกอบอาหาร หรือ ผู้ทำเครื่องดื่ม โปรแกรมจะแสดงรายการอาหารที่ต้องทำให้กับผู้ประกอบอาหาร พร้อมจัดคิวการทำอาหาร เพื่อเพิ่มความเร็วในการเริ่มทำอาหาร",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrinterScreen()),
            );
          }),
      menu(
          title: global.language("color"),
          description:
              "กำหนดสีที่มีในธุรกิจ เช่น ธุรกิจเสื้อผ้าที่มีหลายเฉดสี สามารถแยกได้หลายภาษา เพื่อใช้ในการพิมพ์เอกสารให้ลูกค้านักท่องเที่ยว",
          icon: "menu_color.jpg",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ColorScreen()),
            );
          }),
      menu(
          title: global.language("staff"),
          description:
              "กำหนดสีที่มีในธุรกิจ เช่น ธุรกิจเสื้อผ้าที่มีหลายเฉดสี สามารถแยกได้หลายภาษา เพื่อใช้ในการพิมพ์เอกสารให้ลูกค้านักท่องเที่ยว",
          icon: "menu_color.jpg",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ColorScreen()),
            );
          }),
      menu(
          title: global.language("promotion"),
          description:
              "กำหนดสีที่มีในธุรกิจ เช่น ธุรกิจเสื้อผ้าที่มีหลายเฉดสี สามารถแยกได้หลายภาษา เพื่อใช้ในการพิมพ์เอกสารให้ลูกค้านักท่องเที่ยว",
          icon: "menu_color.jpg",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ColorScreen()),
            );
          }),
    ];

    customerMenuList = [
      menu(
          title: global.language("customer_group"),
          description:
              "เพื่อใช้ในการแยกกลุ่มลูกค้าเพื่อใช้ในการกำหนดส่วนลด และข้อมูลอื่นๆ",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CustomerGroupScreen()),
            );
          }),
      menu(
          title: global.language("customer"),
          description: "รายละเอียดลูกค้ารายตัว",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CustomerScreen()),
            );
          })
    ];

    productMenuList = [
      menu(
          title: global.language("product_unit"),
          description:
              "กำหนดหน่วยนับสินค้าเป็นรหัส เพิ่มความสะดวกในการเรียกใช้ และแยกหลายภาษา โดยใช้รหัสเดียว เช่น ชิ้น, กิโลกรัม, ลิตร, แพ็ค, แผ่น, ชุด, ชิ้น,​โหล ,ขวด, กล่อง24, หีบ, เมตร",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UnitScreen()),
            );
          }),
      menu(
          title: global.language("product_group"),
          description:
              "ช่วยในการจัดเรียงสินค้าตามกลุ่ม หรือหมวดหมู่สินค้า ใช้สำหรับค้นหาสินค้าด้วยกลุ่ม หรือหมวดหมู่สินค้า และใช้สำหรับรายงานสินค้าตามกลุ่ม หรือหมวดหมู่สินค้า รวมไปจนถึงใช้กับระบบสั่งสินค้าออนไลน์ สามารถแยกได้หลายภาษา เพื่อใช้สั่งสินค้าออนไลน์ เช่น ภาษาไทย, ภาษาอังกฤษ,​ ภาษาจีน",
          icon: "menu_product_group.jpeg",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoryScreen()),
            );
          }),
      menu(
          title: "สินค้า",
          description: "สินค้า, วัตถุดิบ, อุปกรณ์, ส่วนประกอบ และอื่นๆ",
          icon: "menu_product.jpeg",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductScreen()),
            );
          }),
      menu(
          title: "Barcode",
          description: "Barcode สินค้าเพื่อใช้สำหรับสแกนสินค้า",
          icon: "menu_barcode.jpg",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ProductBarcodeScreen()),
            );
          }),
      menu(
          title: "รูปแบบสินค้า",
          description:
              "เพื่อเพิ่มส่วนขยายให้กับสินค้า เช่น สี,​ขนาด,รูปแบบ สำหรับธุรกิจขายเสื้อผ้า,​ขายอาหาร,ขายอุปกรณ์เครื่องใช้,ขายเฟอร์นิเจอร์ สามารถใช้ได้ทั้งระบบ ตั้งแต่ซื้อ จนถึงขาย และสามารถใช้ได้กับระบบขายสินค้าออนไลน์ได้",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PatternScreen()),
            );
          }),
      menu(
          title: "เมนู",
          description: "กำหนดเมนู สำหรับหน้าจอขาย หน้าจอ Order",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PatternScreen()),
            );
          }),
      menu(
          title: "โครงสร้างสินค้า",
          description:
              "จัดการสร้างโครงสร้างการสั่งสินค้า โดยใช้สี และรูปแบบสินค้ามาประกอบ เพื่อใช้เป็นต้นแบบเพื่อให้สินค้าแต่ละตัว นำไปใช้งาน เช่น เสื้อผ้ามีหลายสี หลายขนาด หลายลาย",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PatternScreen()),
            );
          }),
    ];
  }

  @override
  void initState() {
    super.initState();
    mainTabController.addListener(() {
      mainTabCurrentIndex = mainTabController.index;
      setHeader();
    });
    buildMenu();
  }

  @override
  void dispose() {
    mainTabController.dispose();
    setupTabController.dispose();
    super.dispose();
  }

  void setHeader() {
    setState(() {
      switch (mainTabCurrentIndex) {
        case 0:
          headTitle = global.language("หน้าหลัก");
          break;
        case 1:
          headTitle = global.language("สินค้า");
          break;
        case 2:
          headTitle = global.language("การตั้งค่า");
          break;
      }
    });
  }

  Widget menu(
      {required String title,
      required String description,
      required Function callback,
      String icon = ""}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
          //you can set more BoxShadow() here
        ],
      ),
      child: Material(
          borderRadius: BorderRadius.circular(10.0),
          child: InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () {
                callback();
              },
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(children: [
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(title,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)))),
                        (icon != "")
                            ? Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                    //you can set more BoxShadow() here
                                  ],
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/$icon"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container())
                            : Container()
                      ]),
                      const SizedBox(height: 10),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(description))
                    ],
                  )))),
    );
  }

  @override
  Widget build(BuildContext context) {
    setHeader();
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Container(
                color: global.theme.appBarColor,
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                width: double.infinity,
                child: Stack(
                  children: [
                    Center(
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(headTitle,
                                style: TextStyle(
                                    fontSize: 30,
                                    color: global.theme.headTitleColor)))),
                    Positioned(
                        top: 10.0,
                        right: 10.0,
                        child: IconButton(
                          icon: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                              ),
                              child: Image.asset(
                                  'assets/flags/${global.userLanguage}.png')),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectLanguageScreen()),
                            );
                          },
                        ))
                  ],
                )),
            Expanded(
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.blue.shade100,
                              Colors.blue.shade300
                            ])),
                    child: Column(
                      children: [
                        Expanded(
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: mainTabController,
                            children: [
                              Container(),
                              Container(),
                              Container(
                                color: global.theme.backgroundColor,
                                width: double.infinity,
                                child: Column(children: [
                                  TabBar(
                                    controller: setupTabController,
                                    labelColor: Colors.black,
                                    labelStyle: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    tabs: const [
                                      Tab(
                                          text: "สินค้า",
                                          icon: Icon(Icons.inventory)),
                                      Tab(
                                          text: "ลูกค้า",
                                          icon: Icon(Icons.people)),
                                      Tab(
                                          text: "กำหนดค่า",
                                          icon: Icon(Icons.toggle_on_sharp)),
                                    ],
                                  ),
                                  Expanded(
                                      child: TabBarView(
                                          controller: setupTabController,
                                          children: [
                                        MasonryGridView.count(
                                          padding: const EdgeInsets.all(10),
                                          crossAxisCount:
                                              (MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      300)
                                                  .round(),
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          itemCount: productMenuList.length,
                                          itemBuilder: (context, index) {
                                            return productMenuList[index];
                                          },
                                        ),
                                        MasonryGridView.count(
                                          padding: const EdgeInsets.all(10),
                                          crossAxisCount:
                                              (MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      300)
                                                  .round(),
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          itemCount: customerMenuList.length,
                                          itemBuilder: (context, index) {
                                            return customerMenuList[index];
                                          },
                                        ),
                                        MasonryGridView.count(
                                          padding: const EdgeInsets.all(10),
                                          crossAxisCount:
                                              (MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      300)
                                                  .round(),
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          itemCount: configMenuList.length,
                                          itemBuilder: (context, index) {
                                            return configMenuList[index];
                                          },
                                        ),
                                      ]))
                                ]),
                              ),
                            ],
                          ),
                        )
                      ],
                    ))),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0.0,
            currentIndex: mainTabCurrentIndex,
            backgroundColor: global.theme.appBarColor,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(.50),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.normal),
            onTap: (value) {
              setState(() {
                mainTabCurrentIndex = value;
                mainTabController.animateTo(value);
              });
            },
            items: const [
              BottomNavigationBarItem(
                label: "หน้าหลัก",
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                label: "ค่าเริ่มต้น",
                icon: Icon(Icons.favorite),
              ),
              BottomNavigationBarItem(
                label: "ตั้งค่า",
                icon: Icon(Icons.settings),
              ),
            ]));
  }
}
