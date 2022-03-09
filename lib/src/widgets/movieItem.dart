import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../components/custom_text.dart';

class MovieGridItem extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;
  final Function()? onPressed;
  const MovieGridItem({Key? key, required this.data, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onPressed,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: size.height * 0.145,
              child: CachedNetworkImage(
                imageUrl: data.poster,
                errorWidget: (context, url, error) => Image.asset(
                  'assets/icons/no-pictures.png',
                ),
                fit: BoxFit.cover,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      fontWeight: FontWeight.bold,
                      sizes: Sizes.normal,
                      text: data.title),
                  const SizedBox(height: 5),
                  CustomText(sizes: Sizes.small, text: data.year),
                  const SizedBox(height: 5),
                  CustomText(sizes: Sizes.small, text: data.type),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
