import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thai7merchant/model/category_list_model.dart';
import 'package:thai7merchant/model/category_model.dart';
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
  late DropzoneViewController dropZoneController;
  final ImagePicker _picker = ImagePicker();
  File imageFile = File('');
  List<CategoryListModel> rootCategorys = [];
  List<Widget> columns = [];
  ScrollController listScrollController = ScrollController();
  ScrollController editScrollController = ScrollController();
  bool needScroll = false;
  String activeSelectedGuid = "";
  String activeDragTargetGuid = "";
  late TabController tabController;
  List<TextEditingController> nameController = [];
  List<String> fieldName = [];
  List<FocusNode> nameFocusNode = [];
  Uint8List? imageWeb;

  CategoryListModel findByGuid(List<CategoryListModel> categorys, String guid) {
    CategoryListModel result = CategoryListModel(
        detail: CategoryModel(guidfixed: "", name1: "", parentGuid: ""),
        childCategorys: []);
    for (int findIndex = 0; findIndex < categorys.length; findIndex++) {
      if (guid == categorys[findIndex].detail.guidfixed) {
        result = categorys[findIndex];
        break;
      }
      if (result.detail.guidfixed == "") {
        result = findByGuid(categorys[findIndex].childCategorys, guid);
      }
    }
    return result;
  }

  void removeByGuid(List<CategoryListModel> categorys, String guid) {
    for (int findIndex = 0; findIndex < categorys.length; findIndex++) {
      if (guid == categorys[findIndex].detail.guidfixed) {
        categorys.removeAt(findIndex);
        break;
      }
      removeByGuid(categorys[findIndex].childCategorys, guid);
    }
  }

  void insertByGuid(List<CategoryListModel> categorys, String guid,
      CategoryListModel newCategory) {
    for (int findIndex = 0; findIndex < categorys.length; findIndex++) {
      if (guid == categorys[findIndex].detail.guidfixed) {
        categorys.insert(findIndex, newCategory);
        break;
      }
      insertByGuid(categorys[findIndex].childCategorys, guid, newCategory);
    }
  }

  void updateParentGuid(
      List<CategoryListModel> categorys, String parentGuid, String guid) {
    for (int findIndex = 0; findIndex < categorys.length; findIndex++) {
      categorys[findIndex].detail.parentGuid = guid;
      categorys[findIndex].detail.parentGuidAll = "$parentGuid,$guid";
      updateParentGuid(
          categorys[findIndex].childCategorys,
          categorys[findIndex].detail.parentGuidAll,
          categorys[findIndex].detail.guidfixed);
    }
  }

  void buildColumnWidget() {
    columns.clear();
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
        activeDragTargetGuid = category.detail.guidfixed;
        buildColumnWidget();
      });
      return !category.detail.parentGuidAll.contains(activeSelectedGuid);
      //return (activeSelectedGuid != category.detail.parentGuid);
    }, onAccept: (data) {
      setState(() {
        if (activeSelectedGuid != activeDragTargetGuid) {
          var findCategory = findByGuid(rootCategorys, activeSelectedGuid);
          removeByGuid(rootCategorys, activeSelectedGuid);
          insertByGuid(rootCategorys, activeDragTargetGuid, findCategory);
          updateParentGuid(rootCategorys, "", "");
          activeDragTargetGuid = "";
          activeSelectedGuid = category.detail.guidfixed;
          buildColumnWidget();
        }
      });
    }, onLeave: (data) {
      setState(() {
        activeDragTargetGuid = "";
        buildColumnWidget();
      });
    }, builder: (context, candidateData, rejectedData) {
      Color color = Colors.white;
      if (activeDragTargetGuid == category.detail.guidfixed) {
        color = Colors.green;
      }
      if (activeSelectedGuid == category.detail.guidfixed) {
        color = Colors.blue;
      }
      if (activeDragTargetGuid.isNotEmpty &&
          category.detail.parentGuidAll.contains(activeSelectedGuid)) {
        color = Colors.red;
      }

      return Container(
          color: color,
          padding: const EdgeInsets.all(4),
          width: double.infinity,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: level * 10,
              ),
              Expanded(
                child: Text(category.detail.name1,
                    style: const TextStyle(fontSize: 18)),
              ),
              if (category.childCategorys.isNotEmpty)
                IconButton(
                  icon: Icon((category.isExpand)
                      ? Icons.expand_less
                      : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      activeDragTargetGuid = "";
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
      columns.add(GestureDetector(
          onTap: () {
            setState(() {
              activeDragTargetGuid = "";
              if (activeSelectedGuid == categorys[index].detail.guidfixed) {
                activeSelectedGuid = "";
              } else {
                activeSelectedGuid = categorys[index].detail.guidfixed;
              }
              buildColumnWidget();
            });
          },
          child: LongPressDraggable<Widget>(
              data: detail,
              onDragStarted: () {
                setState(() {
                  activeSelectedGuid = categorys[index].detail.guidfixed;
                  buildColumnWidget();
                });
              },
              dragAnchorStrategy: pointerDragAnchorStrategy,
              axis: Axis.vertical,
              feedback: SizedBox(
                  width: 100,
                  height: 100,
                  child: Text(categorys[index].detail.name1,
                      style: const TextStyle(fontSize: 18))),
              child: detail)));
      if (categorys[index].childCategorys.isNotEmpty &&
          categorys[index].isExpand) {
        categoryList(level + 1, categorys[index].childCategorys);
      }
    }

    return Column(children: columns);
  }

  @override
  void initState() {
    global.loadConfig();
    for (int i = 0; i < global.config.languages.length; i++) {
      nameController.add(TextEditingController());
      nameFocusNode.add(FocusNode());
      fieldName.add("name${i + 1}");
    }
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    listScrollController.dispose();
    editScrollController.dispose();
    for (int i = 0; i < nameController.length; i++) {
      nameController[i].dispose();
      nameFocusNode[i].dispose();
    }
    tabController.dispose();
    super.dispose();
  }

  void insertNewCategory() {
    setState(() {
      String newGuid = const Uuid().v4();
      CategoryListModel newCategory = CategoryListModel(
        detail: CategoryModel(
            guidfixed: newGuid,
            parentGuid: '',
            name1: newGuid,
            name2: '',
            name3: '',
            name4: '',
            name5: '',
            image: ''),
        childCategorys: [],
      );
      int addr = rootCategorys.length;
      List<CategoryListModel> currentCategorys = [];
      CategoryListModel findCategory =
          findByGuid(rootCategorys, activeSelectedGuid);
      if (findCategory.detail.parentGuid.isEmpty) {
        currentCategorys = rootCategorys;
        needScroll = true;
      } else {
        CategoryListModel findParentCatagory =
            findByGuid(rootCategorys, findCategory.detail.parentGuid);
        currentCategorys = findParentCatagory.childCategorys;
      }
      addr = currentCategorys.length;
      if (activeSelectedGuid.isNotEmpty) {
        for (int findAddr = 0; findAddr < currentCategorys.length; findAddr++) {
          if (currentCategorys[findAddr].detail.guidfixed ==
              activeSelectedGuid) {
            addr = findAddr + 1;
            break;
          }
        }
      }
      currentCategorys.insert(addr, newCategory);
      updateParentGuid(rootCategorys, "", "");
      buildColumnWidget();
    });
  }

  Widget categoryListScreen() {
    if (needScroll) {
      categoryListScrollToEnd();
      needScroll = false;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('กลุ่มสินค้า'),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      activeDragTargetGuid = "";
                      removeByGuid(rootCategorys, activeSelectedGuid);
                      buildColumnWidget();
                    });
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
                    nameFocusNode[0].requestFocus();
                    //insertNewCategory();
                  },
                  child: const Icon(
                    Icons.add,
                    size: 26.0,
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    var guid = const Uuid().v4();
                    setState(() {
                      CategoryListModel category =
                          findByGuid(rootCategorys, activeSelectedGuid);
                      category.childCategorys.add(CategoryListModel(
                          detail: CategoryModel(
                              guidfixed: guid,
                              parentGuid: category.detail.guidfixed,
                              name1: guid,
                              name2: '',
                              name3: '',
                              name4: '',
                              name5: '',
                              image: ''),
                          childCategorys: []));
                      activeDragTargetGuid = "";
                      updateParentGuid(rootCategorys, "", "");
                      buildColumnWidget();
                    });
                  },
                  child: const Icon(
                    Icons.add_link,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: SingleChildScrollView(
          controller: listScrollController,
          child: Column(children: columns),
        ));
  }

  Widget categoryEditParent() {
    CategoryListModel category = findByGuid(rootCategorys, activeSelectedGuid);
    print(category.detail.parentGuidAll);
    if (category.detail.parentGuid.isEmpty) {
      return const Text("กลุ่มหลัก (กดเพื่อเลือกกลุ่มอื่น)");
    } else {
      return Wrap(
        children: [],
      );
    }
  }

  Widget categoryEditScreen({showBackButton = true}) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('รายละเอียดกลุ่มสินค้า'),
          leading: showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    tabController.index = 0;
                  },
                )
              : null,
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: const Icon(
                    Icons.save,
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {});
                      },
                      child: categoryEditParent()),
                ),
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
                              "ชื่อกลุ่มสินค้า (${global.config.languages[i].name})",
                        ),
                      ),
                    ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton.icon(
                      onPressed: () async {
                        setState(() {
                          if (kIsWeb) {
                            imageWeb = null;
                          } else {}
                        });
                      },
                      icon: const Icon(
                        Icons.delete,
                      ),
                      label: const Text('ลบ'),
                    )),
                    const SizedBox(width: 5),
                    Expanded(
                        child: ElevatedButton.icon(
                      onPressed: (kIsWeb)
                          ? () async {
                              final ImagePicker picker = ImagePicker();
                              XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (image != null) {
                                var f = await image.readAsBytes();
                                setState(() {
                                  imageWeb = f;
                                });
                              }
                            }
                          : () {
                              setState(() async {
                                final XFile? photo = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                if (photo != null) {
                                  setState(() {
                                    imageFile = File(photo.path);
                                  });
                                }
                              });
                            },
                      icon: const Icon(
                        Icons.folder,
                      ),
                      label: const Text('เลือก'),
                    )),
                    const SizedBox(width: 5),
                    Expanded(
                        child: ElevatedButton.icon(
                      onPressed: (kIsWeb)
                          ? null
                          : () async {
                              final XFile? photo = await _picker.pickImage(
                                  source: ImageSource.camera);
                              if (photo != null) {
                                setState(() {
                                  imageFile = File(photo.path);
                                });
                              }
                            },
                      icon: const Icon(
                        Icons.camera_alt,
                      ),
                      label: const Text('ถ่าย'),
                    )),
                  ],
                ),
                const SizedBox(height: 10),
                if (kIsWeb)
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
                                : const DecorationImage(
                                    image: AssetImage('assets/img/noimg.png'),
                                    fit: BoxFit.fill),
                          ),
                          child: const SizedBox(
                            width: 500,
                            height: 500,
                          ),
                        )),
                      ]))
                else
                  (imageFile.path.isNotEmpty)
                      ? Image.file(imageFile, fit: BoxFit.cover)
                      : Image.asset('assets/img/noimg.png', fit: BoxFit.cover),
              ]),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          body: (constraints.maxWidth > 800)
              ? Row(
                  children: [
                    Expanded(child: categoryListScreen()),
                    Container(width: 1.5, color: Colors.black),
                    Expanded(child: categoryEditScreen(showBackButton: false)),
                  ],
                )
              : TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [categoryListScreen(), categoryEditScreen()],
                ));
    });
  }
}
