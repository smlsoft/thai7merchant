// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:thai7merchant/screens/receive/receivelist.dart';
import 'package:thai7merchant/bloc/list_shop/list_shop_bloc.dart';
import 'package:thai7merchant/bloc/login_bloc/login_bloc.dart';
import 'package:thai7merchant/bloc/shop_select/shop_select_bloc.dart';
import 'package:thai7merchant/model/shop.dart';
import 'package:thai7merchant/util.dart';

import '../screens/Dashboard/dashboard_screen.dart';

class LoginShop extends StatefulWidget {
  const LoginShop({Key? key}) : super(key: key);

  @override
  State<LoginShop> createState() => _LoginShopState();
}

class _LoginShopState extends State<LoginShop> {
  bool _isLoaderVisible = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userControl = TextEditingController();
  final TextEditingController _passControl = TextEditingController();
  bool _isListShop = false;
  bool _isListShopNotFound = false;
  @override
  void initState() {
    _userControl.text = "tester";
    _passControl.text = "tester";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: Colors.black,
      overlayOpacity: 0.8,
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  colors: [
                Color(0xFFF88975),
                Color(0xFFF56045),
              ])),
          child: MultiBlocListener(
            listeners: [
              BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    if (state.userLogin.token != '') {
                      context.read<ListShopBloc>().add(ListShopLoad());
                    }
                  }
                },
              ),
              BlocListener<ListShopBloc, ListShopState>(
                listener: (context, state) {
                  if (state is ListShopLoadSuccess) {
                    print(state.shop.length);
                    if (state.shop.length > 0) {
                      setState(() {
                        _isListShop = true;
                      });
                    } else {
                      setState(() {
                        _isListShopNotFound = true;
                      });
                    }
                  }
                },
              ),
              BlocListener<ShopSelectBloc, ShopSelectState>(
                listener: (context, state) {
                  if (state is ShopSelectLoadSuccess) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => DashboardScreen()));
                  }
                },
              ),
            ],
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: (_isListShop) ? listShopSelect() : loginShop(),
            ),
          ),
        ),
      ),
    );
  }

  Widget listShopSelect() {
    return Align(
      child: Card(
        color: Colors.grey.shade200,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Container(
            width: 600,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  child: const Text(
                    "Select Shop ",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: BlocBuilder<ListShopBloc, ListShopState>(
                    builder: (context, state) {
                      return (state is ListShopLoadSuccess)
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: state.shop.length,
                              itemBuilder: (BuildContext context, int index) {
                                return cardItem(state.shop[index]);
                              })
                          : Container();
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget cardItem(Shop data) {
    return Card(
        elevation: 3,
        child: ListTile(
            onTap: (() {
              context.read<ShopSelectBloc>().add(OnShopSelect(shop: data));
            }),
            title: Text(
              data.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )));
  }

  Widget loginShop() {
    return Align(
      child: Card(
        color: Colors.grey.shade200,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: SizedBox(
          width: 600,
          height: 500,
          child: loginForm(),
        ),
      ),
    );
  }

  Widget loginForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 8,
            vertical: MediaQuery.of(context).size.height / 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/img/vficon.png",
              height: 140,
            ),
            const SizedBox(
              height: 25,
            ),
            usernameField(),
            const SizedBox(
              height: 10,
            ),
            passwordField(),
            const SizedBox(
              height: 10,
            ),
            loginButton(),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginInProgress) {
                  context.loaderOverlay
                      .show(widget: const ReconnectingOverlay());
                } else {
                  context.loaderOverlay.hide();
                }
                return (state is LoginFailed)
                    ? Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      )
                    : Container();
              },
            ),
            BlocBuilder<ListShopBloc, ListShopState>(
              builder: (context, state) {
                if (state is ListShopLoadFailed) {
                  return Text(
                    'ERROR SHOP ' + state.message,
                    style: const TextStyle(color: Colors.red),
                  );
                }
                return Container();
              },
            ),
            _isListShopNotFound
                ? const Text(
                    'Shop Not Found',
                    style: TextStyle(color: Colors.red),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget usernameField() {
    return Container(
      height: 60,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: _userControl,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.person,
              color: Color(0xff4c5166),
            ),
            hintText: 'ชื่อผู้ใช้',
            hintStyle: TextStyle(color: Colors.black38)),
      ),
    );
  }

  Widget passwordField() {
    return Container(
      height: 60,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: _passControl,
        obscureText: true,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.security,
              color: Color(0xff4c5166),
            ),
            hintText: 'รหัสผ่าน',
            hintStyle: TextStyle(color: Colors.black38)),
      ),
    );
  }

  Widget loginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => DashboardScreen()),
            // );

            context.read<LoginBloc>().add(LoginOnLoad(
                userName: _userControl.text, passWord: _passControl.text));
          },
          child: const Text(
            "เข้าสู่ระบบ",
            style: TextStyle(
                fontSize: 19, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void showSncakBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
