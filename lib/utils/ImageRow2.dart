import 'package:flutter/material.dart';
import 'package:jobs_app/utils/verticalcard2.dart';

class ImageRow2 extends StatelessWidget {
  final List<Map<String, String>> imglist;

  const ImageRow2({super.key, required this.imglist});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.25; 
    final cardHeight = cardWidth*1.2; 
    return SizedBox(
      
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        
        itemCount: imglist.length,
        itemBuilder: (context, index) {
          return SizedBox(
          
            width: cardWidth,
            child: VerticalCard2(
              imgurl: imglist[index]['url'] ?? '',
              title: imglist[index]['title'] ?? '',
            ),
          );
        },
      ),
    );
  }
}
