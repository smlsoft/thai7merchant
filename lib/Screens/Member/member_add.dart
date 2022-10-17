import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:thai7merchant/screens/Member/member_list.dart';
import 'package:thai7merchant/screens/Product/product_image.dart';
import 'package:thai7merchant/bloc/member/member_bloc.dart';
import 'package:thai7merchant/components/appbar.dart';
import 'package:thai7merchant/components/background_main.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:thai7merchant/components/textfield_input.dart';
import 'package:thai7merchant/model/member.dart';
import 'package:thai7merchant/util.dart';

class MemberAdd extends StatefulWidget {
  final String? guidfixed;
  const MemberAdd({Key? key, this.guidfixed = ""}) : super(key: key);

  @override
  State<MemberAdd> createState() => _MemberAddState();
}

class _MemberAddState extends State<MemberAdd> {
  ImageResponse? _picture;
  bool _reloadImage = false;

  bool createMode = true;

  final address = TextEditingController();
  int branchcode = 0;
  int branchtype = 0;
  int personaltype = 0;
  final contacttype = TextEditingController();
  final name = TextEditingController();
  final surname = TextEditingController();
  final taxid = TextEditingController();
  final telephone = TextEditingController();
  final zipcode = TextEditingController();

  String _singleValue = "ผู้ซื้อ";

