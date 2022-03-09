import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../components/custom_text.dart';

class NoData extends StatelessWidget {
  final String messages;
  final onPressed;
  const NoData({Key? key, required this.messages, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/icons/nodata.json', height: size.height * 0.146),
        SizedBox(height: size.height * 0.022),
        CustomText(sizes: Sizes.title, text: messages),
        const SizedBox(height: 15),
        onPressed != null
            ? TextButton(
                onPressed: onPressed,
                child: const CustomText(
                  sizes: Sizes.normal,
                  text: 'Try Again',
                ))
            : const SizedBox(),
      ],
    ));
  }
}
