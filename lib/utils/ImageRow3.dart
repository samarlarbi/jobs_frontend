import 'package:flutter/material.dart';
import 'package:jobs_app/utils/verticalCard.dart';
import 'package:jobs_app/utils/verticalCard3.dart';

class ImageRow3 extends StatelessWidget {
  final List<Map<String, dynamic>> imglist;

  const ImageRow3({super.key, required this.imglist});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.6; 
    final cardHeight = cardWidth* 0.8; 
    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        
        scrollDirection: Axis.horizontal,
        itemCount: imglist.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return SizedBox(
            width: cardWidth,
            child: VerticalCard3(
              imgurl: imglist[index]['workerInfo']["imgprofile"] ?? '',
              title: imglist[index]["serviceInfo"]['title'] ?? '',
              price:  imglist[index]['price'].toString() ?? '' ,
            ),
          );
        },
      ),
    );
  }
}
