import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:thai7merchant/global.dart' as global;
import 'package:input_history_text_field/input_history_text_field.dart';

class UnitScreen extends StatefulWidget {
  const UnitScreen({Key? key}) : super(key: key);

  @override
  State<UnitScreen> createState() => UnitScreenState();
}

class UnitScreenState extends State<UnitScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  FocusNode codeFocusNode = FocusNode();
  ScrollController editScrollController = ScrollController();
  TextEditingController codeController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<TextEditingController> nameController = [];
  List<String> fieldName = [];
  List<FocusNode> nameFocusNode = [];

  @override
  void initState() {
    global.loadConfig();
    tabController = TabController(vsync: this, length: 2);
    for (int i = 0; i < global.config.languages.length; i++) {
      nameController.add(TextEditingController());
      nameFocusNode.add(FocusNode());
      fieldName.add("name${i + 1}");
    }
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    codeFocusNode.dispose();
    editScrollController.dispose();
    codeController.dispose();
    searchController.dispose();
    for (int i = 0; i < nameController.length; i++) {
      nameController[i].dispose();
      nameFocusNode[i].dispose();
    }
    super.dispose();
  }

  Widget listScreen() {
    return Scaffold(
        appBar: AppBar(
          title: const Text('หน่วยนับสินค้า'),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: const Icon(
                    Icons.delete,
                    size: 26.0,
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    tabController.index = 1;
                    codeFocusNode.requestFocus();
                  },
                  child: const Icon(
                    Icons.add,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(10),
                child: InputHistoryTextField(
                    textEditingController: searchController,
                    historyKey: "unit",
                    listStyle: ListStyle.Badge,
                    showHistoryIcon: false,
                    backgroundColor: Colors.lightBlue,
                    textColor: Colors.white,
                    deleteIconColor: Colors.white,
                    decoration: const InputDecoration(
                      hintText: 'ค้นหา',
                    ))),
            Expanded(
              child: Container(),
            )
          ],
        ));
  }

  void saveData() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 1),
        content: (Row(
          children: const [
            Icon(
              Icons.save,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text("บันทึกสำเร็จ")
          ],
        ))));
  }

  Widget editScreen({showBackButton = true}) {
    return Scaffold(
        appBar: AppBar(
            leading: showBackButton
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      tabController.index = 0;
                    },
                  )
                : null,
            title: const Text('หน่วยนับสินค้า'),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      saveData();
                    },
                    child: const Icon(
                      Icons.save,
                      size: 26.0,
                    ),
                  ))
            ]),
        body: SingleChildScrollView(
            controller: editScrollController,
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  TextField(
                      focusNode: codeFocusNode,
                      textAlign: TextAlign.left,
                      controller: codeController,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp('[a-z A-Z 0-9]'))
                      ],
                      onChanged: (value) {
                        codeController.value = TextEditingValue(
                            text: value.toUpperCase(),
                            selection: codeController.selection);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "รหัสหน่วยนับ",
                      )),
                  const SizedBox(height: 10),
                  for (int i = 0; i < global.config.languages.length; i++)
                    if (global.config.languages[i].use)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextField(
                          focusNode: nameFocusNode[i],
                          textAlign: TextAlign.left,
                          controller: nameController[i],
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText:
                                "ชื่อหน่วยนับสินค้า (${global.config.languages[i].name})",
                          ),
                        ),
                      ),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                          onPressed: () {
                            saveData();
                          },
                          icon: const Icon(Icons.save),
                          label: const Text("บันทึก")))
                ]))));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          body: (constraints.maxWidth > 800)
              ? Row(
                  children: [
                    Expanded(child: listScreen()),
                    Container(width: 1.5, color: Colors.black),
                    Expanded(child: editScreen(showBackButton: false)),
                  ],
                )
              : TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [listScreen(), editScreen()],
                ));
    });
  }
}
