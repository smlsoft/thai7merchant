import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thai7merchant/global.dart' as global;
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:invert_colors/invert_colors.dart';
import 'package:icon_decoration/icon_decoration.dart';

class ColorScreen extends StatefulWidget {
  const ColorScreen({Key? key}) : super(key: key);

  @override
  State<ColorScreen> createState() => ColorScreenState();
}

class ColorScreenState extends State<ColorScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  FocusNode textCodeFocusNode = FocusNode();
  ScrollController editScrollController = ScrollController();
  TextEditingController codeController = TextEditingController();
  List<TextEditingController> nameController = [];
  List<String> fieldName = [];
  List<FocusNode> nameFocusNode = [];
  Color colorSelected = Colors.white;
  Color publicColorSelected = Colors.white;
  String selectPublicColorCode = "";

  @override
  void initState() {
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
    textCodeFocusNode.dispose();
    editScrollController.dispose();
    codeController.dispose();
    for (int i = 0; i < nameController.length; i++) {
      nameController[i].dispose();
      nameFocusNode[i].dispose();
    }
    super.dispose();
  }

  Widget productUnitListScreen() {
    return Scaffold(
        appBar: AppBar(
          title: const Text('สี'),
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
                    textCodeFocusNode.requestFocus();
                  },
                  child: const Icon(
                    Icons.add,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: Container());
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

  Widget productUnitEditScreen({showBackButton = true}) {
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
            title: const Text('สี'),
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
                      focusNode: textCodeFocusNode,
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
                        labelText: "รหัสสี",
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
                                "ชื่อสี (${global.config.languages[i].name})",
                          ),
                        ),
                      ),
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: colorSelected,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          child: ColorPicker(
                            color: colorSelected,
                            padding: const EdgeInsets.all(0),
                            heading: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(children: [
                                  Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        'เลือกสี (เพื่อแสดงตัวอย่างสีในระบบ)',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      )),
                                  const Spacer(),
                                  IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          colorSelected = Colors.white;
                                        });
                                      })
                                ])),
                            showColorName: true,
                            showColorCode: true,
                            onColorChanged: (Color value) {
                              setState(() {
                                colorSelected = value;
                              });
                            },
                            pickersEnabled: const <ColorPickerType, bool>{
                              ColorPickerType.both: true,
                              ColorPickerType.primary: true,
                              ColorPickerType.accent: true,
                              ColorPickerType.bw: false,
                              ColorPickerType.custom: true,
                              ColorPickerType.wheel: true,
                            },
                          ))),
                  const SizedBox(height: 10),
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: publicColorSelected,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(children: [
                        Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            width: double.infinity,
                            child: const Center(
                                child: Text("จัดเข้ากลุ่มสีในระบบ THAI7"))),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 4.0,
                          runSpacing: 4.0,
                          children: [
                            for (int i = 0; i < global.publicColors.length; i++)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    side: const BorderSide(
                                      width: 1.0,
                                      color: Colors.grey,
                                    ),
                                    backgroundColor: global.colorFromHex(
                                        global.publicColors[i].color),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                onPressed: () {
                                  setState(() {
                                    selectPublicColorCode =
                                        global.publicColors[i].code;
                                    publicColorSelected = global.colorFromHex(
                                        global.publicColors[i].color);
                                  });
                                },
                                child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child: Container(
                                                alignment: Alignment.center,
                                                child: (selectPublicColorCode ==
                                                        global.publicColors[i]
                                                            .code)
                                                    ? InvertColors(
                                                        child: DecoratedIcon(
                                                        icon: Icon(Icons.check,
                                                            size: 32,
                                                            color: global
                                                                .colorFromHex(global
                                                                    .publicColors[
                                                                        i]
                                                                    .color)),
                                                        decoration:
                                                            const IconDecoration(
                                                                border:
                                                                    IconBorder(
                                                                        width:
                                                                            2)),
                                                      ))
                                                    : null)),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Stack(
                                              children: [
                                                Text(
                                                  global.publicColors[i].name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    foreground: Paint()
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeWidth = 4
                                                      ..color = Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                  global.publicColors[i].name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ],
                                    )),
                              )
                          ],
                        ),
                      ])),
                  const SizedBox(height: 10),
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
                    Expanded(child: productUnitListScreen()),
                    Container(width: 1.5, color: Colors.black),
                    Expanded(
                        child: productUnitEditScreen(showBackButton: false)),
                  ],
                )
              : TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [productUnitListScreen(), productUnitEditScreen()],
                ));
    });
  }
}