  @override
  void initState() {
    super.initState();
    widget.guidfixed.toString() != "" ? createMode = false : createMode = true;

    if (!createMode) {
      context
          .read<MemberBloc>()
          .add(ListMemberLoadById(id: widget.guidfixed.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<MemberBloc, MemberState>(
      listener: (context, state) {
        if (state is MemberFormSaveInProgress &&
            state is MemberUpdateInProgress &&
            state is MemberDeleteInProgress) {
          context.loaderOverlay.show(widget: const ReconnectingOverlay());
        } else {
          context.loaderOverlay.hide();
        }

        if (state is MemberLoadByIdLoadSuccess) {
          setState(() {
            telephone.text = state.member.telephone;
            name.text = state.member.name;
            surname.text = state.member.surname;
            address.text = state.member.address;
            zipcode.text = state.member.zipcode;
            if (state.member.personaltype == 0) {
              personaltype = 0;
            } else {
              personaltype = 1;
            }
          });
        } else if (state is MemberDeleteSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const MemberScreen(),
            ),
          );
        } else if (state is MemberFormSaveSuccess) {
          showDeleteDialog('save');
        } else if (state is MemberUpdateSuccess) {
          showDeleteDialog('update');
        }
      },
      child: Scaffold(
        appBar: BaseAppBar(
          title: (createMode)
              ? const Text("เพิ่มสมาชิก")
              : const Text("แก้ไขสมาชิก"),
          leading: IconButton(
              color: Colors.black,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const MemberScreen()));
              }),
          appBar: AppBar(),
          widgets: const <Widget>[],
        ),
        body: LoaderOverlay(
          overlayColor: Colors.black,
          overlayOpacity: 0.8,
          child: BackgroudMain(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BlocBuilder<MemberBloc, MemberState>(
                    builder: (context, state) {
                      return (state is MemberFormSaveFailure)
                          ? Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            )
                          : Container();
                    },
                  ),
                  inputName(),
                  inputAddress(),
                  // selectImage(),
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
                            label: const Text('ลบสมาชิก'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 20,
                              ),
                            ),
                            onPressed: () {
                              showDeleteDialog(widget.guidfixed.toString());
                            },
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Member _member = Member(
              guidfixed: widget.guidfixed.toString(),
              telephone: telephone.text,
              name: name.text,
              surname: surname.text,
              personaltype: personaltype,
              address: address.text,
              zipcode: zipcode.text,
              // set data
              branchtype: 0,
              contacttype: 0,
            );

            if (createMode) {
              context.read<MemberBloc>().add(MemberSaved(member: _member));
            } else {
              context.read<MemberBloc>().add(MemberUpdate(member: _member));
            }
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.save),
        ),
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
              child: const Align(
                alignment: Alignment.topLeft,
                child: Text('เลือกรูปภาพ'),
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
          IconButton(
            padding: const EdgeInsets.all(2.0),
            icon: (_picture != null)
                ? _picture!.image!
                : const Icon(
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
                child: TextButton(
                  onPressed: () async {
                    final ImageResponse? result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ProductEditImageScreen(true),
                      ),
                    );

                    _picture = result;
                    _reloadImage = true;
                    print(_picture);
                    setState(() {});
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.add_a_photo,
                        size: 50,
                        color: Colors.blue[300],
                      ),
                      Text("ถ่ายภาพ"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    final ImageResponse? result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ProductEditImageScreen(false),
                      ),
                    );
                    _picture = result;
                    _reloadImage = true;
                    setState(() {});
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.photo_library,
                        size: 50,
                        color: Colors.blue[300],
                      ),
                      Text("คลังรูปภาพ"),
                    ],
                  ),
                ),
              ),
            ],
          )
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () async {
                  Navigator.pop(context);

                  final ImageResponse? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductEditImageScreen(true),
                    ),
                  );

                  _picture = result;
                  _reloadImage = true;
                  setState(() {});
                },
                icon: const Icon(Icons.add_a_photo),
                label: const Text("ถ่ายภาพ"),
              ),
              TextButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductEditImageScreen(false),
                    ),
                  ) as ImageResponse;
                  _picture = result;
                  _reloadImage = true;
                  setState(() {});
                },
                icon: const Icon(Icons.photo_library),
                label: const Text("คลังรูปภาพ"),
              ),
            ],
          )
        ],
      ),
    );
  }

  void showDeleteDialog(String id) {
    // set up the buttons
    print(id);
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
              builder: (_) => const MemberScreen(),
            ),
          );
        } else {
          context.read<MemberBloc>().add(MemberDelete(id: id));
          Navigator.of(context).pop();
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("แจ้งเตือนระบบ"),
      content: (id == 'save')
          ? const Text("บันทึกสมาชิกสำเร็จ!")
          : (id == 'update')
              ? const Text("แก้ไขสมาชิกสำเร็จ?")
              : const Text("ต้องการลบสมาชิกใช่หรือไม่?"),
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

  Widget inputAddress() {
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
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text('ที่อยู่'),
                        ),
                      )
                    : Container(),
                Expanded(
                  flex: 2,
                  child: TextFieldInput(
                    keyboardType: TextInputType.text,
                    controller: address,
                    labelText: 'ที่อยู่',
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                (Util.isLandscape(context))
                    ? const Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text('รหัสไปรษณีย์'),
                        ),
                      )
                    : Container(),
                Expanded(
                  flex: 2,
                  child: TextFieldInput(
                    keyboardType: TextInputType.text,
                    controller: zipcode,
                    labelText: 'รหัสไปรษณีย์',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget inputName() {
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
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text('เบอร์โทรศัพท์'),
                        ),
                      )
                    : Container(),
                Expanded(
                  flex: 3,
                  child: TextFieldInput(
                    keyboardType: TextInputType.number,
                    controller: telephone,
                    labelText: 'เบอร์โทรศัพท์',
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                (Util.isLandscape(context))
                    ? const Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text('ชื่อ'),
                        ),
                      )
                    : Container(),
                Expanded(
                  flex: 2,
                  child: TextFieldInput(
                    keyboardType: TextInputType.text,
                    controller: name,
                    labelText: 'ชื่อ',
                  ),
                ),
                (Util.isLandscape(context))
                    ? const Expanded(
                        flex: 1,
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Text('นามสกุล')),
                      )
                    : const SizedBox(
                        width: 5,
                      ),
                Expanded(
                  flex: 2,
                  child: TextFieldInput(
                    keyboardType: TextInputType.text,
                    controller: surname,
                    labelText: 'นามสกุล',
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              RadioButton(
                description: "ผู้ซื้อ",
                value: 0,
                groupValue: personaltype,
                onChanged: (value) {
                  setState(() {
                    personaltype = 0;
                  });
                },
              ),
              RadioButton(
                description: "ผู้ขาย",
                value: 1,
                groupValue: personaltype,
                activeColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    personaltype = 1;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
