import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remove_background/crop_widget.dart';
import 'package:thai7merchant/bloc/customer/customer_bloc.dart';
import 'package:thai7merchant/global.dart' as global;
import 'package:thai7merchant/model/language_model.dart';
import 'package:thai7merchant/model/customer.dart';
import 'package:split_view/split_view.dart';
import 'package:translator/translator.dart';
import 'package:email_validator/email_validator.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  State<CustomerScreen> createState() => CustomerScreenState();
}

class CustomerScreenState extends State<CustomerScreen>
    with SingleTickerProviderStateMixin {
  final translator = GoogleTranslator();
  late TabController tabController;
  ScrollController editScrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode(skipTraversal: true);
  List<LanguageModel> languageList = <LanguageModel>[];
  List<FocusNode> fieldFocusNodes = [];
  int focusNodeIndex = 0;
  List<CustomerModel> listDatas = [];
  List<String> guidListChecked = [];
  List<LanguageDataModel> names = [];
  ScrollController listScrollController = ScrollController();
  List<GlobalKey> listKeys = [];
  int loaDataPerPage = 40;
  String searchText = "";
  String selectGuid = "";
  bool isChange = false;
  bool isSaveAllow = false;
  late CustomerState blocCustomerState;
  String headerEdit = "";
  late MediaQueryData queryData;
  int currentListIndex = -1;
  GlobalKey headerKey = GlobalKey();
  bool isKeyUp = false;
  bool isKeyDown = false;
  bool showCheckBox = false;
  bool isEditMode = false;
  late CustomerModel screenData;
  List<Uint8List> imageWeb = [];
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
    // เรียงลำดับ Focus
    // Focus รหัส
    for (var i = 0; i < 100; i++) {
      fieldFocusNodes.add(FocusNode());
    }
    clearEditData();
    listScrollController.addListener(onScrollList);
    loadDataList("");
    super.initState();
  }

  void loadDataList(String search) {
    context.read<CustomerBloc>().add(CustomerLoadList(
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
    for (var i = 0; i < 100; i++) {
      fieldFocusNodes[i].dispose();
    }

    super.dispose();
  }

  void clearEditData() {
    List<LanguageDataModel> names = [];
    List<LanguageDataModel> addressNames = [];
    for (int k = 0; k < languageList.length; k++) {
      names.add(LanguageDataModel(code: languageList[k].code, name: ""));
      addressNames.add(LanguageDataModel(code: languageList[k].code, name: ""));
    }

    screenData = CustomerModel(
      guidfixed: "",
      code: "",
      names: names,
      personaltype: 1,
      addressforbilling: CustomerAddressModel(
        address: ["", "", ""],
        countryCode: "",
        provincecode: "",
        districtcode: "",
        subDistrictcode: "",
        zipcode: "",
        latitude: 0,
        longitude: 0,
        contactnames: [],
        phoneprimary: "",
        phonesecondary: "",
      ),
      addressforshipping: [],
      imageuris: [],
      taxid: "",
      email: "",
    );
    isChange = false;
    focusNodeIndex = 0;
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
    context.read<CustomerBloc>().add(CustomerGet(guid: guid));
  }

  Widget listScreen({bool mobileScreen = false}) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(global.language('customer')),
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
                              child: Text(global.language('no'))),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                              onPressed: () {
                                Navigator.pop(context);
                                context.read<CustomerBloc>().add(
                                    CustomerDeleteMany(guid: guidListChecked));
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
                      left: 10, right: 10, top: 5, bottom: 5),
                  decoration: const BoxDecoration(
                      color: Colors.lightBlueAccent,
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.grey),
                      )),
                  child: Row(children: [
                    Expanded(
                        flex: 5,
                        child: Text(global.language("customer_code"),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 10,
                        child: Text(
                          global.language("customer_name"),
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

  void switchToEdit(CustomerModel value) {
    setState(() {
      selectGuid = value.guidfixed;
      getData(selectGuid);
      headerEdit = global.language("edit");
      isSaveAllow = true;
      isEditMode = true;
    });
  }

  Widget listObject(CustomerModel value, bool showCheckBox) {
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
      context.read<CustomerBloc>().add(CustomerSave(customerModel: screenData));
    } else {
      updateData(selectGuid);
    }
  }

  void updateData(String guid) {
    showCheckBox = false;
    context
        .read<CustomerBloc>()
        .add(CustomerUpdate(guid: guid, customerModel: screenData));
  }

  void getDataToEditScreen(CustomerModel customer) {
    isChange = false;
    selectGuid = customer.guidfixed;
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
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
            readOnly: !isEditMode,
            onFieldSubmitted: (value) {
              findFocusNext(0);
            },
            textInputAction: TextInputAction.next,
            focusNode: fieldFocusNodes[nodeIndex],
            textAlign: TextAlign.left,
            controller: TextEditingController(text: screenData.code),
            textCapitalization: TextCapitalization.characters,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
            ],
            onChanged: (value) {
              isChange = true;
              screenData.code = value;
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: global.language("customer_code"),
            ))));
    for (int languageIndex = 0;
        languageIndex < languageList.length;
        languageIndex++) {
      nodeIndex++;
      formWidgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 10),
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
            findFocusNext(focusNodeIndex);
          },
          textInputAction: TextInputAction.next,
          focusNode: fieldFocusNodes[nodeIndex],
          textAlign: TextAlign.left,
          controller:
              TextEditingController(text: screenData.names[languageIndex].name),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText:
                "${global.language("customer_name")} (${languageList[languageIndex].name})",
          ),
        ),
      ));
    }
    nodeIndex++;
    formWidgets.add(Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Radio(
              focusNode: FocusNode(skipTraversal: true),
              value: 1,
              groupValue: screenData.personaltype,
              onChanged: (value) {
                setState(() {
                  screenData.personaltype = value!;
                });
              },
            ),
            const Text("บุคคลธรรมดา"),
            const SizedBox(width: 10),
            Radio(
              focusNode: FocusNode(skipTraversal: true),
              value: 2,
              groupValue: screenData.personaltype,
              onChanged: (value) {
                setState(() {
                  screenData.personaltype = value!;
                });
              },
            ),
            const Text("นิติบุคคล"),
          ],
        )));
    nodeIndex++;
    formWidgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
            readOnly: !isEditMode,
            onFieldSubmitted: (value) {
              findFocusNext(focusNodeIndex);
            },
            textInputAction: TextInputAction.next,
            focusNode: fieldFocusNodes[nodeIndex],
            textAlign: TextAlign.left,
            controller: TextEditingController(text: screenData.taxid),
            textCapitalization: TextCapitalization.characters,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
            ],
            onChanged: (value) {
              isChange = true;
              screenData.taxid = value;
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: global.language((screenData.personaltype == 1)
                  ? "customer_tax_id_card_number"
                  : "customer_tax_id_bussiness"),
            ))));
    nodeIndex++;
    formWidgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
            readOnly: !isEditMode,
            onFieldSubmitted: (value) {
              bool isValid = (screenData.email.isEmpty)
                  ? true
                  : EmailValidator.validate(screenData.email);
              if (!isValid) {
                global.showSnackBar(
                    context,
                    const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    global.language("email_error"),
                    Colors.red);
              }
              findFocusNext(focusNodeIndex);
            },
            textInputAction: TextInputAction.next,
            focusNode: fieldFocusNodes[nodeIndex],
            textAlign: TextAlign.left,
            controller: TextEditingController(text: screenData.email),
            textCapitalization: TextCapitalization.characters,
            onChanged: (value) {
              isChange = true;
              screenData.email = value;
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: global.language("customer_email"),
            ))));
    for (int addressIndex = 0; addressIndex < 3; addressIndex++) {
      nodeIndex++;
      formWidgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
          readOnly: !isEditMode,
          onChanged: (value) {
            isChange = true;
            screenData.addressforbilling.address[addressIndex] = value;
          },
          onFieldSubmitted: (value) {
            findFocusNext(focusNodeIndex);
          },
          textInputAction: TextInputAction.next,
          focusNode: fieldFocusNodes[nodeIndex],
          textAlign: TextAlign.left,
          controller: TextEditingController(
              text: screenData.addressforbilling.address[addressIndex]),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: global.language("tax_address_${addressIndex + 1}"),
          ),
        ),
      ));
    }
    nodeIndex++;
    formWidgets.add(Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        readOnly: !isEditMode,
        onChanged: (value) {
          isChange = true;
          screenData.addressforbilling.phoneprimary = value;
        },
        onFieldSubmitted: (value) {
          findFocusNext(focusNodeIndex);
        },
        textInputAction: TextInputAction.next,
        focusNode: fieldFocusNodes[nodeIndex],
        textAlign: TextAlign.left,
        controller: TextEditingController(
            text: screenData.addressforbilling.phoneprimary),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: global.language("telephone_primary"),
        ),
      ),
    ));
    nodeIndex++;
    formWidgets.add(Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        readOnly: !isEditMode,
        onChanged: (value) {
          isChange = true;
          screenData.addressforbilling.phonesecondary = value;
        },
        onFieldSubmitted: (value) {
          findFocusNext(focusNodeIndex);
        },
        textInputAction: TextInputAction.next,
        focusNode: fieldFocusNodes[nodeIndex],
        textAlign: TextAlign.left,
        controller: TextEditingController(
            text: screenData.addressforbilling.phonesecondary),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: global.language("telephone_secondary"),
        ),
      ),
    ));
    formWidgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(5.0))),
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 5.0,
              children: [
                ElevatedButton(
                    focusNode: FocusNode(skipTraversal: true),
                    onPressed: () {},
                    child: Text(
                        (screenData.addressforbilling.countryCode.isNotEmpty)
                            ? screenData.addressforbilling.countryCode
                            : global.language("address_country"))),
                ElevatedButton(
                    focusNode: FocusNode(skipTraversal: true),
                    onPressed: () {},
                    child: Text(
                        (screenData.addressforbilling.provincecode.isNotEmpty)
                            ? screenData.addressforbilling.provincecode
                            : global.language("address_province"))),
                ElevatedButton(
                    focusNode: FocusNode(skipTraversal: true),
                    onPressed: () {},
                    child: Text(
                        (screenData.addressforbilling.districtcode.isNotEmpty)
                            ? screenData.addressforbilling.districtcode
                            : global.language("address_district"))),
                ElevatedButton(
                    focusNode: FocusNode(skipTraversal: true),
                    onPressed: () {},
                    child: Text((screenData
                            .addressforbilling.subDistrictcode.isNotEmpty)
                        ? screenData.addressforbilling.subDistrictcode
                        : global.language("address_sub_district"))),
                ElevatedButton(
                    focusNode: FocusNode(skipTraversal: true),
                    onPressed: () {},
                    child: Text(
                        (screenData.addressforbilling.zipcode.isNotEmpty)
                            ? screenData.addressforbilling.zipcode
                            : global.language("address_zipcode"))),
                ElevatedButton(
                    focusNode: FocusNode(skipTraversal: true),
                    onPressed: () {},
                    child: Text((screenData.addressforbilling.latitude == 0 &&
                            screenData.addressforbilling.longitude == 0)
                        ? global.language("address_location_pin")
                        : "${global.language("address_location_pin_success")} ${screenData.addressforbilling.latitude},${screenData.addressforbilling.longitude}")),
              ],
            ))));
    for (int addressShipIndex = 0;
        addressShipIndex < screenData.addressforshipping.length;
        addressShipIndex++) {
      for (int addressIndex = 0; addressIndex < 3; addressIndex++) {
        nodeIndex++;
        formWidgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            readOnly: !isEditMode,
            onChanged: (value) {
              isChange = true;
              screenData.addressforshipping[addressShipIndex]
                  .address[addressIndex] = value;
            },
            onFieldSubmitted: (value) {
              findFocusNext(focusNodeIndex);
            },
            textInputAction: TextInputAction.next,
            focusNode: fieldFocusNodes[nodeIndex],
            textAlign: TextAlign.left,
            controller: TextEditingController(
                text: screenData.addressforshipping[addressShipIndex]
                    .address[addressIndex]),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText:
                  global.language("shipping_address_${addressIndex + 1}"),
            ),
          ),
        ));
      }
      nodeIndex++;
      formWidgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
          readOnly: !isEditMode,
          onChanged: (value) {
            isChange = true;
            screenData.addressforshipping[addressShipIndex].phoneprimary =
                value;
          },
          onFieldSubmitted: (value) {
            findFocusNext(focusNodeIndex);
          },
          textInputAction: TextInputAction.next,
          focusNode: fieldFocusNodes[nodeIndex],
          textAlign: TextAlign.left,
          controller: TextEditingController(
              text:
                  screenData.addressforshipping[addressShipIndex].phoneprimary),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: global.language("shipping_telephone_primary"),
          ),
        ),
      ));
      nodeIndex++;
      formWidgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
          readOnly: !isEditMode,
          onChanged: (value) {
            isChange = true;
            screenData.addressforshipping[addressShipIndex].phonesecondary =
                value;
          },
          onFieldSubmitted: (value) {
            findFocusNext(focusNodeIndex);
          },
          textInputAction: TextInputAction.next,
          focusNode: fieldFocusNodes[nodeIndex],
          textAlign: TextAlign.left,
          controller: TextEditingController(
              text: screenData
                  .addressforshipping[addressShipIndex].phonesecondary),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: global.language("shipping_telephone_secondary"),
          ),
        ),
      ));
      formWidgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0))),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 5.0,
                children: [
                  ElevatedButton(
                      focusNode: FocusNode(skipTraversal: true),
                      onPressed: () {},
                      child: Text((screenData
                              .addressforshipping[addressShipIndex]
                              .countryCode
                              .isNotEmpty)
                          ? screenData
                              .addressforshipping[addressShipIndex].countryCode
                          : global.language("address_country"))),
                  ElevatedButton(
                      focusNode: FocusNode(skipTraversal: true),
                      onPressed: () {},
                      child: Text((screenData
                              .addressforshipping[addressShipIndex]
                              .provincecode
                              .isNotEmpty)
                          ? screenData
                              .addressforshipping[addressShipIndex].provincecode
                          : global.language("address_province"))),
                  ElevatedButton(
                      focusNode: FocusNode(skipTraversal: true),
                      onPressed: () {},
                      child: Text((screenData
                              .addressforshipping[addressShipIndex]
                              .districtcode
                              .isNotEmpty)
                          ? screenData
                              .addressforshipping[addressShipIndex].districtcode
                          : global.language("address_district"))),
                  ElevatedButton(
                      focusNode: FocusNode(skipTraversal: true),
                      onPressed: () {},
                      child: Text((screenData
                              .addressforshipping[addressShipIndex]
                              .subDistrictcode
                              .isNotEmpty)
                          ? screenData.addressforshipping[addressShipIndex]
                              .subDistrictcode
                          : global.language("address_sub_district"))),
                  ElevatedButton(
                      focusNode: FocusNode(skipTraversal: true),
                      onPressed: () {},
                      child: Text((screenData
                              .addressforshipping[addressShipIndex]
                              .zipcode
                              .isNotEmpty)
                          ? screenData
                              .addressforshipping[addressShipIndex].zipcode
                          : global.language("address_zipcode"))),
                  ElevatedButton(
                      focusNode: FocusNode(skipTraversal: true),
                      onPressed: () {},
                      child: Text((screenData
                                      .addressforshipping[addressShipIndex]
                                      .latitude ==
                                  0 &&
                              screenData.addressforshipping[addressShipIndex]
                                      .longitude ==
                                  0)
                          ? global.language("address_location_pin")
                          : "${global.language("address_location_pin_success")} ${screenData.addressforshipping[addressShipIndex].latitude},${screenData.addressforshipping[addressShipIndex].longitude}")),
                ],
              ))));
    }
    if (isEditMode) {
      formWidgets.add(SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
              focusNode: FocusNode(skipTraversal: true),
              onPressed: () {
                setState(() {
                  List<LanguageDataModel> names = [];
                  for (int k = 0; k < languageList.length; k++) {
                    names.add(LanguageDataModel(
                        code: languageList[k].code, name: ""));
                  }
                  screenData.addressforshipping.add(CustomerAddressModel(
                      address: ["", "", ""],
                      countryCode: "",
                      provincecode: "",
                      districtcode: "",
                      subDistrictcode: "",
                      zipcode: "",
                      latitude: 0,
                      longitude: 0,
                      phoneprimary: "",
                      phonesecondary: "",
                      contactnames: names));
                });
              },
              icon: const Icon(Icons.add),
              label: Text(global.language("add_address_shipping")))));
    }
    List<Widget> imageList = [];
    for (int imageIndex = 0;
        imageIndex < screenData.imageuris.length;
        imageIndex++) {
      imageList.add(Container(
          width: 200,
          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(5.0))),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: IconButton(
                    focusNode: FocusNode(skipTraversal: true),
                    onPressed: () async {
                      screenData.imageuris.removeAt(imageIndex);
                      imageWeb.removeAt(imageIndex);
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.delete,
                    ),
                  )),
                  const SizedBox(width: 5),
                  Expanded(
                      child: IconButton(
                    focusNode: FocusNode(skipTraversal: true),
                    onPressed: (kIsWeb)
                        ? () async {
                            XFile? image = await _picker.pickImage(
                                source: ImageSource.gallery, imageQuality: 60);
                            if (image != null) {
                              var f = await image.readAsBytes();
                              imageWeb[imageIndex] = f;
                              setState(() {
                                FocusScope.of(context).unfocus();
                              });
                            }
                          }
                        : () async {
                            final XFile? photo = await _picker.pickImage(
                                source: ImageSource.gallery, imageQuality: 60);
                            if (photo != null) {
                              var f = await photo.readAsBytes();
                              imageWeb[imageIndex] = f;
                              setState(() {
                                FocusScope.of(context).unfocus();
                              });
                            }
                          },
                    icon: const Icon(
                      Icons.folder,
                    ),
                  )),
                  const SizedBox(width: 5),
                  if (kIsWeb == false)
                    Expanded(
                        child: IconButton(
                      focusNode: FocusNode(skipTraversal: true),
                      onPressed: () async {
                        final XFile? photo = await _picker.pickImage(
                            source: ImageSource.camera, imageQuality: 60);
                        if (photo != null) {
                          var f = await photo.readAsBytes();
                          imageWeb[imageIndex] = f;
                          setState(() {});
                        }
                      },
                      icon: const Icon(
                        Icons.camera_alt,
                      ),
                    )),
                ],
              ),
              Container(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                      ),
                      child: (imageWeb[imageIndex].isNotEmpty)
                          ? Image(image: MemoryImage(imageWeb[imageIndex]))
                          : (screenData.imageuris[imageIndex] != '')
                              ? Image(
                                  image: NetworkImage(
                                      screenData.imageuris[imageIndex]),
                                )
                              : const Image(
                                  image: AssetImage('assets/img/noimg.png')),
                    )),
                  ]))
            ],
          )));
    }
    formWidgets.add(Wrap(
      children: imageList,
    ));
    if (isEditMode) {
      formWidgets.add(SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
              focusNode: FocusNode(skipTraversal: true),
              onPressed: () {
                setState(() {
                  screenData.imageuris.add("");
                  imageWeb.add(Uint8List(0));
                  FocusScope.of(context).unfocus();
                });
              },
              icon: const Icon(Icons.add),
              label: Text(global.language("add_picture")))));
    }
    if (isSaveAllow) {
      formWidgets.add(SizedBox(
          width: double.infinity,
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
            title: Text(headerEdit + global.language("customer")),
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
                                        .read<CustomerBloc>()
                                        .add(CustomerDelete(guid: selectGuid));
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
                  padding: const EdgeInsets.all(10),
                  child: Column(children: formWidgets),
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
          return BlocListener<CustomerBloc, CustomerState>(
              listener: (context, state) {
                blocCustomerState = state;
                // Load
                if (state is CustomerLoadSuccess) {
                  setState(() {
                    if (state.customers.isNotEmpty) {
                      listDatas.addAll(state.customers);
                    }
                  });
                }
                // Save
                if (state is CustomerSaveSuccess) {
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
                if (state is CustomerSaveFailed) {
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
                if (state is CustomerUpdateSuccess) {
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
                if (state is CustomerUpdateFailed) {
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
                if (state is CustomerDeleteSuccess) {
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
                if (state is CustomerDeleteManySuccess) {
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
                if (state is CustomerGetSuccess) {
                  setState(() {
                    getDataToEditScreen(state.customer);
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
