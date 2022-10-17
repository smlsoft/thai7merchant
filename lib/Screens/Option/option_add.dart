import 'package:thai7merchant/screens/Option/option_detail.dart';
import 'package:thai7merchant/screens/Option/option_list.dart';
import 'package:thai7merchant/bloc/option/option_bloc.dart';
import 'package:thai7merchant/model/choices.dart';
import 'package:thai7merchant/model/option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:thai7merchant/components/appbar.dart';
import 'package:thai7merchant/components/background_main.dart';
import 'package:thai7merchant/components/textfield_input.dart';
import 'package:thai7merchant/util.dart';
import 'package:uuid/uuid.dart';

class OptionAdd extends StatefulWidget {
  final String? guidfixed;
  const OptionAdd({Key? key, this.guidfixed = ""}) : super(key: key);

  @override
  State<OptionAdd> createState() => _OptionAddState();
}

class _OptionAddState extends State<OptionAdd> {
  bool createMode = true;

  // from
  final _formKey = GlobalKey<FormState>();
  String? _uuid;
  final _name1 = TextEditingController();
  final _name2 = TextEditingController();
  final _name3 = TextEditingController();
  final _name4 = TextEditingController();
  final _name5 = TextEditingController();
  final _maxselected = TextEditingController();

  bool _displayNewTextFieldName2 = false;
  bool _displayNewTextFieldName3 = false;
  bool _displayNewTextFieldName4 = false;
  bool _displayNewTextFieldName5 = false;
  bool _isRequired = true;

  bool _ismaxselected = false;

  List<Choices> _optionChoices = <Choices>[];

  int _choiceType = 0;

