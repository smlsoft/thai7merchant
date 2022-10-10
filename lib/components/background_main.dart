import 'package:flutter/material.dart';

class BackgroudMain extends StatelessWidget {
  final Widget child;
  const BackgroudMain({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Container(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          child,
        ],
      ),
    );
  }
}
