import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class CategorySelectScreen extends StatefulWidget {
  const CategorySelectScreen({Key? key}) : super(key: key);

  @override
  State<CategorySelectScreen> createState() => CategorySelectScreenState();
}

class CategorySelectScreenState extends State<CategorySelectScreen>
    with SingleTickerProviderStateMixin {
  List<CategoryListModel> rootCategorys = [];
  List<Widget> listColumns = [];
  ScrollController listScrollController = ScrollController();
  ScrollController editScrollController = ScrollController();
  bool needScroll = false;

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

  void loadDataList(String search) {
    context
        .read<CategoryBloc>()
        .add(CategoryLoadList(offset: 0, limit: 100000, search: search));
  }

  Widget categoryDetail(int level, CategoryListModel category) {
    return Container(
        padding: const EdgeInsets.all(4),
        width: double.infinity,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: level * 10,
            ),
            Expanded(
              child: Text(category.detail.names[0].name,
                  style: const TextStyle(fontSize: 18)),
            ),
            if (category.childCategorys.isNotEmpty)
              IconButton(
                icon: Icon((category.isExpand)
                    ? Icons.expand_less
                    : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    category.isExpand = !category.isExpand;
                  });
                },
              ),
          ],
        ));
  }

  @override
  void initState() {
    global.loadConfig();
    loadDataList("");
    super.initState();
  }

  @override
  void dispose() {
    listScrollController.dispose();
    super.dispose();
  }

  Widget categoryListScreen() {
    for (var item in rootCategorys) {
      listColumns.add(InkWell(
          onTap: () {
            Navigator.pop(context, item.detail.guidfixed);
          },
          child: categoryDetail(0, item)));
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(global.language('product_group')),
        ),
        body: SingleChildScrollView(
          controller: listScrollController,
          child: Column(children: listColumns),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(builder: (context, constraints) {
          return BlocListener<CategoryBloc, CategoryState>(
              listener: (context, state) {
                if (state is CategoryLoadSuccess) {
                  setState(
                    () {
                      rootCategorys.clear();
                      for (var item in state.categorys) {
                        rootCategorys.add(CategoryListModel(
                            detail: item, childCategorys: []));
                      }
                    },
                  );
                }
              },
              child: categoryListScreen());
        }));
  }
}
