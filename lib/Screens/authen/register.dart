import 'package:dedeauthen/dedeauthen.dart';
import 'package:thai7merchant/Screens/authen/login.dart';
import 'package:thai7merchant/Screens/authen/telephone_screen.dart';
import 'package:thai7merchant/app_const.dart';
import 'package:thai7merchant/components/singin_button.dart';

import 'package:flutter/material.dart';
import 'package:thai7merchant/global.dart' as global;
import 'package:flutter_html/flutter_html.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  global.LoginType loginType = global.LoginType.none;
  AuthService appAuth = new AuthService();

  String messages =
      """<b>เจ้าของกิจการหมายถึง</b> ผู้ที่สามารถสร้างกิจการ โดยสามารถสร้างบริษัทภายใต้กิจการได้หลายบริษัท และหลายสาขา พร้อมทั้งมีสิทธิ์ในการจัดการกิจการได้ 
          เช่น เพิ่มผู้ดูแลกิจการเสริม เพิ่มผู้ดูแลบริษัท เพิ่มพนักงาน และเพิ่มสาขา<br/><br/>
          <b>นโยบายด้านความปลอดภัย</b> ระบบ Thai 7 ทั้งหมด จะเข้าใช้โดยผ่าน ระบบ Login ของ Google หรือ Facebook หรือ Apple ID และระบบจะไม่เก็บรหัสผ่านใดๆ ไว้ในระบบ เพื่อความปลอดภัยสูงสุด เพราะฉะนั้น
          ก่อนใช้งาน จะต้องมีบัญชีของ Google หรือ Facebook หรือ Apple ID<br/><br/>
          <b>พระราชบัญญัติคุ้มครองข้อมูลส่วนบุคคล</b> ลูกค้าจะต้องยินยอมให้ระบบเก็บข้อมูลส่วนตัวของลูกค้า และข้อมูลทั้งหมด ไว้ในระบบ<br/><br/>
          <b>ขั้นตอนการลงทะเบียน</b> มี 3 ขั้นตอนคือ<br/>
          <ul>
            <li>Login ด้วย Google,Facebook,Apple ID อย่างใดอย่างหนึ่ง</li>
            <li>ยินยอมให้ระบบเก็บข้อมูลส่วนตัวของลูกค้า และข้อมูลทั้งหมด ไว้ในระบบ Thai 7 Cloud</li>
            <li>บันทึกหมายเลขโทรศัพท์เพื่อรับ OTP จากเรา และทำการยืนยันตัวตน ด้วย OTP จึงจะสามารถเข้าใช้งานได้</li>
          </ul>""";

  Future googleSignIn() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: ['https://www.googleapis.com/auth/contacts.readonly']).signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    /*final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);*/
    global.loginName = googleUser.displayName!;
    global.loginEmail = googleUser.email;
    global.loginPhotoUrl = googleUser.photoUrl!;
    return googleUser.email;
  }

  Future<void> doRegister() async {
    await appAuth
        .signUpWithEmail(
            AppConfig.serviceApi, emailController.text, passwordController.text)
        .then((_result) async {
      if (_result.success) {
        print(_result);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => Login()), (route) => false);
      }
    }).catchError((e) {
      print(e);
    }).whenComplete(() async {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text('ลงทะเบียนใหม่'),
            ), //
            body: SingleChildScrollView(
                child: Center(
                    child: Column(children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Text(
                "ลงทะเบียนใหม่ เพื่อเป็นเจ้าของกิจการ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(
                height: 20,
              ),
              Html(data: messages),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value != null && value.isNotEmpty
                                  ? null
                                  : 'Required',
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value != null && value.isNotEmpty
                                  ? null
                                  : 'Required',
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 10),
                    child: SingInButton(
                      labelText: 'ลงทะเบียนใหม่',
                      press: () {
                        doRegister();
                      },
                      img: const AssetImage("assets/img/avatar.png"),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10, top: 10),
                      child: SingInButton(
                        labelText: 'Sing up with Line',
                        press: () {
                          setState(() {
                            loginType = global.LoginType.google;
                            googleSignIn().then((value) {
                              if (value.isNotEmpty) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TelephoneScreen()));
                              }
                            });
                          });
                        },
                        img: const AssetImage("assets/img/line_logo.png"),
                      )),
                  Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10, top: 10),
                      child: SingInButton(
                        labelText: 'Sing up with Google',
                        press: () {
                          setState(() {
                            loginType = global.LoginType.google;
                            googleSignIn().then((value) {
                              if (value.isNotEmpty) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TelephoneScreen()));
                              }
                            });
                          });
                        },
                        img: const AssetImage("assets/img/google_logo.png"),
                      )),
                  // Container(
                  //   margin: const EdgeInsets.only(
                  //       left: 20, right: 20, bottom: 10, top: 10),
                  //   child: SingInButton(
                  //     labelText: 'Sing in with Facebook',
                  //     press: () {},
                  //     img: const AssetImage("assets/img/facebook_logo.png"),
                  //   ),
                  // ),
                  // Container(
                  //   margin: const EdgeInsets.only(
                  //       left: 20, right: 20, bottom: 10, top: 10),
                  //   child: SingInButton(
                  //     labelText: 'Sing in with Apple ID',
                  //     press: () {},
                  //     img: const AssetImage("assets/img/apple_logo.png"),
                  //   ),
                  // ),
                  // Container(
                  //   margin: const EdgeInsets.only(
                  //       left: 20, right: 20, bottom: 10, top: 10),
                  //   child: SingInButton(
                  //     labelText: 'Sing in with Phone Number',
                  //     press: () {},
                  //     img: const AssetImage("assets/img/apple_logo.png"),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ])))));
  }
}
