// ignore_for_file: unnecessary_const, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ReceiveList extends StatefulWidget {
  const ReceiveList({Key? key}) : super(key: key);

  @override
  State<ReceiveList> createState() => _ReceiveListState();
}

class _ReceiveListState extends State<ReceiveList> {
  TextEditingController txtSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(241, 241, 255, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          color: const Color.fromRGBO(121, 130, 142, 1),
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(builder: (_) => MenuListLandscape()),
            //     (route) => false);
          },
        ),
        title: const Text(
          'รายการรับจ่ายสินค้า',
          style: const TextStyle(color: Color.fromRGBO(121, 130, 142, 1)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: <Widget>[
          _searchInput(),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _docList(),
                _detailBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailBox() {
    return Container(
      width: (MediaQuery.of(context).size.width / 100) * 35,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.only(right: 8),
              child: Card(
                elevation: 5.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  margin: const EdgeInsets.all(20.0),
                  child: Column(children: <Widget>[
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "เลขที่เอกสาร",
                            ),
                          ),
                          Expanded(flex: 1, child: Text("RE-202202021001")),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "วันที่",
                            ),
                          ),
                          Expanded(flex: 1, child: Text("10/04/2565")),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "ประเภทรายการ",
                            ),
                          ),
                          Expanded(flex: 1, child: Text("รับสินค้า")),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "สมาชิก",
                            ),
                          ),
                          Expanded(flex: 1, child: Text("สิธิพัช สามวง")),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "พนักงาน",
                            ),
                          ),
                          Expanded(flex: 1, child: Text("เบอรรี่ ดูดี")),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.only(top: 10, right: 8),
              child: Card(
                elevation: 10.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Column(children: <Widget>[
                      _tableDetailHeader(),
                      _tableDetailDetail(),
                    ]),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.only(top: 10, right: 8),
              child: Card(
                elevation: 10.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Text(
                          "รวมมูลค่า",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: 15),
                        child: Text(
                          "1,800บาท",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox(),
          )
        ],
      ),
    );
  }

  _tableDetailHeader() {
    return Table(
      border: const TableBorder(
          bottom: const BorderSide(
              width: 1, color: Colors.grey, style: BorderStyle.solid)),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            Container(
              height: 45,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "รายการ",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Container(
                child: const Text(
                  "จำนวน",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "มูลค่า",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _tableDetailDetail() {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "บะหมี่กึ่งสำเร็จรูป",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "700บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "ซอสถั่วเหลือง",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "600บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "ผงซักฟอก",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "500บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "บะหมี่กึ่งสำเร็จรูป",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "700บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "ซอสถั่วเหลือง",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "600บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "ผงซักฟอก",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "500บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "บะหมี่กึ่งสำเร็จรูป",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "700บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "ซอสถั่วเหลือง",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "600บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "ผงซักฟอก",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "500บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "บะหมี่กึ่งสำเร็จรูป",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "700บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "ซอสถั่วเหลือง",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "600บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "ผงซักฟอก",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "500บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "บะหมี่กึ่งสำเร็จรูป",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "700บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "ซอสถั่วเหลือง",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "600บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "ผงซักฟอก",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "500บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "บะหมี่กึ่งสำเร็จรูป",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "700บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "ซอสถั่วเหลือง",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "600บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "ผงซักฟอก",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "500บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "บะหมี่กึ่งสำเร็จรูป",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "700บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "ซอสถั่วเหลือง",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "600บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 35,
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "ผงซักฟอก",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "10",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                "500บาท",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _docList() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Card(
            elevation: 5.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: _tableHeader(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _tableDetail(),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _tableHeader() {
    return Table(
      border: const TableBorder(
          bottom: const BorderSide(
              width: 1, color: Colors.grey, style: BorderStyle.solid)),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      defaultColumnWidth: const FlexColumnWidth(),
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            Container(
              height: 45,
              child: Center(
                child: Container(
                  child: const Text(
                    "เลขที่เอกสาร",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                child: const Text(
                  "วันที่",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Container(
                child: const Text(
                  "ชื่อสมาชิก",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Container(
                child: const Text(
                  "พนักงาน",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Container(
                child: const Text(
                  "ประเภท",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Container(
                child: const Text(
                  "รวมทั้งหมด",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _tableDetail() {
    return Table(
      border: const TableBorder(
          horizontalInside: const BorderSide(
              width: 1, color: Colors.grey, style: BorderStyle.solid)),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      defaultColumnWidth: const FlexColumnWidth(),
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021001",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "10/04/2565 21:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สิธิพัช สามวง",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "เบอรรี่ ดูดี",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "รับสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Container(
              child: const Text(
                "1,800.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Container(
                  child: const Text(
                    "RE-202202021002",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                "15/04/2565 12:47",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "วงเหลา คำปลา",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "สมใจ เนื่องแป้น",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: const Text(
                "จ่ายสินค้า",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Container(
              child: const Text(
                "900.00 บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _searchInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
      child: TextField(
        onSubmitted: (text) {},
        controller: txtSearch,
        style: const TextStyle(color: Colors.black, fontSize: 16.0),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(8.0),
            ),
          ),
          prefixIcon: IconButton(
            icon: const Icon(Icons.search),
            color: Colors.lightBlue.shade500,
            onPressed: () {},
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: "ค้นหา",
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
