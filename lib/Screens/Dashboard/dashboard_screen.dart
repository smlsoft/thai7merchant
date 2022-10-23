import 'package:flutter/material.dart';
import 'package:thai7merchant/Screens/Dashboard/components/body.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 14.0),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.logout,
                  size: 14.0,
                ),
                label: const Text('ลงชื่อออก'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
