import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thai7merchant/bloc/unit/unit_bloc.dart';
import 'package:thai7merchant/global.dart' as global;
import 'package:thai7merchant/model/language_model.dart';
import 'package:thai7merchant/model/unit.dart';
import 'package:split_view/split_view.dart';

class UnitScreen extends StatefulWidget {
  const UnitScreen({Key? key}) : super(key: key);

  @override
  State<UnitScreen> createState() => UnitScreenState();
}

class UnitScreenState extends State<UnitScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  ScrollController editScrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode(skipTraversal: true);
  List<LanguageModel> languageList = <LanguageModel>[];
  List<TextEditingController> fieldTextController = [];
  List<FocusNode> fieldFocusNodes = [];
  int focusNodeIndex = 0;
  List<UnitModel> unitListDatas = [];
  List<String> unitGuidListChecked = [];
  List<LanguageDataModel> names = [];
  ScrollController listScrollController = ScrollController();
  List<GlobalKey> listKeys = [];
  int loaDataPerPage = 40;
  String searchText = "";
  String selectedGuid = "";
  bool isChange = false;
  bool isSaveAllow = false;
  late UnitState blocUnitState;
  String headerEdit = "";
  late MediaQueryData queryData;
  int currentListIndex = -1;
  GlobalKey headerKey = GlobalKey();
  bool isKeyUp = false;
  bool isKeyDown = false;
  bool showCheckBox = false;
  bool isEditMode = false;

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
    context.read<UnitBloc>().add(UnitLoadList(
        offset: (unitListDatas.isEmpty) ? 0 : unitListDatas.length,
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
    context.read<UnitBloc>().add(UnitGet(guid: guid));
  }

  Widget listScreen({bool mobileScreen = false}) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('หน่วยนับสินค้า'),
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
                        unitGuidListChecked.clear();
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
          if (unitGuidListChecked.isNotEmpty)
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
                                context.read<UnitBloc>().add(
                                    UnitDeleteMany(guid: unitGuidListChecked));
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
                      selectedGuid = "";
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
                  int index = unitListDatas.indexOf(unitListDatas.firstWhere(
                      (element) => element.guidfixed == selectedGuid));
                  if (index > 0) {
                    selectedGuid = unitListDatas[index - 1].guidfixed;
                    currentListIndex = index + 1;
                    isKeyUp = true;
                    getData(selectedGuid);
                  }
                }
                if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                  isKeyUp = false;
                  int index = unitListDatas.indexOf(unitListDatas.firstWhere(
                      (element) => element.guidfixed == selectedGuid));
                  selectedGuid = unitListDatas[index + 1].guidfixed;
                  currentListIndex = index + 1;
                  isKeyDown = true;
                  getData(selectedGuid);
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
                        child: Text("รหัสหน่วยนับ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    const Expanded(
                        flex: 10,
                        child: Text(
                          "ชื่อหน่วยนับ",
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
                          children: unitListDatas
                              .map((value) => listObject(value, showCheckBox))
                              .toList())))
            ],
          )),
    );
  }

  void switchToEdit(UnitModel value) {
    setState(() {
      selectedGuid = value.guidfixed;
      getData(selectedGuid);
      headerEdit = "แก้ไข";
      isSaveAllow = true;
      isEditMode = true;
    });
  }

  Widget listObject(UnitModel value, bool showCheckBox) {
    bool isCheck = false;
    for (int i = 0; i < unitGuidListChecked.length; i++) {
      if (unitGuidListChecked[i] == value.guidfixed) {
        isCheck = true;
        break;
      }
    }
    listKeys.add(GlobalKey());
    return GestureDetector(
        onTap: () {
          if (showCheckBox == true) {
            setState(() {
              selectedGuid = value.guidfixed;
              if (isCheck == true) {
                unitGuidListChecked.remove(value.guidfixed);
              } else {
                unitGuidListChecked.add(value.guidfixed);
              }
              global.showSnackBar(
                  context,
                  const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  "เลือกแล้ว ${unitGuidListChecked.length} รายการ",
                  Colors.blue);
            });
          } else {
            setState(() {
              discardData(callBack: () {
                isSaveAllow = false;
                isEditMode = false;
                selectedGuid = value.guidfixed;
                getData(selectedGuid);
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
              color: (selectedGuid == value.guidfixed)
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
                  child: Text(value.unitcode,
                      maxLines: 2, overflow: TextOverflow.ellipsis)),
              Expanded(
                  flex: 10,
                  child: Text(
                    packUnitName(value.names),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
              if (showCheckBox)
                Expanded(
                    flex: 1,
                    child: (isCheck)
                        ? const Icon(Icons.check, size: 12)
                        : Container())
            ])));
  }

  String packUnitName(List<LanguageDataModel> names) {
    String result = "";
    for (int i = 0; i < names.length; i++) {
      result += names[i].name;
      if (i < names.length - 1) {
        result += ",";
      }
    }
    return result;
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
    if (selectedGuid.trim().isEmpty) {
      UnitModel unitModel = UnitModel(
        guidfixed: "",
        unitcode: fieldTextController[0].text,
        names: packLanguage(),
      );
      context.read<UnitBloc>().add(UnitSave(unitModel: unitModel));
    } else {
      updateData(selectedGuid);
    }
  }

  void updateData(String guid) {
    var names = packLanguage();
    showCheckBox = false;
    UnitModel unitModel = UnitModel(
      guidfixed: guid,
      unitcode: fieldTextController[0].text,
      names: names,
    );
    context.read<UnitBloc>().add(UnitUpdate(guid: guid, unitModel: unitModel));
  }

  void getDataToEditScreen(UnitModel unit) {
    isChange = false;
    selectedGuid = unit.guidfixed;
    fieldTextController[0].text = unit.unitcode;
    for (int i = 0; i < languageList.length; i++) {
      fieldTextController[i + 1].text = "";
    }
    for (int i = 0; i < languageList.length; i++) {
      for (int j = 0; j < unit.names.length; j++) {
        if (languageList[i].code == unit.names[j].code) {
          fieldTextController[i + 1].text = unit.names[j].name;
        }
      }
    }
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
            title: Text("$headerEditหน่วยนับสินค้า"),
            actions: <Widget>[
              if (selectedGuid.isNotEmpty)
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
                                        .read<UnitBloc>()
                                        .add(UnitDelete(guid: selectedGuid));
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
              if (isSaveAllow == false && selectedGuid.trim().isNotEmpty)
                Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: IconButton(
                      focusNode: FocusNode(skipTraversal: true),
                      onPressed: () {
                        showCheckBox = false;
                        switchToEdit(unitListDatas[unitListDatas.indexOf(
                            unitListDatas.firstWhere((element) =>
                                element.guidfixed == selectedGuid))]);
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
                                labelText: "รหัสหน่วยนับ",
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
                                  "ชื่อหน่วยนับสินค้า (${languageList[i].name})",
                            ),
                          ),
                        ),
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
      unitGuidListChecked.clear();
    }
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(builder: (context, constraints) {
          return BlocListener<UnitBloc, UnitState>(
              listener: (context, state) {
                blocUnitState = state;
                // Load
                if (state is UnitLoadSuccess) {
                  setState(() {
                    if (state.units.isNotEmpty) {
                      unitListDatas.addAll(state.units);
                    }
                  });
                }
                // Save
                if (state is UnitSaveSuccess) {
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
                    unitListDatas.clear();
                    loadDataList(searchText);
                  });
                }
                if (state is UnitSaveFailed) {
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
                if (state is UnitUpdateSuccess) {
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
                    unitListDatas.clear();
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      tabController.animateTo(0);
                    });
                    loadDataList(searchText);
                    isSaveAllow = false;
                    getData(selectedGuid);
                  });
                }
                if (state is UnitUpdateFailed) {
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
                if (state is UnitDeleteSuccess) {
                  setState(() {
                    global.showSnackBar(
                        context,
                        const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        "ลบสำเร็จ",
                        Colors.blue);
                    unitListDatas.clear();
                    clearEditData();
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      tabController.animateTo(0);
                    });
                    loadDataList(searchText);
                  });
                }
                // Delete Many
                if (state is UnitDeleteManySuccess) {
                  setState(() {
                    global.showSnackBar(
                        context,
                        const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        "ลบสำเร็จ",
                        Colors.blue);
                    unitListDatas.clear();
                    clearEditData();
                    loadDataList(searchText);
                    showCheckBox = false;
                  });
                }
                // Get
                if (state is UnitGetSuccess) {
                  setState(() {
                    getDataToEditScreen(state.unit);
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
                      gripSize: 4,
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
