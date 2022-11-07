import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thai7merchant/bloc/product_barcode/product_barcode_bloc.dart';
import 'package:thai7merchant/global.dart' as global;
import 'package:thai7merchant/model/global_model.dart';
import 'package:thai7merchant/model/language_model.dart';
import 'package:thai7merchant/model/price_model.dart';
import 'package:thai7merchant/model/product_barcode_struct.dart';
import 'package:split_view/split_view.dart';
import 'package:thai7merchant/model/product_choice_struct.dart';
import 'package:thai7merchant/model/product_option_struct.dart';
import 'package:thai7merchant/screen_search/unit_search_screen.dart';
import 'package:translator/translator.dart';

class ProductBarcodeScreen extends StatefulWidget {
  const ProductBarcodeScreen({Key? key}) : super(key: key);

  @override
  State<ProductBarcodeScreen> createState() => ProductBarcodeScreenState();
}

class ProductBarcodeScreenState extends State<ProductBarcodeScreen>
    with SingleTickerProviderStateMixin {
  final translator = GoogleTranslator();
  late TabController tabController;
  ScrollController editScrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode(skipTraversal: true);
  List<LanguageModel> languageList = <LanguageModel>[];
  List<PriceModel> priceList = <PriceModel>[];
  List<FocusNode> fieldFocusNodes = [];
  int focusNodeIndex = 0;
  List<ProductBarcodeModel> listDatas = [];
  List<String> guidListChecked = [];
  List<LanguageDataModel> names = [];
  ScrollController listScrollController = ScrollController();
  List<GlobalKey> listKeys = [];
  int loaDataPerPage = 40;
  String searchText = "";
  String selectGuid = "";
  bool isChange = false;
  bool isSaveAllow = false;
  late ProductBarcodeState blocCurrentState;
  String headerEdit = "";
  late MediaQueryData queryData;
  int currentListIndex = -1;
  GlobalKey headerKey = GlobalKey();
  bool isKeyUp = false;
  bool isKeyDown = false;
  bool showCheckBox = false;
  bool isEditMode = false;
  late ProductBarcodeModel screenData;
  File imageFile = File('');
  Uint8List? imageWeb;
  final ImagePicker _picker = ImagePicker();
  late DropzoneViewController dropZoneController;

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
    for (int i = 0; i < global.config.prices.length; i++) {
      if (global.config.prices[i].isuse) {
        priceList.add(global.config.prices[i]);
      }
    }
    // เรียงลำดับ Focus
    for (int i = 0; i < 100; i++) {
      fieldFocusNodes.add(FocusNode());
    }
    listScrollController.addListener(onScrollList);
    clearEditData();
    loadDataList("");
    super.initState();
  }

  void loadDataList(String search) {
    context.read<ProductBarcodeBloc>().add(ProductBarcodeLoadList(
        offset: (listDatas.isEmpty) ? 0 : listDatas.length,
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
    for (int i = 0; i < fieldFocusNodes.length; i++) {
      fieldFocusNodes[i].dispose();
    }
    super.dispose();
  }

  void clearEditData() {
    List<LanguageDataModel> names = [];
    List<LanguageDataModel> itemunitnames = [];
    for (int k = 0; k < languageList.length; k++) {
      names.add(LanguageDataModel(code: languageList[k].code, name: ""));
      itemunitnames
          .add(LanguageDataModel(code: languageList[k].code, name: ""));
    }
    List<PriceDataModel> prices = [];
    for (int i = 0; i < priceList.length; i++) {
      prices.add(PriceDataModel(
        keynumber: priceList[i].keynumber,
        price: 0,
      ));
    }

    screenData = ProductBarcodeModel(
        barcode: "",
        guidfixed: "",
        categoryguid: "",
        names: names,
        itemcode: "",
        itemunitcode: "",
        itemunitnames: itemunitnames,
        prices: prices,
        imageuri: "",
        options: []);

    isChange = false;
    focusNodeIndex = 0;
    fieldFocusNodes[focusNodeIndex].requestFocus();
  }

  void discardData({required Function callBack}) {
    if (isEditMode && isChange) {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text(global.language('data_editing')),
                content: Text(global.language('leave_this_screen')),
                actions: <Widget>[
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.pop(context),
                      child: Text(global.language('no'))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        Navigator.pop(context);
                        callBack();
                      },
                      child: Text(global.language('yes'))),
                ],
              ));
    } else {
      callBack();
    }
  }

  void getData(String guid) {
    headerEdit = global.language("show");
    isEditMode = false;
    context.read<ProductBarcodeBloc>().add(ProductBarcodeGet(guid: guid));
  }

  Widget listScreen({bool mobileScreen = false}) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(global.language('barcode')),
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
                        guidListChecked.clear();
                      } else {
                        showCheckBox = true;
                        global.showSnackBar(
                            context,
                            const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            global.language("choose_item_delete"),
                            Colors.blue);
                      }
                    });
                  });
                },
                icon: const Icon(Icons.check_box),
              )),
          if (guidListChecked.isNotEmpty)
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: IconButton(
                  focusNode: FocusNode(skipTraversal: true),
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(global.language('confirm_delete')),
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
                                context.read<ProductBarcodeBloc>().add(
                                    ProductBarcodeDeleteMany(
                                        guid: guidListChecked));
                              },
                              child: Text(global.language('delete'))),
                        ],
                      ),
                    );
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.delete,
                  ),
                )),

          /// เพิ่มข้อมูลใหม่
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
                      headerEdit = global.language("append");
                      isSaveAllow = true;
                      if (mobileScreen) {
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          tabController.animateTo(1);
                        });
                      }
                      fieldFocusNodes[0].requestFocus();
                    });
                  });
                },
                icon: const Icon(
                  Icons.add,
                ),
              )),

          /// เพิ่มมูลใหม่จากข้อมูลเดิม (Copy)
          if (selectGuid.isNotEmpty)
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: IconButton(
                  focusNode: FocusNode(skipTraversal: true),
                  onPressed: () {
                    discardData(callBack: () {
                      setState(() {
                        isEditMode = true;
                        showCheckBox = false;
                        isChange = false;
                        isChange = false;
                        headerEdit = global.language("append");
                        isSaveAllow = true;
                        if (mobileScreen) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            tabController.animateTo(1);
                          });
                        }
                        fieldFocusNodes[0].requestFocus();
                      });
                    });
                  },
                  icon: const Icon(
                    Icons.copy_all,
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
                  int index = listDatas.indexOf(listDatas.firstWhere(
                      (element) => element.guidfixed == selectGuid));
                  if (index > 0) {
                    selectGuid = listDatas[index - 1].guidfixed;
                    currentListIndex = index + 1;
                    isKeyUp = true;
                    getData(selectGuid);
                  }
                }
                if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                  isKeyUp = false;
                  int index = listDatas.indexOf(listDatas.firstWhere(
                      (element) => element.guidfixed == selectGuid));
                  selectGuid = listDatas[index + 1].guidfixed;
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
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                border: InputBorder.none,
                                hintText: (kIsWeb)
                                    ? "${global.language('search')} (F2)"
                                    : global.language('search'),
                              ))))),
              Container(
                  key: headerKey,
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 10),
                  decoration: const BoxDecoration(
                      color: Colors.lightBlueAccent,
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.grey),
                      )),
                  child: Row(children: [
                    Expanded(
                        flex: 5,
                        child: Text(global.language("barcode"),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 10,
                        child: Text(
                          global.language("product_name"),
                          style: const TextStyle(
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
                          children: listDatas
                              .map((value) => listObject(value, showCheckBox))
                              .toList())))
            ],
          )),
    );
  }

  void switchToEdit(ProductBarcodeModel value) {
    setState(() {
      selectGuid = value.guidfixed;
      getData(selectGuid);
      headerEdit = global.language("edit");
      isSaveAllow = true;
      isEditMode = true;
    });
  }

  Widget listObject(ProductBarcodeModel value, bool showCheckBox) {
    bool isCheck = false;
    for (int i = 0; i < guidListChecked.length; i++) {
      if (guidListChecked[i] == value.guidfixed) {
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
                guidListChecked.remove(value.guidfixed);
              } else {
                guidListChecked.add(value.guidfixed);
              }
              global.showSnackBar(
                  context,
                  const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  "${global.language("chosen")} ${guidListChecked.length} ${global.language("list")}",
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
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  flex: 5,
                  child: Text(value.barcode,
                      maxLines: 2, overflow: TextOverflow.ellipsis)),
              Expanded(
                  flex: 10,
                  child: Text(
                    global.packName(value.names),
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

  void saveOrUpdateData() {
    showCheckBox = false;
    if (selectGuid.trim().isEmpty) {
      if (imageFile.path.isNotEmpty) {
        context.read<ProductBarcodeBloc>().add(ProductBarcodeWithImageSave(
              productBarcodeModel: screenData,
              imageFile: imageFile,
              imageWeb: imageWeb,
            ));
      } else {
        context
            .read<ProductBarcodeBloc>()
            .add(ProductBarcodeSave(productBarcodeModel: screenData));
      }
    } else {
      updateData(selectGuid);
    }
  }

  void updateData(String guid) {
    showCheckBox = false;
    context
        .read<ProductBarcodeBloc>()
        .add(ProductBarcodeUpdate(guid: guid, productBarcodeModel: screenData));
  }

  void findFocusNext(int index) {
    focusNodeIndex = index + 1;
    if (focusNodeIndex > fieldFocusNodes.length - 1) {
      focusNodeIndex = 0;
    }
    fieldFocusNodes[focusNodeIndex].requestFocus();
  }

  Widget editScreen({mobileScreen}) {
    int nodeIndex = 0;
    List<Widget> formWidgets = [];
    formWidgets.add(Container(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        width: double.infinity,
        child: ElevatedButton(
            focusNode: FocusNode(skipTraversal: true),
            onPressed: () {},
            child: Text(global.language("product_group")))));
    formWidgets.add(Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: TextFormField(
            readOnly: !isEditMode,
            onFieldSubmitted: (value) {
              findFocusNext(0);
            },
            textInputAction: TextInputAction.next,
            focusNode: fieldFocusNodes[nodeIndex],
            textAlign: TextAlign.left,
            controller: TextEditingController(text: screenData.barcode),
            textCapitalization: TextCapitalization.characters,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
            ],
            onChanged: (value) {
              isChange = true;
              screenData.barcode = value.toUpperCase();
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: global.language("barcode"),
            ))));
    for (int languageIndex = 0;
        languageIndex < languageList.length;
        languageIndex++) {
      nodeIndex++;
      formWidgets.add(Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: TextFormField(
          readOnly: !isEditMode,
          onChanged: (value) {
            isChange = true;
            int foundLanguage = -1;
            for (int j = 0; j < screenData.names.length; j++) {
              if (screenData.names[j].code ==
                  languageList[languageIndex].code) {
                foundLanguage = j;
                break;
              }
            }
            if (foundLanguage == -1) {
              screenData.names.add(LanguageDataModel(
                  code: languageList[languageIndex].code, name: value));
            } else {
              screenData.names[foundLanguage].name = value;
            }
          },
          onFieldSubmitted: (value) {
            findFocusNext(nodeIndex);
          },
          textInputAction: TextInputAction.next,
          focusNode: fieldFocusNodes[nodeIndex],
          textAlign: TextAlign.left,
          controller:
              TextEditingController(text: screenData.names[languageIndex].name),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText:
                "${global.language("product_name")} (${languageList[languageIndex].name})",
          ),
        ),
      ));
    }
    nodeIndex++;
    formWidgets.add(Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: TextFormField(
            readOnly: !isEditMode,
            onFieldSubmitted: (value) {
              findFocusNext(nodeIndex);
            },
            textInputAction: TextInputAction.next,
            focusNode: fieldFocusNodes[nodeIndex],
            textAlign: TextAlign.left,
            controller: TextEditingController(text: screenData.itemunitcode),
            textCapitalization: TextCapitalization.characters,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
            ],
            onChanged: (value) {
              isChange = true;
              screenData.itemunitcode = value.toUpperCase();
            },
            decoration: InputDecoration(
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UnitSearchScreen()))
                      .then((value) {
                    if (value != null) {
                      setState(() {
                        if (value != null) {
                          SearchReturnValueModel returnValue =
                              value as SearchReturnValueModel;
                          screenData.itemunitcode = returnValue.code;
                          for (int languageFindIndex = 0;
                              languageFindIndex < languageList.length;
                              languageFindIndex++) {
                            if (screenData
                                    .itemunitnames[languageFindIndex].code ==
                                returnValue.names[languageFindIndex].code) {
                              screenData.itemunitnames[languageFindIndex].name =
                                  returnValue.names[languageFindIndex].name;
                            }
                          }
                        }
                      });
                    }
                  });
                },
              ),
              border: const OutlineInputBorder(),
              labelText: global.language("unit_code"),
            ))));
    for (int languageIndex = 0;
        languageIndex < languageList.length;
        languageIndex++) {
      nodeIndex++;
      formWidgets.add(Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: TextFormField(
          readOnly: !isEditMode,
          onChanged: (value) {
            isChange = true;
            int foundLanguage = -1;
            for (int j = 0; j < screenData.itemunitnames.length; j++) {
              if (screenData.names[j].code ==
                  languageList[languageIndex].code) {
                foundLanguage = j;
                break;
              }
            }
            if (foundLanguage == -1) {
              screenData.itemunitnames.add(LanguageDataModel(
                  code: languageList[languageIndex].code, name: value));
            } else {
              screenData.itemunitnames[foundLanguage].name = value;
            }
          },
          onFieldSubmitted: (value) {
            findFocusNext(nodeIndex);
          },
          textInputAction: TextInputAction.next,
          focusNode: fieldFocusNodes[nodeIndex],
          textAlign: TextAlign.left,
          controller: TextEditingController(
              text: screenData.itemunitnames[languageIndex].name),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText:
                "${global.language("unit_name")} (${languageList[languageIndex].name})",
          ),
        ),
      ));
    }
    for (int priceIndex = 0; priceIndex < priceList.length; priceIndex++) {
      nodeIndex++;
      formWidgets.add(Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: TextFormField(
          readOnly: !isEditMode,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            isChange = true;
            int foundPrice = -1;
            for (int j = 0; j < screenData.prices.length; j++) {
              if (screenData.prices[j].keynumber ==
                  priceList[priceIndex].keynumber) {
                foundPrice = j;
                break;
              }
            }
            if (foundPrice == -1) {
              screenData.prices.add(PriceDataModel(
                  keynumber: priceList[priceIndex].keynumber,
                  price: double.tryParse(value)!));
            } else {
              screenData.prices[foundPrice].price = double.tryParse(value)!;
            }
          },
          onFieldSubmitted: (value) {
            findFocusNext(nodeIndex);
          },
          textInputAction: TextInputAction.next,
          focusNode: fieldFocusNodes[nodeIndex],
          textAlign: TextAlign.left,
          controller: TextEditingController(
              text: screenData.prices[priceIndex].price.toString()),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText:
                "${global.language("price")} (${priceList[priceIndex].names[0].name})",
          ),
        ),
      ));
    }
    if (screenData.options.isNotEmpty) {
      for (int optionIndex = 0;
          optionIndex < screenData.options.length;
          optionIndex++) {
        List<Widget> optionList = [];
        optionList.add(Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                        "${global.language("option")} ${optionIndex + 1}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)))),
            if (optionIndex > 0)
              IconButton(
                  onPressed: () {
                    setState(() {
                      screenData.options.insert(optionIndex - 1,
                          screenData.options.removeAt(optionIndex));
                    });
                  },
                  icon: const Icon(Icons.move_up),
                  focusNode: FocusNode(skipTraversal: true),
                  color: Colors.blue,
                  iconSize: 20),
            if (optionIndex < screenData.options.length - 1)
              IconButton(
                  onPressed: () {
                    setState(() {
                      screenData.options.insert(optionIndex + 1,
                          screenData.options.removeAt(optionIndex));
                    });
                  },
                  icon: const Icon(Icons.move_down),
                  color: Colors.red,
                  focusNode: FocusNode(skipTraversal: true),
                  iconSize: 20),
          ],
        ));
        for (int languageIndex = 0;
            languageIndex < languageList.length;
            languageIndex++) {
          nodeIndex++;
          optionList.add(Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
            child: TextFormField(
              readOnly: !isEditMode,
              onChanged: (value) {
                isChange = true;
                int foundLanguage = -1;
                for (int l = 0;
                    l < screenData.options[optionIndex].names.length;
                    l++) {
                  if (screenData.options[optionIndex].names[l].code ==
                      languageList[languageIndex].code) {
                    foundLanguage = l;
                    break;
                  }
                }
                if (foundLanguage == -1) {
                  screenData.options[optionIndex].names.add(LanguageDataModel(
                      code: languageList[languageIndex].code, name: value));
                } else {
                  screenData.options[optionIndex].names[foundLanguage].name =
                      value;
                }
              },
              onFieldSubmitted: (value) {
                findFocusNext(nodeIndex);
              },
              textInputAction: TextInputAction.next,
              focusNode: fieldFocusNodes[nodeIndex],
              textAlign: TextAlign.left,
              controller: TextEditingController(
                  text: screenData
                      .options[optionIndex].names[languageIndex].name),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText:
                    "${global.language("option_name")} (${languageList[languageIndex].name})",
              ),
            ),
          ));
        }
        List<Widget> choiceList = [];
        for (int choiceIndex = 0;
            choiceIndex < screenData.options[optionIndex].choices.length;
            choiceIndex++) {
          List<Widget> choiceRow = [];
          if (choiceList.isNotEmpty) {
            choiceRow.add(const Divider(
              color: Colors.black,
            ));
          }
          choiceRow.add(Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                          "${global.language("choice")} ${choiceIndex + 1}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)))),
              if (choiceIndex > 0)
                IconButton(
                    onPressed: () {
                      setState(() {
                        screenData.options[optionIndex].choices.insert(
                            choiceIndex - 1,
                            screenData.options[optionIndex].choices
                                .removeAt(choiceIndex));
                      });
                    },
                    icon: const Icon(Icons.move_up),
                    focusNode: FocusNode(skipTraversal: true),
                    color: Colors.blue,
                    iconSize: 20),
              if (choiceIndex <
                  screenData.options[optionIndex].choices.length - 1)
                IconButton(
                    onPressed: () {
                      setState(() {
                        screenData.options[optionIndex].choices.insert(
                            choiceIndex + 1,
                            screenData.options[optionIndex].choices
                                .removeAt(choiceIndex));
                      });
                    },
                    icon: const Icon(Icons.move_down),
                    color: Colors.green,
                    focusNode: FocusNode(skipTraversal: true),
                    iconSize: 20),
            ],
          ));
          for (int languageIndex = 0;
              languageIndex < languageList.length;
              languageIndex++) {
            nodeIndex++;
            choiceRow.add(Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
              child: TextFormField(
                readOnly: !isEditMode,
                onChanged: (value) {
                  isChange = true;
                  int foundLanguage = -1;
                  for (int l = 0;
                      l <
                          screenData.options[optionIndex].choices[choiceIndex]
                              .names.length;
                      l++) {
                    if (screenData.options[optionIndex].choices[choiceIndex]
                            .names[l].code ==
                        languageList[languageIndex].code) {
                      foundLanguage = l;
                      break;
                    }
                  }
                  if (foundLanguage == -1) {
                    screenData.options[optionIndex].choices[choiceIndex].names
                        .add(LanguageDataModel(
                            code: languageList[languageIndex].code,
                            name: value));
                  } else {
                    screenData.options[optionIndex].choices[choiceIndex]
                        .names[foundLanguage].name = value;
                  }
                },
                onFieldSubmitted: (value) {
                  findFocusNext(nodeIndex);
                },
                textInputAction: TextInputAction.next,
                focusNode: fieldFocusNodes[nodeIndex],
                textAlign: TextAlign.left,
                controller: TextEditingController(
                    text: screenData.options[optionIndex].choices[choiceIndex]
                        .names[languageIndex].name),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText:
                      "${global.language("choice_name")} (${languageList[languageIndex].name})",
                ),
              ),
            ));
          }
          nodeIndex++;
          choiceRow.add(Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
            child: TextFormField(
              readOnly: !isEditMode,
              onChanged: (value) {
                isChange = true;
                screenData.options[optionIndex].choices[choiceIndex].qty =
                    double.tryParse(value)!;
              },
              onFieldSubmitted: (value) {
                findFocusNext(nodeIndex);
              },
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              focusNode: fieldFocusNodes[nodeIndex],
              textAlign: TextAlign.left,
              controller: TextEditingController(
                  text: screenData.options[optionIndex].choices[choiceIndex].qty
                      .toString()),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: global.language("choice_add_price"),
              ),
            ),
          ));
          choiceRow.add(Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  focusNode: FocusNode(skipTraversal: true),
                  title: Text(global.language("choice_is_stock")),
                  value: screenData
                      .options[optionIndex].choices[choiceIndex].isstock,
                  onChanged: ((value) {
                    setState(() {
                      screenData.options[optionIndex].choices[choiceIndex]
                              .isstock =
                          !screenData.options[optionIndex].choices[choiceIndex]
                              .isstock;
                    });
                  }))));
          if (screenData.options[optionIndex].choices[choiceIndex].isstock) {
            nodeIndex++;
            choiceRow.add(Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                child: TextFormField(
                    readOnly: !isEditMode,
                    onFieldSubmitted: (value) {
                      findFocusNext(nodeIndex);
                    },
                    textInputAction: TextInputAction.next,
                    focusNode: fieldFocusNodes[nodeIndex],
                    textAlign: TextAlign.left,
                    controller: TextEditingController(
                        text: screenData.options[optionIndex]
                            .choices[choiceIndex].refbarcode),
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
                    ],
                    onChanged: (value) {
                      isChange = true;
                      screenData.options[optionIndex].choices[choiceIndex]
                          .refbarcode = value.toUpperCase();
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        focusNode: FocusNode(skipTraversal: true),
                        icon: const Icon(Icons.search),
                        onPressed: () async {},
                      ),
                      border: const OutlineInputBorder(),
                      labelText: global.language("barcode"),
                    ))));
            choiceRow.add(Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                child: TextFormField(
                    focusNode: FocusNode(skipTraversal: true),
                    readOnly: !isEditMode,
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.left,
                    controller: TextEditingController(
                        text: screenData.options[optionIndex]
                            .choices[choiceIndex].refproductcode),
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: global.language("product_code"),
                    ))));
            choiceRow.add(Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                child: TextFormField(
                    focusNode: FocusNode(skipTraversal: true),
                    readOnly: !isEditMode,
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.left,
                    controller: TextEditingController(
                        text: screenData.options[optionIndex]
                            .choices[choiceIndex].refunitcode),
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: global.language("unit_code"),
                    ))));
            nodeIndex++;
            choiceRow.add(Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
              child: TextFormField(
                readOnly: !isEditMode,
                onChanged: (value) {
                  isChange = true;
                  screenData.options[optionIndex].choices[choiceIndex].qty =
                      double.tryParse(value)!;
                },
                onFieldSubmitted: (value) {
                  findFocusNext(nodeIndex);
                },
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: fieldFocusNodes[nodeIndex],
                textAlign: TextAlign.left,
                controller: TextEditingController(
                    text: screenData
                        .options[optionIndex].choices[choiceIndex].qty
                        .toString()),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: global.language("choice_stock_qty"),
                ),
              ),
            ));
          }
          choiceList.add(Column(children: choiceRow));
        }
        if (choiceList.isNotEmpty) {
          optionList.add(Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              width: double.infinity,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.cyan.shade100,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)),
                  width: double.infinity,
                  child: Column(children: choiceList))));
        }
        if (isEditMode) {
          optionList.add(Container(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
              width: double.infinity,
              child: ElevatedButton(
                  focusNode: FocusNode(skipTraversal: true),
                  onPressed: () {
                    setState(() {
                      List<LanguageDataModel> names = [];
                      for (int k = 0; k < languageList.length; k++) {
                        names.add(LanguageDataModel(
                            code: languageList[k].code, name: ""));
                      }
                      screenData.options[optionIndex].choices
                          .add(ProductChoiceModel(
                        guid: "",
                        refbarcode: "",
                        isstock: false,
                        refproductcode: "",
                        refunitcode: "",
                        names: names,
                        qty: 0,
                        price: 0,
                      ));
                    });
                  },
                  child: Text(global.language("add_choice")))));
        }
        formWidgets.add(Container(
          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
          width: double.infinity,
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.cyan.shade300,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5)),
              width: double.infinity,
              child: Column(
                children: optionList,
              )),
        ));
        nodeIndex++;
        optionList.add(Padding(
            padding:
                const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
            child: Row(children: [
              Expanded(
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      readOnly: true,
                      textInputAction: TextInputAction.next,
                      focusNode: FocusNode(skipTraversal: true),
                      textAlign: TextAlign.center,
                      controller: TextEditingController(
                          text: screenData.options[optionIndex].minselect
                              .toString()),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText:
                            "${screenData.options[optionIndex].names[0].name} ${global.language("option_min_select_choice")}",
                        suffixIcon: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  focusNode: FocusNode(skipTraversal: true),
                                  icon: const Icon(Icons.arrow_downward),
                                  onPressed: () {
                                    setState(() {
                                      if (screenData
                                              .options[optionIndex].minselect >
                                          0) {
                                        screenData
                                            .options[optionIndex].minselect--;
                                      }
                                    });
                                  }),
                              IconButton(
                                  focusNode: FocusNode(skipTraversal: true),
                                  icon: const Icon(Icons.arrow_upward),
                                  onPressed: () {
                                    setState(() {
                                      if (screenData
                                              .options[optionIndex].minselect <
                                          screenData.options[optionIndex]
                                              .choices.length) {
                                        screenData
                                            .options[optionIndex].minselect++;
                                      }
                                    });
                                  })
                            ]),
                      ))),
              const SizedBox(width: 5),
              Expanded(
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      readOnly: true,
                      textInputAction: TextInputAction.next,
                      focusNode: FocusNode(skipTraversal: true),
                      textAlign: TextAlign.center,
                      controller: TextEditingController(
                          text: screenData.options[optionIndex].maxselect
                              .toString()),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText:
                            "${screenData.options[optionIndex].names[0].name} ${global.language("option_max_select_choice")}",
                        suffixIcon: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  focusNode: FocusNode(skipTraversal: true),
                                  icon: const Icon(Icons.arrow_downward),
                                  onPressed: () {
                                    setState(() {
                                      if (screenData
                                              .options[optionIndex].maxselect >
                                          0) {
                                        screenData
                                            .options[optionIndex].maxselect--;
                                      }
                                    });
                                  }),
                              IconButton(
                                  focusNode: FocusNode(skipTraversal: true),
                                  icon: const Icon(Icons.arrow_upward),
                                  onPressed: () {
                                    setState(() {
                                      if (screenData
                                              .options[optionIndex].maxselect <
                                          screenData.options[optionIndex]
                                              .choices.length) {
                                        screenData
                                            .options[optionIndex].maxselect++;
                                      }
                                    });
                                  })
                            ]),
                      ))),
            ])));
      }
    }
    if (isEditMode) {
      formWidgets.add(Container(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          width: double.infinity,
          child: ElevatedButton(
              focusNode: FocusNode(skipTraversal: true),
              onPressed: () {
                setState(() {
                  List<LanguageDataModel> names = [];
                  for (int k = 0; k < languageList.length; k++) {
                    names.add(LanguageDataModel(
                        code: languageList[k].code, name: ""));
                  }
                  screenData.options.add(ProductOptionModel(
                      guid: "",
                      minselect: 1,
                      maxselect: 1,
                      names: names,
                      choices: []));
                });
              },
              child: Text(global.language("add_option")))));
      formWidgets.add(Row(
        children: [
          Expanded(
              child: ElevatedButton.icon(
            focusNode: FocusNode(skipTraversal: true),
            onPressed: () async {
              setState(() {
                imageWeb = null;
                imageFile = File('');
              });
            },
            icon: const Icon(
              Icons.delete,
            ),
            label: Text(global.language('delete_picture')),
          )),
          const SizedBox(width: 5),
          Expanded(
              child: ElevatedButton.icon(
            focusNode: FocusNode(skipTraversal: true),
            onPressed: (kIsWeb)
                ? () async {
                    XFile? image = await _picker.pickImage(
                        source: ImageSource.gallery,
                        maxHeight: 480,
                        maxWidth: 640,
                        imageQuality: 60);
                    if (image != null) {
                      var f = await image.readAsBytes();
                      setState(() {
                        imageWeb = f;
                        imageFile = File(image.path);
                      });
                    }
                  }
                : () {
                    setState(() async {
                      final XFile? photo = await _picker.pickImage(
                          source: ImageSource.gallery,
                          maxHeight: 480,
                          maxWidth: 640,
                          imageQuality: 60);
                      if (photo != null) {
                        var f = await photo.readAsBytes();
                        setState(() {
                          imageWeb = f;
                          imageFile = File(photo.path);
                        });
                      }
                    });
                  },
            icon: const Icon(
              Icons.folder,
            ),
            label: Text(global.language("select_picture")),
          )),
          const SizedBox(width: 5),
          if (kIsWeb == false)
            Expanded(
                child: ElevatedButton.icon(
              focusNode: FocusNode(skipTraversal: true),
              onPressed: () async {
                final XFile? photo = await _picker.pickImage(
                    source: ImageSource.camera,
                    maxHeight: 480,
                    maxWidth: 640,
                    imageQuality: 60);
                if (photo != null) {
                  var f = await photo.readAsBytes();
                  setState(() {
                    imageWeb = f;
                    imageFile = File(photo.path);
                  });
                }
              },
              icon: const Icon(
                Icons.camera_alt,
              ),
              label: Text(global.language('take_photo')),
            )),
        ],
      ));
    }
    formWidgets.add(Container(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        width: double.infinity,
        height: 300,
        child: Stack(children: [
          DropzoneView(
            operation: DragOperation.copy,
            cursor: CursorType.grab,
            onCreated: (ctrl) => dropZoneController = ctrl,
            onLoaded: () {},
            onError: (ev) {},
            onHover: () {},
            onLeave: () {},
            onDrop: (ev) async {
              final bytes = await dropZoneController.getFileData(ev);
              setState(() {
                imageWeb = bytes;
              });
            },
            onDropMultiple: (ev) async {},
          ),
          Center(
              child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0, 4),
                    color: Colors.cyan, //edited
                    spreadRadius: 4,
                    blurRadius: 10 //edited
                    )
              ],
              image: (imageWeb != null)
                  ? DecorationImage(
                      image: MemoryImage(imageWeb!), fit: BoxFit.fill)
                  : (screenData.imageuri != '')
                      ? DecorationImage(
                          image: NetworkImage(screenData.imageuri),
                          fit: BoxFit.fill)
                      : const DecorationImage(
                          image: AssetImage('assets/img/noimg.png'),
                          fit: BoxFit.fill),
            ),
            child: const SizedBox(
              width: 500,
              height: 500,
            ),
          )),
        ])));

    if (isSaveAllow) {
      formWidgets.add(Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: ElevatedButton.icon(
              focusNode: FocusNode(skipTraversal: true),
              onPressed: () {
                saveOrUpdateData();
              },
              icon: const Icon(Icons.save),
              label:
                  Text(global.language("save") + ((kIsWeb) ? " (F10)" : "")))));
    }

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
            title: Text(headerEdit + global.language("barcode")),
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
                            title: Text(global.language('delete_confirm')),
                            actions: <Widget>[
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(global.language('no'))),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context.read<ProductBarcodeBloc>().add(
                                        ProductBarcodeDelete(guid: selectGuid));
                                  },
                                  child: Text(global.language('confirm'))),
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
                        for (int indexLanguage = 2;
                            indexLanguage <= languageList.length;
                            indexLanguage++) {
                          try {} catch (_) {}
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
                        switchToEdit(listDatas[listDatas.indexOf(
                            listDatas.firstWhere((element) =>
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
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Form(child: Column(children: formWidgets)),
                ))));
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    listKeys.clear();
    if (showCheckBox == false) {
      guidListChecked.clear();
    }
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(builder: (context, constraints) {
          return BlocListener<ProductBarcodeBloc, ProductBarcodeState>(
              listener: (context, state) {
                blocCurrentState = state;
                // Load
                if (state is ProductBarcodeLoadSuccess) {
                  setState(() {
                    if (state.productbarcodes.isNotEmpty) {
                      listDatas.addAll(state.productbarcodes);
                    }
                  });
                }
                // Save
                if (state is ProductBarcodeSaveSuccess) {
                  setState(() {
                    global.showSnackBar(
                        context,
                        const Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        global.language("save_success"),
                        Colors.blue);
                    clearEditData();
                    listDatas.clear();
                    loadDataList(searchText);
                  });
                }
                if (state is ProductBarcodeSaveFailed) {
                  setState(() {
                    global.showSnackBar(
                        context,
                        const Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        "${global.language("not_success_save")} : ${state.message}",
                        Colors.red);
                  });
                }
                // Update
                if (state is ProductBarcodeUpdateSuccess) {
                  setState(() {
                    global.showSnackBar(
                        context,
                        const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        global.language("edit_success"),
                        Colors.blue);
                    clearEditData();
                    listDatas.clear();
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      tabController.animateTo(0);
                    });
                    loadDataList(searchText);
                    isSaveAllow = false;
                    getData(selectGuid);
                  });
                }
                if (state is ProductBarcodeUpdateFailed) {
                  setState(() {
                    global.showSnackBar(
                        context,
                        const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        "${global.language("not_edit_success")} : ${state.message}",
                        Colors.red);
                  });
                }
                // Delete
                if (state is ProductBarcodeDeleteSuccess) {
                  setState(() {
                    global.showSnackBar(
                        context,
                        const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        global.language("delete_success"),
                        Colors.blue);
                    listDatas.clear();
                    clearEditData();
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      tabController.animateTo(0);
                    });
                    loadDataList(searchText);
                  });
                }
                // Delete Many
                if (state is ProductBarcodeDeleteManySuccess) {
                  setState(() {
                    global.showSnackBar(
                        context,
                        const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        global.language("not_delete_success"),
                        Colors.blue);
                    listDatas.clear();
                    clearEditData();
                    loadDataList(searchText);
                    showCheckBox = false;
                  });
                }
                // Get
                if (state is ProductBarcodeGetSuccess) {
                  setState(() {
                    isChange = false;
                    screenData = state.productbarcode;
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
