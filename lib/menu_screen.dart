import 'package:flutter/material.dart';
import 'package:thai7merchant/model/product_barcode_struct.dart';
import 'package:thai7merchant/screens/config/category_screen.dart';
import 'package:thai7merchant/screens/config/color_screen.dart';
import 'package:thai7merchant/screens/config/pattern_screen.dart';
import 'package:thai7merchant/screens/config/product_barcode_screen.dart';
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
      TabController(length: 2, vsync: this, initialIndex: seupTabCurrentIndex);
  late List<Widget> setupProductMenuList;
  late List<Widget> setupCustomerMenuList;

  void buildMenu() {
    setupCustomerMenuList = [
      menu(
          title: global.language("customer_group"),
          description:
              "เพื่อใช้ในการแยกกลุ่มลูกค้าเพื่อใช้ในการกำหนดส่วนลด และข้อมูลอื่นๆ",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UnitScreen()),
            );
          }),
      menu(
          title: global.language("customer"),
          description: "รายละเอียดลูกค้ารายตัว",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UnitScreen()),
            );
          })
    ];

    setupProductMenuList = [
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
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoryScreen()),
            );
          }),
      menu(
          title: global.language("color"),
          description:
              "กำหนดสีที่มีในธุรกิจ เช่น ธุรกิจเสื้อผ้าที่มีหลายเฉดสี สามารถแยกได้หลายภาษา เพื่อใช้ในการพิมพ์เอกสารให้ลูกค้านักท่องเที่ยว",
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ColorScreen()),
            );
          }),
      menu(
          title: "Barcode",
          description: "Barcode สินค้า",
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
      required Function callback}) {
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
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(title,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))),
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
    return Container(
        color: Colors.blue,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Column(
              children: [
                Container(
                    color: Colors.blue,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Center(
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(headTitle,
                                    style: const TextStyle(
                                        fontSize: 30, color: Colors.white)))),
                        Positioned(
                            top: 10.0,
                            right: 10.0,
                            child: IconButton(
                              icon: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.green, width: 2),
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
                                  SizedBox(
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
                                              itemCount:
                                                  setupProductMenuList.length,
                                              itemBuilder: (context, index) {
                                                return setupProductMenuList[
                                                    index];
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
                                              itemCount:
                                                  setupCustomerMenuList.length,
                                              itemBuilder: (context, index) {
                                                return setupCustomerMenuList[
                                                    index];
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
                backgroundColor: Colors.blue,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white.withOpacity(.50),
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.bold),
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
                ])));
  }
}
