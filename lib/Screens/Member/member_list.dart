import 'package:flutter/material.dart';
import 'package:thai7merchant/Screens/dashboard/dashboard_screen.dart';
import 'package:thai7merchant/Screens/Member/components/body.dart';
import 'package:thai7merchant/Screens/Member/member_add.dart';
import 'package:thai7merchant/components/appbar.dart';

class MemberScreen extends StatelessWidget {
  const MemberScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: const Text('ทะเบียนสมาชิก'),
        appBar: AppBar(),
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => DashboardScreen()));
          },
        ),
        widgets: const <Widget>[],
      ),
      body: const Body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MemberAdd();
              },
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
