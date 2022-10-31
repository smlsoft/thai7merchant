import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remove_background/crop_widget.dart';
import 'package:split_view/split_view.dart';
import 'package:thai7merchant/bloc/category/category_bloc.dart';
import 'package:thai7merchant/model/category_list_model.dart';
import 'package:thai7merchant/model/category_model.dart';
import 'package:thai7merchant/model/language_model.dart';
import 'package:translator/translator.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:thai7merchant/global.dart' as global;

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  final translator = GoogleTranslator();
  late DropzoneViewController dropZoneController;
  final ImagePicker _picker = ImagePicker();
  File imageFile = File('');
  List<CategoryListModel> rootCategorys = [];
  List<Widget> listColumns = [];
  ScrollController listScrollController = ScrollController();
  ScrollController editScrollController = ScrollController();
  bool needScroll = false;
  String selectGuid = "";
  String selectParentGuid = "";
  String selectParentName = "";
  String selectDragTargetGuid = "";
  late TabController tabController;
  List<String> fieldName = [];
  Uint8List? imageWeb;
  List<LanguageModel> languageList = <LanguageModel>[];
  List<TextEditingController> fieldTextController = [];
  List<FocusNode> fieldFocusNodes = [];
  int focusNodeIndex = 0;
  late CategoryState blocCategoryState;
  bool isEditMode = false;
  bool isChange = false;
  bool isSaveAllow = false;
  bool isDeleteAllow = false;
  String headerEdit = "";
  String selectImageUri = "";

  String packName(List<LanguageDataModel> names) {
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
          fieldTextController[i].text.trim().isNotEmpty) {
        names.add(LanguageDataModel(
          code: languageList[i].code,
          name: fieldTextController[i].text,
          isauto: false,
        ));
      }
    }
    return names;
  }

  void loadDataList(String search) {
    context
        .read<CategoryBloc>()
        .add(CategoryLoadList(offset: 0, limit: 100000, search: search));
  }

  CategoryListModel? findByGuid(
      List<CategoryListModel> categorys, String guid) {
    for (int findIndex = 0; findIndex < categorys.length; findIndex++) {
      if (guid == categorys[findIndex].detail.guidfixed) {
        return categorys[findIndex];
      }
      if (categorys[findIndex].childCategorys.isNotEmpty) {
        CategoryListModel? find =
            findByGuid(categorys[findIndex].childCategorys, guid);
        if (find != null) {
          return find;
        }
      }
    }
    return null;
  }

  String categoryFullName(List<CategoryListModel> categorys, String guid,
      {String result = ""}) {
    for (int findIndex = 0; findIndex < categorys.length; findIndex++) {
      if (guid == categorys[findIndex].detail.guidfixed) {
        return result + categorys[findIndex].detail.names[0].name;
      }
      if (categorys[findIndex].childCategorys.isNotEmpty) {
        String find = categoryFullName(
            categorys[findIndex].childCategorys, guid,
            result: result);
        if (find.isNotEmpty) {
          return "$result${categorys[findIndex].detail.names[0].name},$find";
        }
      }
    }
    return result;
  }

  String selectParentGuidAll(List<CategoryListModel> categorys, String guid) {
    String result = "";
    for (int findIndex = 0; findIndex < categorys.length; findIndex++) {
      if (guid == categorys[findIndex].detail.guidfixed) {
        return result + categorys[findIndex].detail.guidfixed;
      }
      if (categorys[findIndex].childCategorys.isNotEmpty) {
        String find =
            selectParentGuidAll(categorys[findIndex].childCategorys, guid);
        if (find.isNotEmpty) {
          return "$result${categorys[findIndex].detail.guidfixed},$find";
        }
      }
    }
    return result;
  }

  void saveOrUpdateData() {
    if (selectGuid.trim().isEmpty) {
      CategoryModel categoryModel = CategoryModel(
        guidfixed: "",
        parentguid: selectParentGuid,
        parentguidall: selectParentGuidAll(rootCategorys, selectParentGuid),
        imageuri: "",
        childcount: 0,
        names: packLanguage(),
      );
      if (imageFile.path.isNotEmpty) {
        context.read<CategoryBloc>().add(CategoryWithImageSave(
              categoryModel: categoryModel,
              imageFile: imageFile,
              imageWeb: imageWeb,
            ));
      } else {
        context
            .read<CategoryBloc>()
            .add(CategorySave(categoryModel: categoryModel));
      }
    } else {
      updateData(selectGuid);
    }
  }

  void updateData(String guid) {
    CategoryModel categoryModel = CategoryModel(
      guidfixed: guid,
      parentguid: selectParentGuid,
      parentguidall: selectParentGuidAll(rootCategorys, selectParentGuid),
      imageuri: selectImageUri,
      childcount: 0,
      names: packLanguage(),
    );
    if (imageWeb != null) {
      context.read<CategoryBloc>().add(CategoryWithImageUpdate(
            guid: guid,
            categoryModel: categoryModel,
            imageFile: imageFile,
            imageWeb: imageWeb!,
          ));
    } else {
      context
          .read<CategoryBloc>()
          .add(CategoryUpdate(guid: guid, categoryModel: categoryModel));
    }
  }

  void buildColumnWidget() {
    listColumns.clear();
    categoryList(0, rootCategorys);
  }

  void categoryListScrollToEnd() async {
    listScrollController.animateTo(
        listScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }

  Widget categoryDetail(int level, CategoryListModel category) {
    return DragTarget(onWillAccept: (data) {
      setState(() {
        selectDragTargetGuid = category.detail.guidfixed;
        buildColumnWidget();
      });
      return !category.detail.parentguidall.contains(selectGuid);
      //return (activeSelectedGuid != category.detail.parentGuid);
    }, onAccept: (data) {
      setState(() {
        if (selectGuid != selectDragTargetGuid) {
          var findCategory = findByGuid(rootCategorys, selectGuid);
          if (findCategory != null) {
            selectParentGuid = selectDragTargetGuid;
            updateData(selectGuid);
          }
        }
      });
    }, onLeave: (data) {
      setState(() {
        //selectDragTargetGuid = "";
        //buildColumnWidget();
      });
    }, builder: (context, candidateData, rejectedData) {
      Color color = Colors.white;
      if (selectDragTargetGuid == category.detail.guidfixed) {
        color = Colors.green;
      }
      if (selectGuid == category.detail.guidfixed) {
        color = Colors.blue;
      }
      if (selectDragTargetGuid.isNotEmpty &&
          category.detail.parentguidall.contains(selectGuid)) {
        color = Colors.red;
      }

      return Container(
          color: color,
          padding: const EdgeInsets.all(4),
          width: double.infinity,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: level * 20,
              ),
              Expanded(
                child: Text(global.packName(category.detail.names),
                    style: const TextStyle(fontSize: 18)),
              ),
              if (category.childCategorys.isNotEmpty)
                IconButton(
                  padding: EdgeInsets.zero,
                  color: Colors.green,
                  focusNode: FocusNode(skipTraversal: true),
                  icon: Icon((category.isExpand)
                      ? Icons.expand_less
                      : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      selectDragTargetGuid = "";
                      category.isExpand = !category.isExpand;
                      buildColumnWidget();
                    });
                  },
                ),
            ],
          ));
    });
  }

  Widget categoryList(int level, List<CategoryListModel> categorys) {
    for (var index = 0; index < categorys.length; index++) {
      Widget detail = categoryDetail(level, categorys[index]);
      listColumns.add(GestureDetector(
          onTap: () {
            discardData(callBack: () {
              setState(() {
                developer.log("onTab");
                isSaveAllow = false;
                isEditMode = false;
                selectDragTargetGuid = "";
                selectGuid = categorys[index].detail.guidfixed;
                selectParentName = categorys[index].detail.names[0].name;
                selectImageUri = categorys[index].detail.imageuri;
                headerEdit = global.language("show");
                isDeleteAllow = categorys[index].childCategorys.isEmpty;
                context.read<CategoryBloc>().add(CategoryGet(guid: selectGuid));
                buildColumnWidget();
              });
            });
          },
          onDoubleTap: () {
            discardData(callBack: () {
              setState(() {
                isSaveAllow = true;
                isEditMode = true;
                selectDragTargetGuid = "";
                selectGuid = categorys[index].detail.guidfixed;
                selectParentName = categorys[index].detail.names[0].name;
                headerEdit = global.language("edit");
                isDeleteAllow = categorys[index].childCategorys.isEmpty;
                switchToEdit(selectGuid);
                buildColumnWidget();
                fieldFocusNodes[0].requestFocus();
              });
            });
          },
          child: LongPressDraggable<Widget>(
              data: detail,
              onDragStarted: () {
                setState(() {
                  selectGuid = categorys[index].detail.guidfixed;
                  context
                      .read<CategoryBloc>()
                      .add(CategoryGet(guid: selectGuid));
                  buildColumnWidget();
                });
              },
              dragAnchorStrategy: pointerDragAnchorStrategy,
              axis: Axis.vertical,
              feedback: SizedBox(
                  width: 100,
                  height: 100,
                  child: Text(global.packName(categorys[index].detail.names),
                      style: const TextStyle(fontSize: 18))),
              child: detail)));
      if (categorys[index].childCategorys.isNotEmpty &&
          categorys[index].isExpand) {
        categoryList(level + 1, categorys[index].childCategorys);
      }
    }

    return Column(children: listColumns);
  }

  @override
  void initState() {
    global.loadConfig();
    tabController = TabController(vsync: this, length: 2);
    for (int i = 0; i < global.config.languages.length; i++) {
      if (global.config.languages[i].use) {
        languageList.add(global.config.languages[i]);
      }
    }
    // เรียงลำดับ Focus
    fieldTextController.add(TextEditingController());
    for (int i = 0; i < languageList.length; i++) {
      fieldTextController.add(TextEditingController());
      FocusNode focusNode = FocusNode();
      focusNode.addListener(() {
        focusNodeIndex = i;
      });
      fieldFocusNodes.add(focusNode);
    }
    //listScrollController.addListener(onScrollList);
    loadDataList("");
    super.initState();
  }

  @override
  void dispose() {
    listScrollController.dispose();
    tabController.dispose();
    editScrollController.dispose();
    for (int i = 0; i < fieldTextController.length; i++) {
      fieldTextController[i].dispose();
    }
    for (int i = 0; i < fieldFocusNodes.length; i++) {
      fieldFocusNodes[i].dispose();
    }
    super.dispose();
  }

  void deleteDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(global.language('delete_confirm')),
        actions: <Widget>[
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context),
              child: Text(global.language('no'))),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                Navigator.pop(context);
                context
                    .read<CategoryBloc>()
                    .add(CategoryDelete(guid: selectGuid));
              },
              child: Text(global.language('confirm'))),
        ],
      ),
    );
  }

  Widget listScreen({required bool mobileScreen}) {
    if (needScroll) {
      categoryListScrollToEnd();
      needScroll = false;
    }
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(global.language('product_group')),
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
                        selectParentGuid = "";
                        isEditMode = true;
                        isChange = false;
                        isSaveAllow = true;
                        selectGuid = "";
                        headerEdit = global.language('append');
                        clearEditData();
                        if (mobileScreen && selectDragTargetGuid.isEmpty) {
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
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: Column(children: [
          if (selectDragTargetGuid.isNotEmpty)
            DragTarget(builder: (context, candidateData, rejectedData) {
              return Container(
                  width: double.infinity,
                  height: 40,
                  color: Colors.green,
                  child: const Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 26.0,
                  ));
            }, onWillAccept: (data) {
              return true;
            }, onAccept: (data) {
              setState(() {
                selectParentGuid = "";
                updateData(selectGuid);
              });
            }),
          Expanded(
              child: SingleChildScrollView(
            controller: listScrollController,
            child: Column(children: listColumns),
          ))
        ]));
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

  void switchToEdit(String guid) {
    setState(() {
      selectGuid = guid;
      context.read<CategoryBloc>().add(CategoryGet(guid: selectGuid));
      headerEdit = global.language("edit");
      isSaveAllow = true;
      isEditMode = true;
    });
  }

  Widget editScreen({mobileScreen = true}) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(headerEdit + global.language('product_group')),
          backgroundColor: (isEditMode) ? Colors.green : Colors.blue,
          leading: mobileScreen
              ? IconButton(
                  focusNode: FocusNode(skipTraversal: true),
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    tabController.index = 0;
                  },
                )
              : null,
          actions: <Widget>[
            if (isDeleteAllow && selectGuid.isNotEmpty)
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: IconButton(
                    focusNode: FocusNode(skipTraversal: true),
                    onPressed: () {
                      deleteDialog();
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.delete,
                    ),
                  )),
            if (global.systemLanguage.length > 1 && isSaveAllow)
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: IconButton(
                    focusNode: FocusNode(skipTraversal: true),
                    onPressed: () async {
                      for (int i = 1; i <= languageList.length; i++) {
                        try {
                          var translation = await translator.translate(
                              fieldTextController[0].text,
                              to: languageList[i].codeTranslator);
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
                      switchToEdit(selectGuid);
                    },
                    icon: const Icon(
                      Icons.edit,
                    ),
                  )),
            if (isSaveAllow)
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: IconButton(
                    focusNode: FocusNode(skipTraversal: true),
                    onPressed: () => saveOrUpdateData(),
                    icon: const Icon(
                      Icons.save,
                      size: 26.0,
                    ),
                  )),
            if (selectGuid.isNotEmpty)
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: IconButton(
                    focusNode: FocusNode(skipTraversal: true),
                    onPressed: () {
                      discardData(callBack: () {
                        setState(() {
                          selectParentGuid = selectGuid;
                          selectGuid = "";
                          isSaveAllow = true;
                          isEditMode = true;
                          isChange = false;
                          headerEdit = global.language('append');
                          tabController.index = 1;
                          clearEditData();
                          fieldFocusNodes[0].requestFocus();
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.add_link,
                      size: 26.0,
                    ),
                  )),
          ],
        ),
        body: SingleChildScrollView(
            controller: editScrollController,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                if (selectParentGuid.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(global.language("select_group")),
                              const SizedBox(width: 5),
                              Text(categoryFullName(
                                  rootCategorys, selectParentGuid))
                            ])),
                  ),
                const SizedBox(height: 10),
                for (int i = 0; i < languageList.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      onChanged: (value) {
                        isChange = true;
                      },
                      onFieldSubmitted: (value) {
                        findFocusNext(focusNodeIndex);
                      },
                      textInputAction: TextInputAction.next,
                      focusNode: fieldFocusNodes[i],
                      textAlign: TextAlign.left,
                      controller: fieldTextController[i],
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText:
                            "${global.language("product_group_name")} (${languageList[i].name})",
                      ),
                    ),
                  ),
                if (isEditMode)
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton.icon(
                        focusNode: FocusNode(skipTraversal: true),
                        onPressed: () async {
                          setState(() {
                            imageWeb = null;
                            selectImageUri = "";
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
                  ),
                const SizedBox(height: 10),
                //  if (kIsWeb)
                SizedBox(
                    width: 500,
                    height: 500,
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
                          final bytes =
                              await dropZoneController.getFileData(ev);
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
                                  image: MemoryImage(imageWeb!),
                                  fit: BoxFit.fill)
                              : (selectImageUri != '')
                                  ? DecorationImage(
                                      image: NetworkImage(selectImageUri),
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
                // else
                //   (selectImageUri != '')
                //       ? Image.network(selectImageUri, fit: BoxFit.cover)
                //       : Image.asset('assets/img/noimg.png', fit: BoxFit.cover),
                const SizedBox(height: 10),
                if (isEditMode)
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                          focusNode: FocusNode(skipTraversal: true),
                          onPressed: () {
                            saveOrUpdateData();
                          },
                          icon: const Icon(Icons.save),
                          label: Text(global.language("save") +
                              ((kIsWeb) ? " (F10)" : ""))))
              ]),
            )));
  }

  void clearEditData() {
    for (int i = 0; i < fieldTextController.length; i++) {
      fieldTextController[i].clear();
    }
    isChange = false;
    focusNodeIndex = 0;
    fieldFocusNodes[focusNodeIndex].requestFocus();
    setState(() {
      imageFile = File('');
      imageWeb = null;
      selectImageUri = "";
    });
  }

  void getDataToEditScreen(CategoryModel category) {
    isChange = false;
    selectGuid = category.guidfixed;
    selectParentGuid = category.parentguid;
    selectImageUri = category.imageuri;
    imageWeb = null;
    imageFile = File('');
    for (int i = 0; i < languageList.length; i++) {
      fieldTextController[i].text = "";
    }
    for (int i = 0; i < languageList.length; i++) {
      for (int j = 0; j < category.names.length; j++) {
        if (languageList[i].code == category.names[j].code) {
          fieldTextController[i].text = category.names[j].name;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(builder: (context, constraints) {
          bool mobileScreen = (constraints.maxWidth < 800.0);
          return BlocListener<CategoryBloc, CategoryState>(
              listener: (context, state) {
                blocCategoryState = state;
                // Load
                if (state is CategoryLoadSuccess) {
                  setState(() {
                    rootCategorys.clear();
                    for (var item in state.categorys) {
                      rootCategorys.add(
                          CategoryListModel(detail: item, childCategorys: []));
                    }
                    int index = 0;
                    while (index < rootCategorys.length) {
                      if (rootCategorys[index].detail.parentguid.isNotEmpty) {
                        CategoryListModel? findCategory = findByGuid(
                            rootCategorys,
                            rootCategorys[index].detail.parentguid);
                        if (findCategory != null) {
                          findCategory.childCategorys.add(rootCategorys[index]);
                          rootCategorys.removeAt(index);
                        } else {
                          index++;
                        }
                      } else {
                        index++;
                      }
                    }
                    buildColumnWidget();
                  });
                }
                // Save
                if (state is CategorySaveSuccess) {
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
                    loadDataList("");
                  });
                }
                if (state is CategorySaveFailed) {
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
                if (state is CategoryUpdateSuccess) {
                  setState(() {
                    global.showSnackBar(
                        context,
                        const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        "แก้ไขสำเร็จ",
                        Colors.blue);
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      tabController.animateTo(0);
                    });
                    // context
                    //     .read<CategoryBloc>()
                    //     .add(CategoryGet(guid: selectGuid));
                    loadDataList("");
                    isSaveAllow = false;
                    isEditMode = false;

                    selectDragTargetGuid = "";
                  });
                }
                if (state is CategoryUpdateFailed) {
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
                if (state is CategoryDeleteSuccess) {
                  setState(() {
                    global.showSnackBar(
                        context,
                        const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        "ลบสำเร็จ",
                        Colors.blue);
                    selectGuid = "";
                    isSaveAllow = false;
                    isEditMode = false;
                    clearEditData();
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      tabController.animateTo(0);
                    });
                    loadDataList("");
                  });
                }
                // Delete Many
                if (state is CategoryDeleteManySuccess) {
                  setState(() {
                    global.showSnackBar(
                        context,
                        const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        "ลบสำเร็จ",
                        Colors.blue);
                    //unitListDatas.clear();
                    //clearEditData();
                    //loadDataList(searchText);
                    //showCheckBox = false;
                  });
                }
                // Get
                if (state is CategoryGetSuccess) {
                  setState(() {
                    getDataToEditScreen(state.category);
                    if (mobileScreen && selectDragTargetGuid.isEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        tabController.animateTo(1);
                      });
                    }
                  });
                }
              },
              child: (mobileScreen == false)
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
