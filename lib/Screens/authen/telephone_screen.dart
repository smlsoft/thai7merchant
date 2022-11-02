import 'package:dedeauthen/dedeauthen.dart';
import 'package:thai7merchant/Screens/authen/otp_screen.dart';

import 'package:flutter/material.dart';
import 'package:thai7merchant/components/numeric_keyboard.dart';
import 'package:thai7merchant/global.dart' as global;

class TelephoneScreen extends StatefulWidget {
  const TelephoneScreen({Key? key}) : super(key: key);

  @override
  State<TelephoneScreen> createState() => _TelephoneScreenState();
}

class _TelephoneScreenState extends State<TelephoneScreen> {
  AuthService appAuth = new AuthService();

  List<int> number = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];
  int numberIndex = 0;

  void onKeyboardTap(String value) {
    setState(() {
      if (numberIndex < number.length) {
        number[numberIndex] = int.parse(value);
        numberIndex++;
      }
    });
  }

  Widget numberWidget(int position) {
    return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: (position < numberIndex)
              ? Center(
                  child: Text(
                    number[position].toString(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : const Center(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('กรุณาบันทึกหมายเลขโทรศัพท์'),
      ), //
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 24),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                            child: Column(
                          children: [
                            Text(
                              'สวัสดี : ${global.loginName}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'email :​ ${global.loginEmail}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )),
                        const Text(
                          'หมายเลขโทรศัพท์ เพื่อยืนยันตัวตน',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            children: <Widget>[
                              for (int i = 0; i < number.length; i++)
                                Expanded(child: numberWidget(i)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            var phoneNum = '66';
                            int idx = 0;
                            number.forEach((element) {
                              if (idx > 0) {
                                phoneNum += element.toString();
                              }
                              idx++;
                            });
                            print(phoneNum);
                            final _result = await appAuth.requestOTP(phoneNum);
                            print(_result);
                            if (_result != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OtpScreen(token: _result['token']),
                                ),
                              );
                            }
                          },
                          child: const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text('ยืนยัน',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ))))),
                  NumericKeyboard(
                    onKeyboardTap: onKeyboardTap,
                    rightIcon: const Icon(
                      Icons.backspace,
                    ),
                    rightButtonFn: () {
                      setState(() {
                        if (numberIndex > 0) {
                          number[numberIndex - 1] = 0;
                          numberIndex--;
                        }
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
