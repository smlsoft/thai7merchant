import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:thai7merchant/Screens/Category/category_add.dart';
import 'package:thai7merchant/bloc/category/category_bloc.dart';
import 'package:thai7merchant/components/background_main.dart';
import 'package:thai7merchant/components/textfield_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thai7merchant/struct/category.dart';
import 'package:thai7merchant/util.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Category> _category = [];

  final ScrollController _scrollController = ScrollController();

  int _perPage = 15;
  String _search = "";

  @override
  initState() {
    super.initState();
    context.read<CategoryBloc>().add(ListCategoryLoad(
        page: 0, perPage: _perPage, search: _search, nextPage: true));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      CategoryBloc categoryBloc = context.read<CategoryBloc>();
      CategoryLoadSuccess categoryLoadSuccess;

      if (categoryBloc.state is CategoryLoadSuccess) {
        categoryLoadSuccess = (categoryBloc.state as CategoryLoadSuccess);
        if (categoryLoadSuccess.page!.page <
            categoryLoadSuccess.page!.totalPage) {
          categoryBloc.add(ListCategoryLoad(
              page: categoryLoadSuccess.page!.page + 1,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return MultiBlocListener(
      listeners: [
        BlocListener<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state is CategoryLoadSuccess) {
              if (state.category.isNotEmpty) {
                _category = state.category;
              }
            }
          },
        ),
      ],
      child: BackgroudMain(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                child: TextFieldSearch(
                  onChange: (value) {},
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Expanded(
                        child: BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (context, state) {
                            return (state is CategoryInProgress)
                                ? Container(
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: const CircularProgressIndicator(),
                                  )
                                : (state is CategoryLoadSuccess)
                                    ? GridView.builder(
                                        controller: _scrollController,
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: _category.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 1,
                                          crossAxisCount:
                                              (Util.isLandscape(context))
                                                  ? 5
                                                  : 2,
                                          crossAxisSpacing: 4.0,
                                          mainAxisSpacing: 4.0,
                                          mainAxisExtent: 160,
                                        ),
                                        itemBuilder: (context, index) {
                                          return Card(
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CategoryAdd(
                                                        guidfixed: state
                                                            .category[index]
                                                            .guidfixed,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Column(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 100,
                                                      child: Image.asset(
                                                          "assets/img/vficon.png",
                                                          fit: BoxFit.fill),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              _category[index]
                                                                  .name1,
                                                              // text 1 line
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : (state is CategoryLoadFailed)
                                        ? const Text(
                                            'ไม่เจอข้อมูล',
                                            style: TextStyle(fontSize: 24),
                                          )
                                        : Container();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
