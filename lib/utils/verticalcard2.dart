import 'package:flutter/material.dart';
import 'package:jobs_app/utils/Const.dart';

class VerticalCard2 extends StatelessWidget {
  final String imgurl;
  final String title;
  const VerticalCard2({super.key, required this.imgurl, required this.title});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.2; 
    final cardHeight = cardWidth ;  

    return Container(
      padding: const EdgeInsets.only(right: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: cardHeight,
            width: cardWidth,
            decoration: BoxDecoration(
              color: loading,
              borderRadius: const BorderRadius.all(Radius.circular(1000)),
            ),
            clipBehavior: Clip.hardEdge,     child: Image.network(
              imgurl,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image, size: 50)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