  @override
  void initState() {
    super.initState();
    widget.guidfixed.toString() != "" ? createMode = false : createMode = true;

    if (!createMode) {
      context
          .read<OptionBloc>()
          .add(ListOptionLoadById(id: widget.guidfixed.toString()));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<OptionBloc, OptionState>(
      listener: (context, state) {
        if (state is OptionLoadByIdInProgress) {
          context.loaderOverlay.show(widget: const ReconnectingOverlay());
        } else if (state is OptionLoadByIdLoadSuccess) {
          context.loaderOverlay.hide();
          setState(() {
            _uuid = state.option.code;
            _name1.text = state.option.name1;
            if (state.option.name2 != '') {
              _name2.text = state.option.name2;
              _displayNewTextFieldName2 = true;
            }
            if (state.option.name3 != '') {
              _name3.text = state.option.name3;
              _displayNewTextFieldName3 = true;
            }
            if (state.option.name4 != '') {
              _name4.text = state.option.name4;
              _displayNewTextFieldName4 = true;
            }
            if (state.option.name5 != '') {
              _name5.text = state.option.name5;
              _displayNewTextFieldName5 = true;
            }

            if (state.option.isrequired == true) {
              _isRequired = true;
            } else {
              _isRequired = false;
            }

            if (state.option.choicetype == 0) {
              _choiceType = 0;
            } else {
              _choiceType = 1;
              _ismaxselected = true;
              _maxselected.text = state.option.maxselect.toString();
            }

            if (state.option.choices.isNotEmpty) {
              _optionChoices = state.option.choices;
            }
          });
        }

        if (state is OptionSaveInProgress) {
          context.loaderOverlay.show(widget: const ReconnectingOverlay());
        } else if (state is OptionSaveSuccess) {
          context.loaderOverlay.hide();
          showDeleteDialog('save');
        }

        if (state is OptionUpdateInProgress) {
          context.loaderOverlay.show(widget: const ReconnectingOverlay());
        } else if (state is OptionUpdateSuccess) {
          context.loaderOverlay.hide();
          showDeleteDialog('update');
        }

        if (state is OptionDeleteSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const OptionScreen(),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: BaseAppBar(
          title: (createMode)
              ? const Text("เพิ่มตัวเลือกเสริม")
              : const Text("แก้ไขตัวเลือกเสริม"),
          leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const OptionScreen()));
            },
          ),
          appBar: AppBar(),
          widgets: const <Widget>[],
        ),
        body: LoaderOverlay(
          overlayColor: Colors.black,
          overlayOpacity: 0.8,
          child: BackgroudMain(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: _name1,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelText: 'ชื่อกลุ่มตัวเลือก 1',
                                  isDense: true,
                                  contentPadding: const EdgeInsets.all(10),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณาระบุ ชื่อกลุ่มตัวเลือก';
                                  }
                                  return null;
                                },
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

                        Visibility(
                          visible: _displayNewTextFieldName2,
                          child: Container(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextFieldInput(
                                    controller: _name2,
                                    keyboardType: TextInputType.text,
                                    labelText: 'ชื่อกลุ่มตัวเลือก 2',
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        height: 30.0,
                                        width: 30.0,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          iconSize: 30.0,
                                          icon: const Icon(
                                              Icons.add_circle_outline),
                                          color:
                                              _displayNewTextFieldName3 == true
                                                  ? Colors.grey
                                                  : Colors.blue,
                                          onPressed: () {
                                            _displayNewTextFieldName3 != true
                                                ? setState(() {
                                                    _displayNewTextFieldName3 =
                                                        true;
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
                                          icon: const Icon(
                                              Icons.remove_circle_outline),
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
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextFieldInput(
                                    controller: _name3,
                                    keyboardType: TextInputType.text,
                                    labelText: 'ชื่อกลุ่มตัวเลือก 3',
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        height: 30.0,
                                        width: 30.0,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          iconSize: 30.0,
                                          icon: const Icon(
                                              Icons.add_circle_outline),
                                          color:
                                              _displayNewTextFieldName4 == true
                                                  ? Colors.grey
                                                  : Colors.blue,
                                          onPressed: () {
                                            _displayNewTextFieldName4 != true
                                                ? setState(() {
                                                    _displayNewTextFieldName4 =
                                                        true;
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
                                          icon: const Icon(
                                              Icons.remove_circle_outline),
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
                                )
                              ],
                            ),
                          ),
                        ),

                        Visibility(
                          visible: _displayNewTextFieldName4,
                          child: Container(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextFieldInput(
                                    controller: _name4,
                                    keyboardType: TextInputType.text,
                                    labelText: 'ชื่อกลุ่มตัวเลือก 4',
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        height: 30.0,
                                        width: 30.0,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          iconSize: 30.0,
                                          icon: const Icon(
                                              Icons.add_circle_outline),
                                          color:
                                              _displayNewTextFieldName5 == true
                                                  ? Colors.grey
                                                  : Colors.blue,
                                          onPressed: () {
                                            _displayNewTextFieldName5 != true
                                                ? setState(() {
                                                    _displayNewTextFieldName5 =
                                                        true;
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
                                          icon: const Icon(
                                              Icons.remove_circle_outline),
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
                                )
                              ],
                            ),
                          ),
                        ),

                        Visibility(
                          visible: _displayNewTextFieldName5,
                          child: Container(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextFieldInput(
                                    controller: _name5,
                                    keyboardType: TextInputType.text,
                                    labelText: 'ชื่อกลุ่มตัวเลือก 5',
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 30.0,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      iconSize: 30.0,
                                      icon: const Icon(
                                          Icons.remove_circle_outline),
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

                        SizedBox(height: size.height * 0.03),
                        // Widget
                        const TitleLabel(
                          title: "ตัวเลือก",
                          subtitle: "เช่น เยลลี่, ขนาดใหญ่, น้ำตาล 50%",
                        ),
                        SizedBox(height: size.height * 0.03),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              var _result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OptionDetailScreen(
                                    choices: Choices(
                                        isdefault: true, selected: false),
                                  ),
                                ),
                              );

                              if (_result != null) {
                                _optionChoices.add(_result);
                              }
                            },
                            child: const Text('เพิ่มตัวเลือกย่อย'),
                          ),
                        ),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _optionChoices.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Align(
                                  alignment: Alignment.center,
                                  child: Text(_optionChoices[index].barcode),
                                ),
                                subtitle: Column(
                                  children: [
                                    Text(
                                        "ชื่อ 1 :  ${_optionChoices[index].name1} "),
                                    // Text("ชื่อ 2 :  ${_optionChoices[index].name2} "),
                                    // Text("ชื่อ 3 :  ${_optionChoices[index].name3} "),
                                    // Text("ชื่อ 4 :  ${_optionChoices[index].name4} "),
                                    // Text("ชื่อ 5 :  ${_optionChoices[index].name5} "),
                                    Text(
                                        "ราคา : + ${_optionChoices[index].price} บาท"),
                                    // Text("จำนวน :  ${_optionChoices[index].qty} "),
                                    // Text(
                                    //     "จำนวนสูงสุด :  ${_optionChoices[index].qtymax} "),
                                    // Text(
                                    //     "รหัสแนะนำ :  ${_optionChoices[index].suggestcode} "),
                                    // Text(
                                    //     "หน่วยนับ :  ${_optionChoices[index].itemunit} "),
                                    // Text(
                                    //     "เลือกให้เลย :  ${_optionChoices[index].selected} "),
                                    // Text(
                                    //     "ค่าเริ่มต้น :  ${_optionChoices[index].isdefault} "),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton.icon(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 24.0,
                                        ),
                                        label: const Text('ลบตัวเลือกย่อย'),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 15,
                                          ),
                                        ),
                                        onPressed: () {
                                          _optionChoices.removeAt(index);
                                          setState(() {
                                            _optionChoices = _optionChoices;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                trailing: const Icon(
                                    Icons.keyboard_arrow_right_sharp),
                                onTap: () async {
                                  var _result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OptionDetailScreen(
                                          choices: _optionChoices[index]),
                                    ),
                                  );

                                  if (_result != null) {
                                    _optionChoices[index] = _result;
                                  }
                                },
                              ),
                            );
                          },
                        ),

                        SizedBox(height: size.height * 0.03),
                        // Widget
                        const TitleLabel(
                          title: "รายละเอียดตัวเลือก",
                          subtitle:
                              "เช่น ต้องเลือกอย่างน้อย 1 อย่าง, ไม่บังคับ",
                        ),
                        SizedBox(height: size.height * 0.03),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(2.0),
                            child: const Text(
                              "ลูกค้าจำเป็นต้องเลือกตัวเลือกนี้หรือไม่ ?",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            RadioButton(
                                description: "จำเป็นต้องเลือก",
                                value: true,
                                groupValue: _isRequired,
                                onChanged: (value) {
                                  setState(() {
                                    _isRequired = true;
                                  });
                                }),
                            RadioButton(
                                description: "ไม่บังคับ",
                                value: false,
                                groupValue: _isRequired,
                                activeColor: Colors.red,
                                onChanged: (value) {
                                  setState(() {
                                    _isRequired = false;
                                  });
                                }),
                          ],
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(2.0),
                            child: const Text(
                              "ลูกค้าสามารถเลือกตัวเลือกย่อยได้กี่อย่าง ?",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),

                        Column(
                          children: [
                            RadioButton(
                                description: "1 อย่างเท่านั้น",
                                value: 0,
                                groupValue: _choiceType,
                                onChanged: (value) {
                                  setState(() {
                                    _choiceType = 0;
                                    _ismaxselected = false;
                                    _maxselected.text = "0";
                                  });
                                }),
                            RadioButton(
                                description: "หลายอย่าง",
                                value: 1,
                                groupValue: _choiceType,
                                onChanged: (value) {
                                  setState(() {
                                    _choiceType = 1;
                                    _ismaxselected = true;
                                  });
                                }),
                            Visibility(
                              visible: _ismaxselected,
                              child: Container(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: TextFormField(
                                  controller: _maxselected,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    labelText: 'เลือกได้สูงสุด',
                                    isDense: true,
                                    contentPadding: const EdgeInsets.all(10),
                                  ),
                                ),
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
                                  label: const Text('ลบข้อมูลตัวเลือกเสริม'),
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
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_maxselected.text == '') {
              _maxselected.text = "0";
            }

            Option _option = Option(
              guidfixed: widget.guidfixed.toString(),
              code: _uuid.toString(),
              name1: _name1.text,
              name2: _name2.text,
              name3: _name3.text,
              name4: _name4.text,
              name5: _name5.text,
              choicetype: _choiceType,
              maxselect: int.parse(_maxselected.text),
              isrequired: _isRequired,
              choices: _optionChoices,
            );

            if (createMode) {
              context.read<OptionBloc>().add(OptionSaved(option: _option));
            } else {
              context.read<OptionBloc>().add(OptionUpdate(option: _option));
            }
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.save),
        ),
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
        if (id == 'save' || id == 'update') {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const OptionScreen(),
            ),
          );
        } else {
          context.read<OptionBloc>().add(OptionDelete(id: id));
          Navigator.of(context).pop();
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("แจ้งเตือนระบบ"),
      content: (id == 'save')
          ? const Text("บันทึก ตัวเลือกเสริม สำเร็จ!")
          : (id == 'update')
              ? const Text("แก้ไข ตัวเลือกเสริม สำเร็จ!")
              : const Text("ต้องการลบ ตัวเลือกเสริม ใช่หรือไม่?"),
      actions: [
        // cancelButton,
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

class TitleLabel extends StatelessWidget {
  final String title;
  final String subtitle;
  const TitleLabel({
    Key? key,
    required this.title,
    this.subtitle = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}
