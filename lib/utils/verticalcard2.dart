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

    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(5),
      
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          
          children: [
            Container(
              height: cardHeight*0.5,
              width: cardWidth*0.5,
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
            const SizedBox(width: 8 ),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
