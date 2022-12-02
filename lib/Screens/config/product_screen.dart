import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thai7merchant/bloc/product/product_bloc.dart';
import 'package:thai7merchant/global.dart' as global;
import 'package:thai7merchant/model/global_model.dart';
import 'package:thai7merchant/model/price_model.dart';
import 'package:thai7merchant/model/product_struct.dart';
import 'package:split_view/split_view.dart';
import 'package:thai7merchant/screen_search/product_group_search_screen.dart';
import 'package:thai7merchant/screen_search/unit_search_screen.dart';
import 'package:translator/translator.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductScreen>
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
  List<ProductModel> listDatas = [];
  List<String> guidListChecked = [];
  List<LanguageDataModel> names = [];
  ScrollController listScrollController = ScrollController();
  List<GlobalKey> listKeys = [];
  int loaDataPerPage = 40;
  String searchText = "";
  String selectGuid = "";
  bool isChange = false;
  bool isSaveAllow = false;
  late ProductState blocCurrentState;
  String headerEdit = "";
  late MediaQueryData queryData;
  int currentListIndex = -1;
  GlobalKey headerKey = GlobalKey();
  bool isKeyUp = false;
  bool isKeyDown = false;
  bool showCheckBox = false;
  bool isEditMode = false;
  late ProductModel screenData;
  List<File> imageFile = [];
  List<Uint8List> imageWeb = [];
  final ImagePicker imagePicker = ImagePicker();
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
    context.read<ProductBloc>().add(ProductLoadList(
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

  String getLangName(String code) {
    LanguageModel name = languageList.firstWhere(
        (element) => element.code == code,
        orElse: () =>
            LanguageModel(code: '', codeTranslator: '', name: '', use: false));
    return name.name;
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

    screenData = ProductModel(
      guidfixed: "",
      categoryguid: "",
      names: names,
      itemcode: "",
      barcodes: [],
      useserialnumber: false,
      units: [],
      images: [],
      unitcost: "",
      unitstandard: "",
      multiunit: false,
      itemstocktype: 1,
      vattype: 1,
      issumpoint: true,
      itemtype: 0,
      prices: prices,
    );

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
    context.read<ProductBloc>().add(ProductGet(guid: guid));
  }

  Widget listScreen({bool mobileScreen = false}) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(global.language('product')),
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
                                context.read<ProductBloc>().add(
                                    ProductDeleteMany(guid: guidListChecked));
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
                        child: Text(global.language("product_code"),
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

  void switchToEdit(ProductModel value) {
    setState(() {
      selectGuid = value.guidfixed;
      getData(selectGuid);
      headerEdit = global.language("edit");
      isSaveAllow = true;
      isEditMode = true;
    });
  }

  Widget listObject(ProductModel value, bool showCheckBox) {
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
                  child: Text(value.itemcode,
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
      if (imageWeb.isNotEmpty) {
        context.read<ProductBloc>().add(ProductWithImageSave(
              productModel: screenData,
              imageFile: imageFile,
              imageWeb: imageWeb,
            ));
      } else {
        context.read<ProductBloc>().add(ProductSave(productModel: screenData));
      }
    } else {
      updateData(selectGuid);
    }
  }

  void updateData(String guid) {
    showCheckBox = false;
    List<File> imageFileUpdate = [];
    List<Uint8List> imageWebUpdate = [];
    List<ImagesModel> imageUris = [];
    for (int i = 0; i < imageWeb.length; i++) {
      if (imageWeb[i].isNotEmpty || screenData.images[i].uri != '') {
        imageFileUpdate.add(imageFile[i]);
        imageWebUpdate.add(imageWeb[i]);
        imageUris.add(ImagesModel(uri: screenData.images[i].uri, xorder: i));
      }
    }

    if (imageWebUpdate.isNotEmpty) {
      context.read<ProductBloc>().add(ProductWithImageUpdate(
            guid: guid,
            productModel: screenData,
            imageFile: imageFile,
            imagesUri: imageUris,
            imageWeb: imageWeb,
          ));
    } else {
      screenData.images = [];
      context
          .read<ProductBloc>()
          .add(ProductUpdate(guid: guid, productModel: screenData));
    }
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
            controller: TextEditingController(text: screenData.categoryguid),
            textCapitalization: TextCapitalization.characters,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
            ],
            onChanged: (value) {
              isChange = true;
              screenData.categoryguid = value.toUpperCase();
            },
            decoration: InputDecoration(
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ProductSearchScreen())).then((value) {
                    if (value != null) {
                      setState(() {
                        if (value != null) {
                          SearchReturnValueModel returnValue =
                              value as SearchReturnValueModel;
                          screenData.categoryguid = returnValue.code;
                        }
                      });
                    }
                  });
                },
              ),
              border: const OutlineInputBorder(),
              labelText: global.language("product_group"),
            ))));
    nodeIndex++;
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
            controller: TextEditingController(text: screenData.itemcode),
            textCapitalization: TextCapitalization.characters,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
            ],
            onChanged: (value) {
              isChange = true;
              screenData.itemcode = value.toUpperCase();
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: global.language("product_code"),
            ))));
    for (int languageIndex = 0;
        languageIndex < languageList.length;
        languageIndex++) {
      LanguageDataModel name = screenData.names.firstWhere(
          (element) => element.code == languageList[languageIndex].code,
          orElse: () => LanguageDataModel(code: '', name: ''));
      if (name.code == '') {
        screenData.names.add(LanguageDataModel(
            code: languageList[languageIndex].code, name: ''));
      }
      nodeIndex++;
      formWidgets.add(Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: TextFormField(
          readOnly: !isEditMode,
          onChanged: (value) {
            isChange = true;
            screenData.names[languageIndex].name = value;
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
                "${global.language("product_name")} (${getLangName(screenData.names[languageIndex].code)})",
          ),
        ),
      ));
    }
    formWidgets.add(Row(
      children: [
        RadioButton(
          description: global.language("product_is_stock"),
          value: 0,
          groupValue: screenData.itemstocktype,
          onChanged: (value) {
            setState(() {
              screenData.itemstocktype = 0;
            });
          },
        ),
        RadioButton(
          description: global.language("product_is_service"),
          value: 1,
          groupValue: screenData.itemstocktype,
          activeColor: Colors.red,
          onChanged: (value) {
            setState(() {
              screenData.itemstocktype = 1;
            });
          },
        ),
      ],
    ));
    formWidgets.add(Row(
      children: [
        RadioButton(
          description: global.language("product_vat_type_1"),
          value: 1,
          groupValue: screenData.vattype,
          onChanged: (value) {
            setState(() {
              screenData.vattype = 1;
            });
          },
        ),
        RadioButton(
          description: global.language("product_vat_type_2"),
          value: 2,
          groupValue: screenData.vattype,
          activeColor: Colors.red,
          onChanged: (value) {
            setState(() {
              screenData.vattype = 2;
            });
          },
        ),
      ],
    ));
    formWidgets.add(Row(
      children: [
        RadioButton(
          description: global.language("product_use_point_1"),
          value: true,
          groupValue: screenData.issumpoint,
          onChanged: (value) {
            setState(() {
              screenData.issumpoint = true;
            });
          },
        ),
        RadioButton(
          description: global.language("product_use_point_2"),
          value: false,
          groupValue: screenData.issumpoint,
          activeColor: Colors.red,
          onChanged: (value) {
            setState(() {
              screenData.issumpoint = false;
            });
          },
        ),
      ],
    ));
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
            controller: TextEditingController(text: screenData.unitcost),
            textCapitalization: TextCapitalization.characters,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
            ],
            onChanged: (value) {
              isChange = true;
              screenData.unitcost = value.toUpperCase();
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
                          screenData.unitcost = returnValue.code;
                        }
                      });
                    }
                  });
                },
              ),
              border: const OutlineInputBorder(),
              labelText: global.language("product_unit_cost"),
            ))));
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
            controller: TextEditingController(text: screenData.unitstandard),
            textCapitalization: TextCapitalization.characters,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
            ],
            onChanged: (value) {
              isChange = true;
              screenData.unitstandard = value.toUpperCase();
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
                          screenData.unitstandard = returnValue.code;
                        }
                      });
                    }
                  });
                },
              ),
              border: const OutlineInputBorder(),
              labelText: global.language("product_unit_standard"),
            ))));
    formWidgets.add(Row(
      children: [
        RadioButton(
          description: global.language("product_single_unit"),
          value: false,
          groupValue: screenData.multiunit,
          onChanged: (value) {
            setState(() {
              screenData.multiunit = false;
            });
          },
        ),
        RadioButton(
          description: global.language("product_multi_unit"),
          value: true,
          groupValue: screenData.multiunit,
          activeColor: Colors.red,
          onChanged: (value) {
            setState(() {
              screenData.multiunit = true;
              if (screenData.units.isEmpty) {
                screenData.units.add(ProductUnitModel(
                  xorder: 0,
                  unitcode: screenData.unitstandard,
                  unitname: "",
                  divider: 1,
                  stand: 1,
                  stockcount: true,
                ));
              }
            });
          },
        ),
      ],
    ));
    if (screenData.multiunit) {
      List<Widget> multiUnitWidgets = [];

      List<List<FocusNode>> fieldFocusNodesUnits = [];
      for (int i = 0; i < 20; i++) {
        List<FocusNode> children = [];
        for (int i = 0; i < 5; i++) {
          children.add(FocusNode());
        }
        fieldFocusNodesUnits.add(children);
      }
      for (int i = 0; i < screenData.units.length; i++) {
        multiUnitWidgets.add(Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              children: [
                Row(children: [
                  Expanded(
                      flex: 5,
                      child: TextFormField(
                          readOnly: !isEditMode,
                          onChanged: (value) {
                            isChange = true;
                            screenData.units[i].unitcode = value;
                          },
                          onFieldSubmitted: (value) {
                            fieldFocusNodesUnits[i][1].requestFocus();
                          },
                          focusNode: fieldFocusNodesUnits[i][0],
                          textAlign: TextAlign.left,
                          controller: TextEditingController(
                              text: screenData.units[i].unitcode),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: global.language("product_unit_code"),
                            suffixIcon: IconButton(
                              focusNode: FocusNode(skipTraversal: true),
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const UnitSearchScreen()))
                                    .then((value) {
                                  if (value != null) {
                                    setState(() {
                                      if (value != null) {
                                        SearchReturnValueModel returnValue =
                                            value as SearchReturnValueModel;
                                        screenData.units[i].unitcode =
                                            returnValue.code;

                                        screenData.units[i].unitname =
                                            global.packName(returnValue.names);
                                      }
                                    });
                                  }
                                });
                              },
                            ),
                          ))),
                  Expanded(
                      child: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        screenData.units.removeAt(i);
                      });
                    },
                  )),
                  if (i > 0)
                    Expanded(
                        child: IconButton(
                      icon: const Icon(Icons.move_up),
                      onPressed: () {
                        setState(() {
                          screenData.units.removeAt(i);
                        });
                      },
                    )),
                  if (i < screenData.units.length - 1)
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.move_down),
                        onPressed: () {
                          setState(() {
                            screenData.units.removeAt(i);
                          });
                        },
                      ),
                    )
                ]),
                TextFormField(
                  readOnly: true,
                  textAlign: TextAlign.left,
                  controller:
                      TextEditingController(text: screenData.units[i].unitname),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: global.language("product_unit_name"),
                  ),
                ),
                Row(children: [
                  Expanded(
                      flex: 1,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        readOnly: !isEditMode,
                        onChanged: (value) {
                          isChange = true;
                          screenData.units[i].stand = double.tryParse(value)!;
                        },
                        onFieldSubmitted: (value) {
                          fieldFocusNodesUnits[i][2].requestFocus();
                        },
                        textInputAction: TextInputAction.next,
                        focusNode: fieldFocusNodesUnits[i][1],
                        textAlign: TextAlign.left,
                        controller: TextEditingController(
                            text: screenData.units[i].stand.toString()),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: global.language("product_unit_stand"),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        readOnly: !isEditMode,
                        onChanged: (value) {
                          isChange = true;
                          screenData.units[i].divider = double.tryParse(value)!;
                        },
                        onFieldSubmitted: (value) {
                          if ((i + 1) < screenData.units.length) {
                            fieldFocusNodesUnits[i + 1][0].requestFocus();
                          } else {
                            fieldFocusNodesUnits[0][0].requestFocus();
                          }
                        },
                        textInputAction: TextInputAction.next,
                        focusNode: fieldFocusNodesUnits[i][2],
                        textAlign: TextAlign.left,
                        controller: TextEditingController(
                            text: screenData.units[i].divider.toString()),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: global.language("product_unit_divider"),
                        ),
                      )),
                ]),
                Row(children: [
                  Checkbox(
                      value: screenData.units[i].stockcount,
                      onChanged: (value) {
                        setState(() {
                          screenData.units[i].stockcount = value!;
                        });
                      }),
                  Text(global.language("product_unit_stock_count"))
                ]),
              ],
            )));
      }
      if (isEditMode) {
        multiUnitWidgets.add(Container(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            width: double.infinity,
            child: ElevatedButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () {
                  setState(() {
                    screenData.units.add(ProductUnitModel(
                      xorder: 0,
                      unitcode: "",
                      unitname: "",
                      divider: 0,
                      stand: 0,
                      stockcount: true,
                    ));
                  });
                },
                child: Text(global.language("product_unit_add")))));
      }
      formWidgets.add(Container(
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          width: double.infinity,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: multiUnitWidgets,
          )));
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

    for (int imageIndex = 0;
        imageIndex < screenData.images.length;
        imageIndex++) {
      formWidgets.add(Row(children: [
        (isEditMode)
            ? Expanded(
                child: ElevatedButton.icon(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () async {
                  setState(() {
                    screenData.images.removeAt(imageIndex);
                    imageWeb.removeAt(imageIndex);
                    imageFile.removeAt(imageIndex);
                  });
                },
                icon: const Icon(
                  Icons.delete,
                ),
                label: Text(global.language('delete_picture')),
              ))
            : Container(),
        const SizedBox(width: 5),
        (isEditMode)
            ? Expanded(
                child: ElevatedButton.icon(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: (kIsWeb)
                    ? () async {
                        XFile? image = await imagePicker.pickImage(
                            source: ImageSource.gallery,
                            maxHeight: 480,
                            maxWidth: 640,
                            imageQuality: 60);
                        if (image != null) {
                          var f = await image.readAsBytes();
                          setState(() {
                            imageWeb[imageIndex] = f;
                            imageFile[imageIndex] = File(image.path);
                          });
                        }
                      }
                    : () async {
                        final XFile? photo = await imagePicker.pickImage(
                            source: ImageSource.gallery,
                            maxHeight: 480,
                            maxWidth: 640,
                            imageQuality: 60);
                        if (photo != null) {
                          imageWeb[imageIndex] = await photo.readAsBytes();
                          imageFile[imageIndex] = File(photo.path);
                          setState(() {});
                        }
                      },
                icon: const Icon(
                  Icons.folder,
                ),
                label: Text(global.language("select_picture")),
              ))
            : Container(),
        const SizedBox(width: 5),
        if (kIsWeb == false)
          Expanded(
              child: ElevatedButton.icon(
            focusNode: FocusNode(skipTraversal: true),
            onPressed: () async {
              final XFile? photo = await imagePicker.pickImage(
                  source: ImageSource.camera,
                  maxHeight: 480,
                  maxWidth: 640,
                  imageQuality: 60);
              if (photo != null) {
                var f = await photo.readAsBytes();
                setState(() {
                  imageWeb[imageIndex] = f;
                  imageFile[imageIndex] = File(photo.path);
                });
              }
            },
            icon: const Icon(
              Icons.camera_alt,
            ),
            label: Text(global.language('take_photo')),
          )),
      ]));

      formWidgets.add(Container(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          width: double.infinity,
          height: 300,
          child: Stack(children: [
            if (kIsWeb)
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
                    imageWeb[imageIndex] = bytes;
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
                image: (imageWeb[imageIndex].isNotEmpty)
                    ? DecorationImage(
                        image: MemoryImage(imageWeb[imageIndex]),
                        fit: BoxFit.fill)
                    : (screenData.images[imageIndex].uri != '')
                        ? DecorationImage(
                            image:
                                NetworkImage(screenData.images[imageIndex].uri),
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
    }
    formWidgets.add((isEditMode)
        ? Container(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            width: double.infinity,
            child: ElevatedButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () {
                  setState(() {
                    screenData.images.add(ImagesModel(uri: '', xorder: 0));
                    imageWeb.add(Uint8List(0));
                    imageFile.add(File(''));
                  });
                },
                child: Text(global.language("product_image_add"))))
        : Container());

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
            title: Text(headerEdit + global.language("product")),
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
                                    context
                                        .read<ProductBloc>()
                                        .add(ProductDelete(guid: selectGuid));
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
          return BlocListener<ProductBloc, ProductState>(
              listener: (context, state) {
                blocCurrentState = state;
                // Load
                if (state is ProductLoadSuccess) {
                  setState(() {
                    if (state.products.isNotEmpty) {
                      listDatas.addAll(state.products);
                    }
                  });
                }
                // Save
                if (state is ProductSaveSuccess) {
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
                if (state is ProductSaveFailed) {
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
                if (state is ProductUpdateSuccess) {
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
                if (state is ProductUpdateFailed) {
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
                if (state is ProductDeleteSuccess) {
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
                if (state is ProductDeleteManySuccess) {
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
                if (state is ProductGetSuccess) {
                  setState(() {
                    isChange = false;

                    screenData = state.product;
                    imageWeb = [];
                    imageFile = [];

                    for (int i = 0; i < state.product.images.length; i++) {
                      imageWeb.add(Uint8List(0));
                      imageFile.add(File(''));
                    }
                    print(screenData);
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
