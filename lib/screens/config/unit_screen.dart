import 'dart:developer';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:thai7merchant/bloc/unit/unit_bloc.dart';
import 'package:thai7merchant/global.dart' as global;
import 'package:input_history_text_field/input_history_text_field.dart';
import 'package:thai7merchant/model/language_mode.dart';
import 'package:thai7merchant/model/unit.dart';

class UnitScreen extends StatefulWidget {
  const UnitScreen({Key? key}) : super(key: key);

  @override
  State<UnitScreen> createState() => UnitScreenState();
}

class UnitScreenState extends State<UnitScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  FocusNode codeFocusNode = FocusNode();
  ScrollController editScrollController = ScrollController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final List<TextEditingController> nameController = [];
  List<String> fieldName = [];
  List<FocusNode> nameFocusNode = [];
  String guidfixed = "";
  List<UnitModel> _unit = [];
  List<LanguageMode> _names = [];
  final ScrollController _scrollController = ScrollController();
  int _perPage = 15;
  String _search = "";

  @override
  void initState() {
    global.loadConfig();
    tabController = TabController(vsync: this, length: 2);
    for (int i = 0; i < global.config.languages.length; i++) {
      nameController.add(TextEditingController());
      nameFocusNode.add(FocusNode());
      fieldName.add("name${i + 1}");
    }

    context.read<UnitBloc>().add(ListUnitLoad(
        page: 0, perPage: _perPage, search: _search, nextPage: true));
    _scrollController.addListener(_onScroll);

    super.initState();
  }

  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      UnitBloc unitBloc = context.read<UnitBloc>();
      UnitLoadSuccess unitLoadSuccess;

      if (unitBloc.state is UnitLoadSuccess) {
        unitLoadSuccess = (unitBloc.state as UnitLoadSuccess);
        if (unitLoadSuccess.page!.page < unitLoadSuccess.page!.totalPage) {
          unitBloc.add(ListUnitLoad(
              page: unitLoadSuccess.page!.page + 1,
              perPage: _perPage,
              search: _search,
              nextPage: false));
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    tabController.dispose();
    codeFocusNode.dispose();
    editScrollController.dispose();
    codeController.dispose();
    searchController.dispose();
    for (int i = 0; i < nameController.length; i++) {
      nameController[i].dispose();
      nameFocusNode[i].dispose();
    }
    super.dispose();
  }

  Widget listScreen() {
    return BlocListener<UnitBloc, UnitState>(
      listener: (context, state) {
        if (state is UnitLoadSuccess) {
          if (state.unit.isNotEmpty) {
            _unit = state.unit;
          }
        }
        if (state is UnitDeleteSuccess) {
          context.read<UnitBloc>().add(ListUnitLoad(
              page: 0, perPage: _perPage, search: _search, nextPage: true));
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('หน่วยนับสินค้า'),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      log("22222");
                      setState(() {});
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
                      codeFocusNode.requestFocus();
                    },
                    child: const Icon(
                      Icons.add,
                      size: 26.0,
                    ),
                  )),
            ],
          ),
          body: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: InputHistoryTextField(
                      textEditingController: searchController,
                      historyKey: "unit",
                      listStyle: ListStyle.Badge,
                      showHistoryIcon: false,
                      backgroundColor: Colors.lightBlue,
                      textColor: Colors.white,
                      deleteIconColor: Colors.white,
                      decoration: const InputDecoration(
                        hintText: 'ค้นหา',
                      ))),
              Expanded(
                child: BlocBuilder<UnitBloc, UnitState>(
                  builder: (context, state) {
                    return (state is UnitInProgress)
                        ? Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          )
                        : (state is UnitLoadSuccess)
                            ? ListView.builder(
                                itemCount: _unit.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text("${_unit[index].unitcode}"),
                                    onTap: () {
                                      setState(() {});
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title:
                                              const Text('AlertDialog Title'),
                                          content: const Text(
                                              'AlertDialog description'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                context.read<UnitBloc>().add(
                                                    ListUnitDelete(
                                                        id: _unit[index]
                                                            .guidfixed));
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );

                                      context.read<UnitBloc>().add(ListUnitLoad(
                                          page: 0,
                                          perPage: _perPage,
                                          search: _search,
                                          nextPage: true));
                                      log(_unit[index].guidfixed);
                                    },
                                  );
                                },
                              )
                            : (state is UnitLoadFailed)
                                ? const Text(
                                    'ไม่เจอข้อมูล',
                                    style: TextStyle(fontSize: 24),
                                  )
                                : Container();
                  },
                ),
              ),
            ],
          )),
    );
  }

  void saveData() {
    // context.read<UnitBloc>().add(ListUnitLoad(
    //     page: 0, perPage: _perPage, search: _search, nextPage: true));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 1),
        content: (Row(
          children: const [
            Icon(
              Icons.save,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text("บันทึกสำเร็จ")
          ],
        ))));
    context.read<UnitBloc>().add(ListUnitLoad(
        page: 0, perPage: _perPage, search: _search, nextPage: true));
  }

  Widget editScreen({showBackButton = true}) {
    return Scaffold(
        appBar: AppBar(
            leading: showBackButton
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      tabController.index = 0;
                    },
                  )
                : null,
            title: const Text('หน่วยนับสินค้า'),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      saveData();
                    },
                    child: const Icon(
                      Icons.save,
                      size: 26.0,
                    ),
                  ))
            ]),
        body: SingleChildScrollView(
            controller: editScrollController,
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  TextField(
                      focusNode: codeFocusNode,
                      textAlign: TextAlign.left,
                      controller: codeController,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp('[a-z A-Z 0-9]'))
                      ],
                      onChanged: (value) {
                        codeController.value = TextEditingValue(
                            text: value.toUpperCase(),
                            selection: codeController.selection);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "รหัสหน่วยนับ",
                      )),
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
                                "ชื่อหน่วยนับสินค้า (${global.config.languages[i].name})",
                          ),
                        ),
                      ),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                          onPressed: () {
                            for (int i = 0;
                                i < global.config.languages.length;
                                i++) {
                              if (global.config.languages[i].use) {
                                _names.add(LanguageMode(
                                  code: global.config.languages[i].code,
                                  name: nameController[i].text,
                                ));
                              }
                            }

                            UnitModel _unitModel = UnitModel(
                              guidfixed: guidfixed,
                              unitcode: codeController.text,
                              names: _names,
                            );
                            context
                                .read<UnitBloc>()
                                .add(ListUnitSave(unitModel: _unitModel));

                            saveData();
                          },
                          icon: const Icon(Icons.save),
                          label: const Text("บันทึก")))
                ]))));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          body: (constraints.maxWidth > 800)
              ? Row(
                  children: [
                    Expanded(child: listScreen()),
                    Container(width: 1.5, color: Colors.black),
                    Expanded(child: editScreen(showBackButton: false)),
                  ],
                )
              : TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [listScreen(), editScreen()],
                ));
    });
  }
}
