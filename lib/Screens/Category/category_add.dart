import 'package:thai7merchant/struct/image_upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:thai7merchant/Screens/Category/category_list.dart';
import 'package:thai7merchant/bloc/category/category_bloc.dart';
import 'package:thai7merchant/components/appbar.dart';
import 'package:thai7merchant/components/background_main.dart';
import 'package:thai7merchant/components/textfield_input.dart';
import 'package:thai7merchant/Screens/Product/product_image.dart';
import 'package:thai7merchant/struct/category.dart';
import 'package:thai7merchant/util.dart';

class CategoryAdd extends StatefulWidget {
  final String? guidfixed;
  const CategoryAdd({Key? key, this.guidfixed = ""}) : super(key: key);

  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  ImageResponse? _picture;
  bool _reloadImage = false;
  bool createMode = true;
  String? _image;
  final _name1 = TextEditingController();
  final _name2 = TextEditingController();
  final _name3 = TextEditingController();
  final _name4 = TextEditingController();
  final _name5 = TextEditingController();

  bool _displayNewTextFieldName2 = false;
  bool _displayNewTextFieldName3 = false;
  bool _displayNewTextFieldName4 = false;
  bool _displayNewTextFieldName5 = false;

  @override
  void initState() {
    super.initState();
    widget.guidfixed.toString() != "" ? createMode = false : createMode = true;

    if (!createMode) {
      context
          .read<CategoryBloc>()
          .add(ListCategoryLoadById(id: widget.guidfixed.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // print(widget.guidfixed.toString());

    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategoryFormSaveInProgress &&
            state is CategoryUpdateInProgress &&
            state is CategoryDeleteInProgress) {
          context.loaderOverlay.show(widget: const ReconnectingOverlay());
        } else {
          context.loaderOverlay.hide();
        }

        if (state is CategoryLoadByIdLoadSuccess) {
          setState(() {
            _name1.text = state.category.name1;
            if (state.category.name2 != '') {
              _name2.text = state.category.name2;
              _displayNewTextFieldName2 = true;
            }
            if (state.category.name3 != '') {
              _name3.text = state.category.name3;
              _displayNewTextFieldName3 = true;
            }
            if (state.category.name4 != '') {
              _name4.text = state.category.name4;
              _displayNewTextFieldName4 = true;
            }
            if (state.category.name5 != '') {
              _name5.text = state.category.name5;
              _displayNewTextFieldName5 = true;
            }

            _image = state.category.image;
          });
        }

        if (state is CategoryDeleteSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const CategoryScreen(),
            ),
          );
        } else if (state is CategoryFormSaveSuccess) {
          // print('test save');
          showDeleteDialog('save');
        } else if (state is CategoryUpdateSuccess) {
          print('test update');
          showDeleteDialog('update');
        }
      },
      child: Scaffold(
        appBar: BaseAppBar(
          title: (createMode)
              ? const Text("เพิ่มหมวดหมู่สินค้า")
              : const Text("แก้ไขหมวดหมู่สินค้า"),
          leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const CategoryScreen()));
            },
          ),
          appBar: AppBar(),
          widgets: const <Widget>[],
        ),
        body: LoaderOverlay(
          overlayColor: Colors.black,
          overlayOpacity: 0.8,
          child: BackgroudMain(
            child: (Util.isLandscape(context))
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        // BlocBuilder<CategoryBloc, CategoryState>(
                        //   builder: (context, state) {
                        //     return (state is CategoryFormSaveFailure)
                        //         ? Text(
                        //             state.message,
                        //             style: const TextStyle(color: Colors.red),
                        //           )
                        //         : Container();
                        //   },
                        // ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: selectImage(),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: inputData(),
                              ),
                            ),
                          ],
                        ),
                        (!createMode)
                            ? Container(
                                width: double.infinity,
                                margin: const EdgeInsets.all(8.0),
                                child: ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                  label: const Text('ลบหมวดหมู่สินค้า'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 50,
                                      vertical: 20,
                                    ),
                                  ),
                                  onPressed: () {
                                    showDeleteDialog(
                                        widget.guidfixed.toString());
                                  },
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // BlocBuilder<CategoryBloc, CategoryState>(
                          //   builder: (context, state) {
                          //     return (state is CategoryFormSaveFailure)
                          //         ? Text(
                          //             state.message,
                          //             style: const TextStyle(color: Colors.red),
                          //           )
                          //         : Container();
                          //   },
                          // ),
                          inputData(),
                          selectImage(),
                          (!createMode)
                              ? Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.all(8.0),
                                  child: ElevatedButton.icon(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 24.0,
                                    ),
                                    label: const Text('ลบหมวดหมู่สินค้า'),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 50,
                                        vertical: 20,
                                      ),
                                    ),
                                    onPressed: () {
                                      showDeleteDialog(
                                          widget.guidfixed.toString());
                                    },
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Category _category = Category(
              name1: _name1.text,
              name2: _name2.text,
              name3: _name3.text,
              name4: _name4.text,
              name5: _name5.text,
              guidfixed: widget.guidfixed.toString(),
              image: _image,
            );

            if (createMode) {
              context
                  .read<CategoryBloc>()
                  .add(CategorySaved(category: _category));
            } else {
              context
                  .read<CategoryBloc>()
                  .add(CategoryUpdate(category: _category));
            }
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.save),
        ),
      ),
    );
  }

  Widget inputData() {
    return Card(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                (Util.isLandscape(context))
                    ? const Expanded(
                        flex: 1,
                        child: Text('หมวดหมู่สินค้า'),
                      )
                    : Container(),
                Expanded(
                  flex: 2,
                  child: TextFieldInput(
                    keyboardType: TextInputType.text,
                    controller: _name1,
                    labelText: 'หมวดหมู่สินค้า',
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 30.0,
                      icon: const Icon(Icons.add_circle_outline),
                      color: _displayNewTextFieldName2 == true
                          ? Colors.grey
                          : Colors.blue,
                      onPressed: () {
                        _displayNewTextFieldName2 != true
                            ? setState(() {
                                _displayNewTextFieldName2 = true;
                              })
                            : null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _displayNewTextFieldName2,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  (Util.isLandscape(context))
                      ? const Expanded(
                          flex: 1,
                          child: Text('หมวดหมู่สินค้า 2'),
                        )
                      : Container(),
                  Expanded(
                    flex: 2,
                    child: TextFieldInput(
                      controller: _name2,
                      keyboardType: TextInputType.text,
                      labelText: 'หมวดหมู่สินค้า 2',
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 30.0,
                            icon: const Icon(Icons.add_circle_outline),
                            color: _displayNewTextFieldName3 == true
                                ? Colors.grey
                                : Colors.blue,
                            onPressed: () {
                              _displayNewTextFieldName3 != true
                                  ? setState(() {
                                      _displayNewTextFieldName3 = true;
                                    })
                                  : null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 30.0,
                            icon: const Icon(Icons.remove_circle_outline),
                            color: Colors.red,
                            onPressed: () {
                              setState(() {
                                _name2.clear();
                                _displayNewTextFieldName2 = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: _displayNewTextFieldName3,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  (Util.isLandscape(context))
                      ? const Expanded(
                          flex: 1,
                          child: Text('หมวดหมู่สินค้า 3'),
                        )
                      : Container(),
                  Expanded(
                    flex: 2,
                    child: TextFieldInput(
                      controller: _name3,
                      keyboardType: TextInputType.text,
                      labelText: 'หมวดหมู่สินค้า 3',
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 30.0,
                            icon: const Icon(Icons.add_circle_outline),
                            color: _displayNewTextFieldName4 == true
                                ? Colors.grey
                                : Colors.blue,
                            onPressed: () {
                              _displayNewTextFieldName4 != true
                                  ? setState(() {
                                      _displayNewTextFieldName4 = true;
                                    })
                                  : null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 30.0,
                            icon: const Icon(Icons.remove_circle_outline),
                            color: Colors.red,
                            onPressed: () {
                              setState(() {
                                _name3.clear();
                                _displayNewTextFieldName3 = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _displayNewTextFieldName4,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  (Util.isLandscape(context))
                      ? const Expanded(
                          flex: 1,
                          child: Text('หมวดหมู่สินค้า 4'),
                        )
                      : Container(),
                  Expanded(
                    flex: 2,
                    child: TextFieldInput(
                      controller: _name4,
                      keyboardType: TextInputType.text,
                      labelText: 'หมวดหมู่สินค้า 4',
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 30.0,
                            icon: const Icon(Icons.add_circle_outline),
                            color: _displayNewTextFieldName5 == true
                                ? Colors.grey
                                : Colors.blue,
                            onPressed: () {
                              _displayNewTextFieldName5 != true
                                  ? setState(() {
                                      _displayNewTextFieldName5 = true;
                                    })
                                  : null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 30.0,
                            icon: const Icon(Icons.remove_circle_outline),
                            color: Colors.red,
                            onPressed: () {
                              setState(() {
                                _name4.clear();
                                _displayNewTextFieldName4 = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _displayNewTextFieldName5,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  (Util.isLandscape(context))
                      ? const Expanded(
                          flex: 1,
                          child: Text('หมวดหมู่สินค้า 5'),
                        )
                      : Container(),
                  Expanded(
                    flex: 2,
                    child: TextFieldInput(
                      controller: _name5,
                      keyboardType: TextInputType.text,
                      labelText: 'หมวดหมู่สินค้า 5',
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 30.0,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 30.0,
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Colors.red,
                        onPressed: () {
                          setState(() {
                            _name5.clear();
                            _displayNewTextFieldName5 = false;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget selectImage() {
    return Card(
      child: SizedBox(
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Text('เลือกรูปภาพ'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: _imageProduct(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageProduct() {
    return Center(
      child: Column(
        children: [
          (_image != '' && _image != null)
              ? Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                    child: Image.network(_image!.toString()),
                  ),
                  Positioned(
                    right: 0.0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _image = '';
                        });
                      },
                      child: const Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 18.0,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ])
              : IconButton(
                  padding: const EdgeInsets.all(2.0),
                  icon: const Icon(
                    Icons.add_photo_alternate_outlined,
                    color: Colors.teal,
                  ),
                  iconSize: MediaQuery.of(context).size.height * 0.15,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: ((builder) => _bottomSheet()),
                    );
                  },
                ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _addPhoto(
                  title: 'ถ่ายภาพ',
                  type: true,
                  icon: Icons.add_a_photo,
                ),
              ),
              Expanded(
                child: _addPhoto(
                  title: 'เลือกรูปภาพ',
                  type: false,
                  icon: Icons.photo_library,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _addPhoto({
    required bool type,
    required IconData icon,
    required String title,
  }) {
    return TextButton(
      onPressed: () async {
        final ImageUpload? result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductEditImageScreen(type),
          ),
        );
        _reloadImage = true;
        setState(() {
          if (result != null) {
            _image = result.uri;
          }
        });
      },
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            size: 50.0,
            color: Colors.blue[300],
          ),
          Text(title),
        ],
      ),
    );
  }

  Widget _bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          const Text(
            "เลือกรูปภาพ",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  final ImageUpload? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductEditImageScreen(true),
                    ),
                  );
                  _reloadImage = true;
                  setState(() {
                    if (result != null) {
                      _image = result.uri;
                    }
                  });
                },
                icon: Icon(Icons.add_a_photo),
                label: Text("ถ่ายภาพ"),
              ),
              TextButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  final ImageUpload? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductEditImageScreen(false),
                    ),
                  );
                  _reloadImage = true;
                  setState(() {
                    if (result != null) {
                      _image = result.uri;
                    }
                  });
                },
                icon: Icon(Icons.photo_library),
                label: Text("คลังรูปภาพ"),
              ),
            ],
          )
        ],
      ),
    );
  }

  void showDeleteDialog(String id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("ยกเลิก"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("ยืนยัน"),
      onPressed: () {
        if (id == 'save') {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const CategoryScreen(),
            ),
          );
        } else if (id == 'update') {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const CategoryScreen(),
            ),
          );
        } else {
          context.read<CategoryBloc>().add(CategoryDelete(id: id));
          Navigator.of(context).pop();
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("แจ้งเตือนระบบ"),
      content: (id == 'save')
          ? const Text("บันทึกหมวดหมู่สินค้าสำเร็จ!")
          : (id == 'update')
              ? const Text("แก้ไขหมวดหมู่สินค้าสำเร็จ?")
              : const Text("ต้องการลบหมวดหมู่สินค้าใช่หรือไม่?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
