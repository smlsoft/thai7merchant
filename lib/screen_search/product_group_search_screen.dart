import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thai7merchant/bloc/category/category_bloc.dart';
import 'package:thai7merchant/bloc/unit/unit_bloc.dart';
import 'package:thai7merchant/global.dart' as global;
import 'package:thai7merchant/model/category_model.dart';
import 'package:thai7merchant/model/global_model.dart';
import 'package:thai7merchant/model/product_struct.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({Key? key}) : super(key: key);

  @override
  State<ProductSearchScreen> createState() => ProductSearchScreenState();
}

class ProductSearchScreenState extends State<ProductSearchScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode(skipTraversal: true);
  ScrollController listScrollController = ScrollController();
  int loaDataPerPage = 40;
  String searchText = "";
  List<CategoryModel> categoryListDatas = [];
  bool isKeyUp = false;
  bool isKeyDown = false;
  String selectGuid = "";
  int currentListIndex = 0;

  @override
  void initState() {
    global.loadConfig();
    loadDataList("");
    super.initState();
  }

  void loadDataList(String search) {
    context.read<CategoryBloc>().add(CategoryLoadList(
        offset: (categoryListDatas.isEmpty) ? 0 : categoryListDatas.length,
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
    searchController.dispose();
    super.dispose();
  }

  Widget listScreen({bool mobileScreen = false}) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(global.language('product_unit')),
        leading: IconButton(
          focusNode: FocusNode(skipTraversal: true),
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Focus(
          focusNode: FocusNode(skipTraversal: true, canRequestFocus: true),
          onKey: (node, event) {
            if (kIsWeb) {
              if (event is RawKeyDownEvent) {
                if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                  isKeyDown = false;
                  int index = categoryListDatas.indexOf(
                      categoryListDatas.firstWhere(
                          (element) => element.guidfixed == selectGuid));
                  if (index > 0) {
                    selectGuid = categoryListDatas[index - 1].guidfixed;
                    currentListIndex = index + 1;
                    isKeyUp = true;
                  }
                }
                if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                  isKeyUp = false;
                  int index = categoryListDatas.indexOf(
                      categoryListDatas.firstWhere(
                          (element) => element.guidfixed == selectGuid));
                  selectGuid = categoryListDatas[index + 1].guidfixed;
                  currentListIndex = index + 1;
                  isKeyDown = true;
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
                        child: Text(global.language("guidfixed"),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 10,
                        child: Text(
                          global.language("category_name"),
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ])),
              Expanded(
                  child: SingleChildScrollView(
                      controller: listScrollController,
                      child: Column(
                          children: categoryListDatas
                              .map((value) => listObject(value))
                              .toList())))
            ],
          )),
    );
  }

  Widget listObject(CategoryModel value) {
    return GestureDetector(
        onTap: () {
          setState(() {
            SearchReturnValueModel returnValue = SearchReturnValueModel();
            returnValue.code = value.guidfixed;
            returnValue.names = value.names!;
            Navigator.pop(context, returnValue);
          });
        },
        child: Container(
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
                  child: Text(value.guidfixed,
                      maxLines: 2, overflow: TextOverflow.ellipsis)),
              Expanded(
                  flex: 10,
                  child: Text(
                    global.packName(value.names!),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(builder: (context, constraints) {
          return BlocListener<CategoryBloc, CategoryState>(
              listener: (context, state) {
                // Load
                if (state is CategoryLoadSuccess) {
                  setState(() {
                    if (state.categorys.isNotEmpty) {
                      categoryListDatas.addAll(state.categorys);
                      if (categoryListDatas.isNotEmpty) {
                        selectGuid = categoryListDatas[0].guidfixed;
                      } else {
                        selectGuid = "";
                      }
                    }
                  });
                }
              },
              child: (constraints.maxWidth > 800)
                  ? listScreen(mobileScreen: false)
                  : listScreen(mobileScreen: true));
        }));
  }
}
