import 'package:flutter/material.dart';
import 'package:jobs_app/utils/verticalCard3.dart';

class ImageRow3 extends StatelessWidget {
  final List<Map<String, dynamic>> imglist;

  const ImageRow3({super.key, required this.imglist});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imglist.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = imglist[index];
          final workerInfo = item['workerInfo'] ?? {};
          final serviceInfo = item['serviceInfo'] ?? {};

          return VerticalCard3(
            imgurl: workerInfo['imgprofile'] ?? '',
            title: serviceInfo['title'] ?? '',
            price: item['price']?.toString() ?? '',
          );
        },
      ),
    );
  }
}
