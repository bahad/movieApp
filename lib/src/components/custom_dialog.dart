import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';

import 'custom_text.dart';

class CustomDialog {
  static showConfirmDialog(context, message, Function() onPressed) {
    Size size = MediaQuery.of(context).size;
    CupertinoAlertDialog cupertinoAlertDialog = CupertinoAlertDialog(
      content: Column(
        children: [
          Image.asset(
            'assets/icons/warning.png',
            height: size.height * 0.061,
          ),
          const SizedBox(height: 15.0),
          CustomText(
            text: message,
            sizes: Sizes.normal,
          )
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CupertinoButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoButton(
              child: const Text('Submit'),
              onPressed: onPressed,
            ),
          ],
        )
      ],
    );
    showModal(
        configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 600)),
        context: context,
        builder: (BuildContext context) {
          return Transform.scale(
              scale: size.width < 500 ? 1.0 : 1.5, child: cupertinoAlertDialog);
        });
  }
}
