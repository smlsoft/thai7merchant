import 'package:thai7merchant/components/singin_button.dart';
import 'package:thai7merchant/usersystem/create_shop.dart';
import 'package:thai7merchant/usersystem/login_shop.dart';
import 'package:thai7merchant/usersystem/registration.dart';
import 'package:flutter/material.dart';

class LoginWith extends StatelessWidget {
  const LoginWith({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: <Widget>[
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: const FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      "Thai7 Merchant",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          inherit: true,
                          fontSize: 48.0,
                          color: Colors.blue,
                          shadows: [
                            Shadow(
                                // bottomLeft
                                offset: Offset(-1.5, -1.5),
                                color: Colors.white),
                            Shadow(
                                // bottomRight
                                offset: Offset(1.5, -1.5),
                                color: Colors.white),
                            Shadow(
                                // topRight
                                offset: Offset(1.5, 1.5),
                                color: Colors.white),
                            Shadow(
                                // topLeft
                                offset: Offset(-1.5, 1.5),
                                color: Colors.white),
                          ]),
                    ),
                  ))),
          Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
            child: SingInButton(
              labelText: 'Sing in with Line',
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginShop(),
                  ),
                );
              },
              img: const AssetImage("assets/img/line_logo.png"),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
            child: SingInButton(
              labelText: 'Sing in with Google',
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginShop(),
                  ),
                );
              },
              img: const AssetImage("assets/img/google_logo.png"),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
            child: SingInButton(
              labelText: 'Sing in with Facebook',
              press: () {},
              img: const AssetImage("assets/img/facebook_logo.png"),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
            child: SingInButton(
              labelText: 'Sing in with Apple ID',
              press: () {},
              img: const AssetImage("assets/img/apple_logo.png"),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
            child: SingInButton(
              labelText: 'Sing in with Phone Number',
              press: () {},
              img: const AssetImage("assets/img/apple_logo.png"),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
            child: SingInButton(
              labelText: 'ลงทะเบียนใหม่',
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistrationScreen(),
                  ),
                );
              },
              img: const AssetImage("assets/img/avatar.png"),
            ),
          ),
        ],
      ),
    ));
  }
}
