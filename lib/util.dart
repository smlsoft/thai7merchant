import 'package:flutter/material.dart';

class Util {
  static bool isLandscape(BuildContext context) {
    // if (MediaQuery.of(context).orientation == Orientation.portrait) {
    //   return false;
    // } else {
    //   return true;
    // }

    return MediaQuery.of(context).orientation == Orientation.landscape;
  }
}

class ReconnectingOverlay extends StatelessWidget {
  const ReconnectingOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
          ],
        ),
      );
}
