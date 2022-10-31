import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thai7merchant/bloc/color/color_bloc.dart';
import 'package:thai7merchant/global.dart' as global;
import 'package:thai7merchant/model/language_model.dart';
import 'package:thai7merchant/model/color.dart';
import 'package:split_view/split_view.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:invert_colors/invert_colors.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:translator/translator.dart';

class ColorScreen extends StatefulWidget {
  const ColorScreen({Key? key}) : super(key: key);

  @override
  State<ColorScreen> createState() => ColorScreenState();
}

class ColorScreenState extends State<ColorScreen>
    with SingleTickerProviderStateMixin {
  final translator = GoogleTranslator();
  late TabController tabController;
  ScrollController editScrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode(skipTraversal: true);
  List<LanguageModel> languageList = <LanguageModel>[];
  List<TextEditingController> fieldTextController = [];
  List<FocusNode> fieldFocusNodes = [];
  int focusNodeIndex = 0;
  List<ColorModel> colorListDatas = [];
  List<String> colorGuidListChecked = [];
  List<LanguageDataModel> names = [];
  ScrollController listScrollController = ScrollController();
  List<GlobalKey> listKeys = [];
  int loaDataPerPage = 40;
  String searchText = "";
  String selectGuid = "";
  bool isChange = false;
  bool isSaveAllow = false;
  late ColorState blocColorState;
  String headerEdit = "";
  late MediaQueryData queryData;
  int currentListIndex = -1;
  GlobalKey headerKey = GlobalKey();
  bool isKeyUp = false;
  bool isKeyDown = false;
  bool showCheckBox = false;
  bool isEditMode = false;
  Color colorSelected = Colors.white;
  String colorSelectedHex = "";
  Color publicColorSelected = Colors.white;
  String publicColorSelectedCode = "";
  String publicColorSelectedHex = "";

  @override
  void initState() {
    global.loadConfig();
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(() {
      setState(() {});
    });
    for (int i = 0; i < global.config.languages.length; i++) {
      if (global.config.languages[i].use) {
        languageList.add(global.config.languages[i]);
      }
    }
    // เรียงลำดับ Focus
    // Focus รหัส
    FocusNode focusNode = FocusNode();
    focusNode.addListener(() {
      focusNodeIndex = 0;
    });
    fieldFocusNodes.add(focusNode);
    fieldTextController.add(TextEditingController());
    for (int i = 0; i < languageList.length; i++) {
      fieldTextController.add(TextEditingController());
      FocusNode focusNode = FocusNode();
      focusNode.addListener(() {
        focusNodeIndex = i;
      });
      fieldFocusNodes.add(focusNode);
    }
    listScrollController.addListener(onScrollList);
    loadDataList("");
    super.initState();
  }

  void loadDataList(String search) {
    context.read<ColorBloc>().add(ColorLoadList(
        offset: (colorListDatas.isEmpty) ? 0 : colorListDatas.length,
        limit: loaDataPerPage,
        search: search));
  }

  void onScrollList() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      loadDataList(searchText);
    }
  }

  @override
  void dispose() {
    listScrollController.dispose();
    tabController.dispose();
    editScrollController.dispose();
    searchController.dispose();
    for (int i = 0; i < fieldTextController.length; i++) {
      fieldTextController[i].dispose();
    }
    for (int i = 0; i < fieldFocusNodes.length; i++) {
      fieldFocusNodes[i].dispose();
    }

    super.dispose();
  }

  void clearEditData() {
    for (int i = 0; i < fieldTextController.length; i++) {
      fieldTextController[i].clear();
    }
    isChange = false;
    focusNodeIndex = 0;
    fieldFocusNodes[focusNodeIndex].requestFocus();
    setState(() {
      publicColorSelectedCode = "white";
      publicColorSelected = Colors.white;
      publicColorSelectedCode = "#ffffff";
    });
  }

  void discardData({required Function callBack}) {
    if (isEditMode && isChange) {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('มีการแก้ไขข้อมูล'),
                content: const Text('ต้องการออกจากหน้าจอนี้ ใช่หรือไม่'),
                actions: <Widget>[
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('ไม่')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        Navigator.pop(context);
                        callBack();
                      },
                      child: const Text('ใช่')),
                ],
              ));
    } else {
      callBack();
    }
  }

  void getData(String guid) {
    headerEdit = "แสดง";
    isEditMode = false;
    context.read<ColorBloc>().add(ColorGet(guid: guid));
  }

  Widget listScreen({bool mobileScreen = false}) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('สีสินค้า'),
        leading: IconButton(
          focusNode: FocusNode(skipTraversal: true),
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            discardData(callBack: () {
              Navigator.pop(context);
              isEditMode = false;
            });
          },
        ),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () {
                  discardData(callBack: () {
                    setState(() {
                      if (showCheckBox) {
                        showCheckBox = false;
                        colorGuidListChecked.clear();
                      } else {
                        showCheckBox = true;
                        global.showSnackBar(
                            context,
                            const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            "เลือกรายการที่ต้องการลบ",
                            Colors.blue);
                      }
                    });
                  });
                },
                icon: const Icon(Icons.check_box),
              )),
          if (colorGuidListChecked.isNotEmpty)
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: IconButton(
                  focusNode: FocusNode(skipTraversal: true),
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('ต้องการลบข้อมูลหรือไม่'),
                        actions: <Widget>[
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () => Navigator.pop(context),
                              child: const Text('ไม่')),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                              onPressed: () {
                                Navigator.pop(context);
                                context.read<ColorBloc>().add(ColorDeleteMany(
                                    guid: colorGuidListChecked));
                              },
                              child: const Text('ลบ')),
                        ],
                      ),
                    );
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.delete,
                  ),
                )),
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () {
                  discardData(callBack: () {
                    setState(() {
                      isEditMode = true;
                      selectGuid = "";
                      showCheckBox = false;
                      isChange = false;
                      clearEditData();
                      headerEdit = "เพิ่ม";
                      isSaveAllow = true;
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        tabController.animateTo(1);
                        fieldFocusNodes[0].requestFocus();
                      });
                    });
                  });
                },
                icon: const Icon(
                  Icons.add,
                ),
              )),
        ],
      ),
      body: Focus(
          focusNode: FocusNode(skipTraversal: true, canRequestFocus: true),
          onKey: (node, event) {
            if (kIsWeb) {
              if (event is RawKeyDownEvent) {
                if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                  isKeyDown = false;
                  int index = colorListDatas.indexOf(colorListDatas.firstWhere(
                      (element) => element.guidfixed == selectGuid));
                  if (index > 0) {
                    selectGuid = colorListDatas[index - 1].guidfixed;
                    currentListIndex = index + 1;
                    isKeyUp = true;
                    getData(selectGuid);
                  }
                }
                if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                  isKeyUp = false;
                  int index = colorListDatas.indexOf(colorListDatas.firstWhere(
                      (element) => element.guidfixed == selectGuid));
                  selectGuid = colorListDatas[index + 1].guidfixed;
                  currentListIndex = index + 1;
                  isKeyDown = true;
                  getData(selectGuid);
                }
              }
            }
            return KeyEventResult.ignored;
          },
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(5),
                  color: Colors.blue,
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                              onFieldSubmitted: (value) {
                                searchFocusNode.requestFocus();
                              },
                              autofocus: true,
                              focusNode: searchFocusNode,
                              controller: searchController,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.only(top: 10, bottom: 10),
                                border: InputBorder.none,
                                hintText: (kIsWeb) ? "ค้นหา (F2)" : "ค้นหา",
                              ))))),
              Container(
                  key: headerKey,
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  decoration: const BoxDecoration(
                      color: Colors.lightBlueAccent,
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.grey),
                      )),
                  child: Row(children: [
                    const Expanded(
                        flex: 5,
                        child: Text("รหัสสี",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    const Expanded(
                        flex: 10,
                        child: Text(
                          "ชื่อสี",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                    const Expanded(
                        flex: 4,
                        child: Text(
                          "สีที่เลือก",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                    if (showCheckBox)
                      const Expanded(
                          flex: 1,
                          child:
                              Icon(Icons.check, color: Colors.black, size: 12))
                  ])),
              Expanded(
                  child: SingleChildScrollView(
                      controller: listScrollController,
                      child: Column(
                          children: colorListDatas
                              .map((value) => listObject(value, showCheckBox))
                              .toList())))
            ],
          )),
    );
  }

  void switchToEdit(ColorModel value) {
    setState(() {
      selectGuid = value.guidfixed;
      getData(selectGuid);
      headerEdit = "แก้ไข";
      isSaveAllow = true;
      isEditMode = true;
    });
  }

  Widget listObject(ColorModel value, bool showCheckBox) {
    bool isCheck = false;
    for (int i = 0; i < colorGuidListChecked.length; i++) {
      if (colorGuidListChecked[i] == value.guidfixed) {
        isCheck = true;
        break;
      }
    }
    listKeys.add(GlobalKey());
    return GestureDetector(
        onTap: () {
          if (showCheckBox == true) {
            setState(() {
              selectGuid = value.guidfixed;
              if (isCheck == true) {
                colorGuidListChecked.remove(value.guidfixed);
              } else {
                colorGuidListChecked.add(value.guidfixed);
              }
              global.showSnackBar(
                  context,
                  const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  "เลือกแล้ว ${colorGuidListChecked.length} รายการ",
                  Colors.blue);
            });
          } else {
            setState(() {
              discardData(callBack: () {
                isSaveAllow = false;
                isEditMode = false;
                selectGuid = value.guidfixed;
                getData(selectGuid);
                searchFocusNode.requestFocus();
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  tabController.animateTo(1);
                });
              });
            });
          }
        },
        onDoubleTap: () {
          if (showCheckBox == false) {
            switchToEdit(value);
          }
        },
        child: Container(
            key: listKeys.last,
            decoration: BoxDecoration(
              color: (selectGuid == value.guidfixed)
                  ? Colors.cyan[100]
                  : Colors.white,
              border: const Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey),
              ),
            ),
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  flex: 5,
                  child: Text(value.code,
                      maxLines: 2, overflow: TextOverflow.ellipsis)),
              Expanded(
                  flex: 10,
                  child: Text(
                    global.packName(value.names),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
              Expanded(
                  flex: 4,
                  child: Row(children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: global.colorFromHex(value.colorselecthex),
                          border: Border.all(color: Colors.black)),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: global.colorFromHex(value.colorsystemhex),
                          border: Border.all(color: Colors.black)),
                    )
                  ])),
              if (showCheckBox)
                Expanded(
                    flex: 1,
                    child: (isCheck)
                        ? const Icon(Icons.check, size: 12)
                        : Container())
            ])));
  }

  List<LanguageDataModel> packLanguage() {
    List<LanguageDataModel> names = [];
    for (int i = 0; i < languageList.length; i++) {
      if (languageList[i].code.trim().isNotEmpty &&
          fieldTextController[i + 1].text.trim().isNotEmpty) {
        names.add(LanguageDataModel(
          code: languageList[i].code,
          name: fieldTextController[i + 1].text,
          isauto: false,
        ));
      }
    }
    return names;
  }

  void saveOrUpdateData() {
    showCheckBox = false;
    if (selectGuid.trim().isEmpty) {
      ColorModel colorModel = ColorModel(
        guidfixed: "",
        code: fieldTextController[0].text,
        names: packLanguage(),
        colorselect: colorSelected.value.toString(),
        colorselecthex: colorSelectedHex,
        colorsystem: publicColorSelectedCode,
        colorsystemhex: publicColorSelectedHex,
      );
      context.read<ColorBloc>().add(ColorSave(colorModel: colorModel));
    } else {
      updateData(selectGuid);
    }
  }

  void updateData(String guid) {
    var names = packLanguage();
    showCheckBox = false;
    ColorModel colorModel = ColorModel(
      guidfixed: guid,
      code: fieldTextController[0].text,
      names: names,
      colorselect: colorSelected.value.toString(),
      colorsystem: publicColorSelectedCode,
      colorselecthex: colorSelectedHex,
      colorsystemhex: publicColorSelectedHex,
    );
    context
        .read<ColorBloc>()
        .add(ColorUpdate(guid: guid, colorModel: colorModel));
  }

  void getDataToEditScreen(ColorModel color) {
    isChange = false;
    selectGuid = color.guidfixed;
    fieldTextController[0].text = color.code;
    for (int i = 0; i < languageList.length; i++) {
      fieldTextController[i + 1].text = "";
    }
    for (int i = 0; i < languageList.length; i++) {
      for (int j = 0; j < color.names.length; j++) {
        if (languageList[i].code == color.names[j].code) {
          fieldTextController[i + 1].text = color.names[j].name;
        }
      }
    }
    publicColorSelectedCode = color.colorsystem;
    publicColorSelected =
        global.colorFromHex(color.colorsystemhex.replaceAll("#", ""));
    colorSelected = Color(int.parse(color.colorselect));
  }

  void findFocusNext(int index) {
    focusNodeIndex = index + 1;
    if (focusNodeIndex > fieldFocusNodes.length - 1) {
      focusNodeIndex = 0;
    }
    fieldFocusNodes[focusNodeIndex].requestFocus();
    fieldTextController[focusNodeIndex].selection = TextSelection.fromPosition(
        TextPosition(offset: fieldTextController[focusNodeIndex].text.length));
  }

  Widget editScreen({mobileScreen}) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            backgroundColor: (isEditMode) ? Colors.green : Colors.blue,
            automaticallyImplyLeading: false,
            leading: mobileScreen
                ? IconButton(
                    focusNode: FocusNode(skipTraversal: true),
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () async {
                      showCheckBox = false;
                      discardData(callBack: () {
                        isEditMode = false;
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          tabController.animateTo(0);
                        });
                      });
                    })
                : null,
            title: Text("$headerEditสีสินค้า"),
            actions: <Widget>[
              if (selectGuid.isNotEmpty)
                Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: IconButton(
                      focusNode: FocusNode(skipTraversal: true),
                      onPressed: () {
                        showCheckBox = false;
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('ต้องการลบข้อมูลหรือไม่'),
                            actions: <Widget>[
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('ไม่')),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context
                                        .read<ColorBloc>()
                                        .add(ColorDelete(guid: selectGuid));
                                  },
                                  child: const Text('ลบ')),
                            ],
                          ),
                        );
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.delete,
                      ),
                    )),
              if (isEditMode && global.systemLanguage.length > 1)
                Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: IconButton(
                      focusNode: FocusNode(skipTraversal: true),
                      onPressed: () async {
                        for (int i = 2; i <= languageList.length; i++) {
                          try {
                            var translation = await translator.translate(
                                fieldTextController[1].text,
                                to: languageList[i - 1].codeTranslator);
                            fieldTextController[i].text = translation.text;
                          } catch (_) {}
                        }
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.translate,
                      ),
                    )),
              if (isSaveAllow == false && selectGuid.trim().isNotEmpty)
                Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: IconButton(
                      focusNode: FocusNode(skipTraversal: true),
                      onPressed: () {
                        showCheckBox = false;
                        switchToEdit(colorListDatas[colorListDatas.indexOf(
                            colorListDatas.firstWhere((element) =>
                                element.guidfixed == selectGuid))]);
                      },
                      icon: const Icon(
                        Icons.edit,
                      ),
                    )),
              if (isSaveAllow == true)
                Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: IconButton(
                      focusNode: FocusNode(skipTraversal: true),
                      onPressed: () => saveOrUpdateData(),
                      icon: const Icon(
                        Icons.save,
                      ),
                    ))
            ]),
        body: Focus(
            focusNode: FocusNode(skipTraversal: true),
            onKey: (node, event) {
              if (kIsWeb) {
                if (event is RawKeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.f2) {
                    searchFocusNode.requestFocus();
                  }
                  if (event.logicalKey == LogicalKeyboardKey.f10) {
                    saveOrUpdateData();
                  }
                }
              }
              return KeyEventResult.ignored;
            },
            child: SingleChildScrollView(
                controller: editScrollController,
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Column(children: [
                      Form(
                          child: TextFormField(
                              readOnly: !isEditMode,
                              onFieldSubmitted: (value) {
                                findFocusNext(0);
                              },
                              textInputAction: TextInputAction.next,
                              focusNode: fieldFocusNodes[0],
                              textAlign: TextAlign.left,
                              controller: fieldTextController[0],
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp('[a-z A-Z 0-9]'))
                              ],
                              onChanged: (value) {
                                isChange = true;
                                fieldTextController[0].value = TextEditingValue(
                                    text: value.toUpperCase(),
                                    selection:
                                        fieldTextController[0].selection);
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "รหัสสี",
                              ))),
                      const SizedBox(height: 10),
                      for (int i = 0; i < languageList.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TextFormField(
                            readOnly: !isEditMode,
                            onChanged: (value) {
                              isChange = true;
                            },
                            onFieldSubmitted: (value) {
                              findFocusNext(focusNodeIndex + 1);
                            },
                            textInputAction: TextInputAction.next,
                            focusNode: fieldFocusNodes[i + 1],
                            textAlign: TextAlign.left,
                            controller: fieldTextController[i + 1],
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText:
                                  "ชื่อสีสินค้า (${languageList[i].name})",
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
                                          padding:
                                              const EdgeInsets.only(left: 10),
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
                                onColorChanged: (Color colorValue) {
                                  setState(() {
                                    colorSelected = colorValue;
                                    colorSelectedHex = colorValue.value
                                        .toRadixString(16)
                                        .toString();
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
                                padding: const EdgeInsets.all(10),
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
                                for (int i = 0;
                                    i < global.publicColors.length;
                                    i++)
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
                                        publicColorSelectedCode =
                                            global.publicColors[i].code;
                                        publicColorSelectedHex =
                                            global.publicColors[i].color;
                                        publicColorSelected =
                                            global.colorFromHex(
                                                publicColorSelectedHex);
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
                                                    child: (publicColorSelectedCode ==
                                                            global
                                                                .publicColors[i]
                                                                .code)
                                                        ? InvertColors(
                                                            child:
                                                                DecoratedIcon(
                                                            icon: Icon(
                                                                Icons.check,
                                                                size: 32,
                                                                color: global
                                                                    .colorFromHex(global
                                                                        .publicColors[
                                                                            i]
                                                                        .color)),
                                                            decoration:
                                                                const IconDecoration(
                                                                    border: IconBorder(
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
                                                      global
                                                          .publicColors[i].name,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        foreground: Paint()
                                                          ..style =
                                                              PaintingStyle
                                                                  .stroke
                                                          ..strokeWidth = 4
                                                          ..color = Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      global
                                                          .publicColors[i].name,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        )),
                                  )
                              ],
                            )
                          ])),
                      const SizedBox(height: 10),
                      if (isSaveAllow)
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                                focusNode: FocusNode(skipTraversal: true),
                                onPressed: () {
                                  saveOrUpdateData();
                                },
                                icon: const Icon(Icons.save),
                                label: const Text(
                                    (kIsWeb) ? "บันทึก (F10)" : "บันทึก")))
                    ])))));
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    listKeys.clear();
    if (showCheckBox == false) {
      colorGuidListChecked.clear();
    }
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(builder: (context, constraints) {
          return BlocListener<ColorBloc, ColorState>(
              listener: (context, state) {
                blocColorState = state;
                // Load
                if (state is ColorLoadSuccess) {
                  setState(() {
                    if (state.colors.isNotEmpty) {
                      colorListDatas.addAll(state.colors);
                    }
                  });
                }
                // Save
                if (state is ColorSaveSuccess) {
                  setState(() {
                    global.showSnackBar(
                        context,
                        const Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        "บันทึกสำเร็จ",
                        Colors.blue);
                    clearEditData();
                    colorListDatas.clear();
                    loadDataList(searchText);
                  });
                }
                if (state is ColorSaveFailed) {
                  setState(() {
                    global.showSnackBar(
                        context,
                        const Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        "บันทึกไม่สำเร็จ : ${state.message}",
                        Colors.red);
                  });
                }
                // Update
                if (state is ColorUpdateSuccess) {
                  setState(() {
                    global.showSnackBar(
                        context,
                        const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        "แก้ไขสำเร็จ",
                        Colors.blue);
                    clearEditData();
                    colorListDatas.clear();
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      tabController.animateTo(0);
                    });
                    loadDataList(searchText);
                    isSaveAllow = false;
                    getData(selectGuid);
                  });
                }
                if (state is ColorUpdateFailed) {
                  setState(() {
                    global.showSnackBar(
                        context,
                        const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        "แก้ไขไม่สำเร็จ : ${state.message}",
                        Colors.red);
                  });
                }
                // Delete
                if (state is ColorDeleteSuccess) {
                  setState(() {
                    global.showSnackBar(
                        context,
                        const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        "ลบสำเร็จ",
                        Colors.blue);
                    colorListDatas.clear();
                    clearEditData();
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      tabController.animateTo(0);
                    });
                    loadDataList(searchText);
                  });
                }
                // Delete Many
                if (state is ColorDeleteManySuccess) {
                  setState(() {
                    global.showSnackBar(
                        context,
                        const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        "ลบสำเร็จ",
                        Colors.blue);
                    colorListDatas.clear();
                    clearEditData();
                    loadDataList(searchText);
                    showCheckBox = false;
                  });
                }
                // Get
                if (state is ColorGetSuccess) {
                  setState(() {
                    getDataToEditScreen(state.color);
                    if (isEditMode) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        tabController.animateTo(1);
                      });
                      setState(() {
                        findFocusNext(0);
                      });
                    }
                  });
                  if (currentListIndex >= 0) {
                    RenderBox? boxHeader = headerKey.currentContext
                        ?.findRenderObject() as RenderBox?;
                    Offset? positionheader =
                        boxHeader?.localToGlobal(Offset.zero);
                    RenderBox? box = listKeys[currentListIndex]
                        .currentContext
                        ?.findRenderObject() as RenderBox?;
                    Offset? position = box?.localToGlobal(Offset.zero);
                    if (position != null &&
                        positionheader != null &&
                        boxHeader != null &&
                        box != null) {
                      // Scroll Up
                      if (isKeyUp &&
                          position.dy <=
                              (positionheader.dy +
                                  (boxHeader.size.height +
                                      (box.size.height * 2)))) {
                        setState(() {
                          listScrollController.animateTo(
                              listScrollController.offset -
                                  (boxHeader.size.height + box.size.height),
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.ease);
                          isKeyUp = false;
                        });
                      }
                      // Scroll Down
                      if (isKeyDown &&
                          position.dy > (queryData.size.height - 100)) {
                        setState(() {
                          listScrollController.animateTo(
                              listScrollController.offset +
                                  (position.dy - (queryData.size.height - 100)),
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeOut);
                          isKeyDown = false;
                        });
                      }
                    }
                  }
                }
              },
              child: (constraints.maxWidth > 800)
                  ? SplitView(
                      gripSize: 8,
                      gripColor: Colors.blue.shade400,
                      gripColorActive: Colors.blue,
                      viewMode: SplitViewMode.Horizontal,
                      indicator: const SplitIndicator(
                          viewMode: SplitViewMode.Horizontal),
                      activeIndicator: const SplitIndicator(
                        viewMode: SplitViewMode.Horizontal,
                        isActive: true,
                      ),
                      children: [
                        listScreen(mobileScreen: false),
                        editScreen(mobileScreen: false),
                      ],
                    )
                  : TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: tabController,
                      children: [
                        listScreen(mobileScreen: true),
                        editScreen(mobileScreen: true)
                      ],
                    ));
        }));
  }
}
