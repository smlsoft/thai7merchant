import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thai7merchant/model/config_model.dart';
import 'package:thai7merchant/model/global_model.dart';
import 'package:thai7merchant/global.dart' as global;
import 'package:thai7merchant/utils/get_location_from_map.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({Key? key}) : super(key: key);

  @override
  State<CompanyScreen> createState() => CompanyScreenState();
}

class CompanyScreenState extends State<CompanyScreen>
    with SingleTickerProviderStateMixin {
  // google map AIzaSyAYPfJxUvwSuZ6rAL8tUIr7uBGQNNbsQZw
  late DropzoneViewController dropZoneController;
  final ImagePicker imagePicker = ImagePicker();
  List<File> imageFile = [];
  List<Uint8List> imageWeb = [];
  List<LanguageModel> languageList = <LanguageModel>[];
  List<FocusNode> fieldFocusNodes = [];
  late CompanyModel screenData;
  int focusNodeIndex = 0;
  bool isChange = false;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    global.loadConfig();
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
    screenData = CompanyModel(
        names: [],
        taxID: "",
        branchNames: [],
        addresses: [],
        phones: [],
        emailOwners: [],
        emailStaffs: [],
        latitude: 0,
        longitude: 0,
        images: []);
    for (int i = 0; i < languageList.length; i++) {
      screenData.names
          .add(LanguageDataModel(code: languageList[i].code, name: ""));
      screenData.branchNames
          .add(LanguageDataModel(code: languageList[i].code, name: ""));
      screenData.addresses
          .add(LanguageDataModel(code: languageList[i].code, name: ""));
    }
    for (int i = 0; i < 3; i++) {
      screenData.phones.add("");
      screenData.emailOwners.add("");
      screenData.emailStaffs.add("");
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> formWidgets = [];
    List<Widget> companyNames = [];
    List<Widget> companyBranchNames = [];
    List<Widget> companyAddressLists = [];

    focusNodeIndex = 0;
    for (int i = 0; i < languageList.length; i++) {
      focusNodeIndex++;
      companyNames.add(TextFormField(
        controller: TextEditingController(text: screenData.names[i].name),
        onChanged: (value) {
          isChange = true;
        },
        focusNode: fieldFocusNodes[focusNodeIndex],
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: const OutlineInputBorder(),
          labelText:
              "${global.language("company_name")} (${languageList[i].name})",
          labelStyle: const TextStyle(fontSize: 16.0),
        ),
        onFieldSubmitted: (String value) {
          screenData.names[i].name = value;
          FocusScope.of(context)
              .requestFocus(fieldFocusNodes[focusNodeIndex + 1]);
        },
      ));
      companyNames.add(const SizedBox(height: 10));
    }
    formWidgets.add(Column(children: companyNames));
    focusNodeIndex++;
    formWidgets.add(TextFormField(
      controller: TextEditingController(text: screenData.taxID),
      onChanged: (value) {
        isChange = true;
      },
      focusNode: fieldFocusNodes[focusNodeIndex],
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: const OutlineInputBorder(),
        labelText: global.language("company_tax_id"),
        labelStyle: const TextStyle(fontSize: 16.0),
      ),
      onFieldSubmitted: (String value) {
        screenData.taxID = value;
        FocusScope.of(context)
            .requestFocus(fieldFocusNodes[focusNodeIndex + 1]);
      },
    ));
    formWidgets.add(const SizedBox(height: 10));
    for (int i = 0; i < languageList.length; i++) {
      focusNodeIndex++;
      companyBranchNames.add(TextFormField(
        controller: TextEditingController(text: screenData.branchNames[i].name),
        onChanged: (value) {
          isChange = true;
        },
        focusNode: fieldFocusNodes[focusNodeIndex],
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: const OutlineInputBorder(),
          labelText:
              "${global.language("company_branch_name")} (${languageList[i].name})",
          labelStyle: const TextStyle(fontSize: 16.0),
        ),
        onFieldSubmitted: (String value) {
          screenData.branchNames[i].name = value;
          FocusScope.of(context)
              .requestFocus(fieldFocusNodes[focusNodeIndex + 1]);
        },
      ));
      companyBranchNames.add(const SizedBox(height: 10));
    }
    formWidgets.add(Column(children: companyBranchNames));
    for (int i = 0; i < languageList.length; i++) {
      focusNodeIndex++;
      companyAddressLists.add(TextFormField(
        controller: TextEditingController(text: screenData.addresses[i].name),
        onChanged: (value) {
          isChange = true;
        },
        focusNode: fieldFocusNodes[focusNodeIndex],
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: const OutlineInputBorder(),
          labelText:
              "${global.language("company_address")} (${languageList[i].name})",
          labelStyle: const TextStyle(fontSize: 16.0),
        ),
        onFieldSubmitted: (String value) {
          screenData.addresses[i].name = value;
          FocusScope.of(context)
              .requestFocus(fieldFocusNodes[focusNodeIndex + 1]);
        },
      ));
      companyAddressLists.add(const SizedBox(height: 10));
    }
    formWidgets.add(Column(children: companyAddressLists));
    List<Widget> telephones = [];
    for (int i = 0; i < 3; i++) {
      focusNodeIndex++;
      telephones.add(Container(
          margin: const EdgeInsets.only(right: 10),
          width: 250,
          child: TextFormField(
            controller: TextEditingController(text: screenData.phones[i]),
            onChanged: (value) {
              isChange = true;
            },
            focusNode: fieldFocusNodes[focusNodeIndex],
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: const OutlineInputBorder(),
              labelText: global.language("company_telephone (${i + 1})"),
              labelStyle: const TextStyle(fontSize: 16.0),
            ),
            onFieldSubmitted: (String value) {
              screenData.phones[i] = value;
              FocusScope.of(context)
                  .requestFocus(fieldFocusNodes[focusNodeIndex + 1]);
            },
          )));
    }
    formWidgets.add(Wrap(children: telephones));
    formWidgets.add(const SizedBox(height: 10));
    List<Widget> emailOwners = [];
    for (int i = 0; i < 3; i++) {
      focusNodeIndex++;
      emailOwners.add(Container(
          margin: const EdgeInsets.only(right: 10),
          width: 250,
          child: TextFormField(
            controller: TextEditingController(text: screenData.emailOwners[i]),
            onChanged: (value) {
              isChange = true;
            },
            focusNode: fieldFocusNodes[focusNodeIndex],
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: const OutlineInputBorder(),
              labelText: global.language("company_email_owner (${i + 1})"),
              labelStyle: const TextStyle(fontSize: 16.0),
            ),
            onFieldSubmitted: (String value) {
              screenData.emailOwners[i] = value;
              FocusScope.of(context)
                  .requestFocus(fieldFocusNodes[focusNodeIndex + 1]);
            },
          )));
    }
    formWidgets.add(Wrap(children: emailOwners));
    formWidgets.add(const SizedBox(height: 10));
    List<Widget> emailStaffs = [];
    for (int i = 0; i < 3; i++) {
      focusNodeIndex++;
      emailStaffs.add(Container(
          margin: const EdgeInsets.only(right: 10),
          width: 250,
          child: TextFormField(
            controller: TextEditingController(text: screenData.emailStaffs[i]),
            onChanged: (value) {
              isChange = true;
            },
            focusNode: fieldFocusNodes[focusNodeIndex],
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: const OutlineInputBorder(),
              labelText: global.language("company_email_staff (${i + 1})"),
              labelStyle: const TextStyle(fontSize: 16.0),
            ),
            onFieldSubmitted: (String value) {
              screenData.emailStaffs[i] = value;
              FocusScope.of(context)
                  .requestFocus(fieldFocusNodes[focusNodeIndex + 1]);
            },
          )));
    }
    formWidgets.add(Wrap(children: emailStaffs));
    formWidgets.add(const SizedBox(height: 10));
    List<Widget> locations = [];
    focusNodeIndex++;
    locations.add(Container(
        margin: const EdgeInsets.only(right: 10),
        width: 250,
        child: TextFormField(
          controller:
              TextEditingController(text: screenData.latitude.toString()),
          onChanged: (value) {
            isChange = true;
          },
          focusNode: fieldFocusNodes[focusNodeIndex],
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: const OutlineInputBorder(),
            labelText: global.language("company_latitude"),
            labelStyle: const TextStyle(fontSize: 16.0),
          ),
          onFieldSubmitted: (String value) {
            screenData.latitude = double.tryParse(value) ?? 0.0;
            FocusScope.of(context)
                .requestFocus(fieldFocusNodes[focusNodeIndex + 1]);
          },
        )));
    focusNodeIndex++;
    locations.add(Container(
        margin: const EdgeInsets.only(right: 10),
        width: 250,
        child: TextFormField(
          controller:
              TextEditingController(text: screenData.longitude.toString()),
          onChanged: (value) {
            isChange = true;
          },
          focusNode: fieldFocusNodes[focusNodeIndex],
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: const OutlineInputBorder(),
            labelText: global.language("company_latitude"),
            labelStyle: const TextStyle(fontSize: 16.0),
          ),
          onFieldSubmitted: (String value) {
            screenData.longitude = double.tryParse(value) ?? 0.0;
            FocusScope.of(context)
                .requestFocus(fieldFocusNodes[focusNodeIndex + 1]);
          },
        )));
    locations.add(Container(
        margin: const EdgeInsets.only(right: 10),
        width: 250,
        child: IconButton(
            focusNode: FocusNode(skipTraversal: true),
            icon: const FaIcon(FontAwesomeIcons.mapMarked),
            onPressed: () async {
              final result = Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GetLocationFromMap(
                        latitude: screenData.latitude,
                        longitude: screenData.longitude)),
              );
              result.then((value) {
                if (value != null) {
                  screenData.latitude = value.latitude;
                  screenData.longitude = value.longitude;
                  setState(() {});
                }
              });
            })));
    formWidgets.add(Row(children: locations));

    List<Widget> imageList = [];
    for (int imageIndex = 0;
        imageIndex < screenData.images.length;
        imageIndex++) {
      imageList.add(Container(
          width: 300,
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
                      screenData.images.removeAt(imageIndex);
                      imageWeb.removeAt(imageIndex);
                      imageFile.removeAt(imageIndex);
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
                              setState(() {
                                FocusScope.of(context).unfocus();
                              });
                            }
                          }
                        : () async {
                            final XFile? photo = await imagePicker.pickImage(
                                source: ImageSource.camera,
                                maxHeight: 480,
                                maxWidth: 640,
                                imageQuality: 60);
                            if (photo != null) {
                              var f = await photo.readAsBytes();
                              imageWeb[imageIndex] = f;
                              imageFile.add(File(photo.path));
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
                        final XFile? photo = await imagePicker.pickImage(
                            source: ImageSource.camera,
                            maxHeight: 480,
                            maxWidth: 640,
                            imageQuality: 60);
                        if (photo != null) {
                          var f = await photo.readAsBytes();
                          imageWeb[imageIndex] = f;
                          imageFile.add(File(photo.path));
                          setState(() {});
                        }
                      },
                      icon: const Icon(
                        Icons.camera_alt,
                      ),
                    )),
                ],
              ),
              SizedBox(
                  width: 300,
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
                                    image: NetworkImage(
                                        screenData.images[imageIndex].uri),
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
                  ])),
            ],
          )));
    }
    formWidgets.add(Wrap(
      children: imageList,
    ));
    formWidgets.add(SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
            focusNode: FocusNode(skipTraversal: true),
            onPressed: () {
              setState(() {
                screenData.images.add(ImagesModel(uri: '', xorder: 0));
                imageWeb.add(Uint8List(0));
                imageFile.add(File(''));
                FocusScope.of(context).unfocus();
              });
            },
            icon: const Icon(Icons.add),
            label: Text(global.language("add_picture")))));

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(builder: (context, constraints) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: global.theme.appBarColor,
                automaticallyImplyLeading: false,
                title: Text(global.language('company')),
                leading: IconButton(
                  focusNode: FocusNode(skipTraversal: true),
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: IconButton(
                        focusNode: FocusNode(skipTraversal: true),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.save,
                          size: 26.0,
                        ),
                      )),
                ],
              ),
              body: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(children: formWidgets))));
        }));
  }
}
