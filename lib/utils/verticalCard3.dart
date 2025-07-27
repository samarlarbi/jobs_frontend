import 'package:flutter/material.dart';
import 'package:jobs_app/utils/Const.dart';

class VerticalCard3 extends StatelessWidget {
  final String imgurl;
  final String title;
  final String price;
  const VerticalCard3({super.key, required this.imgurl, required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.6;
    final cardHeight = cardWidth * 0.6;

    return Container(
      padding: const EdgeInsets.all( 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                height: cardHeight,
                width: cardWidth,
                decoration: BoxDecoration(
              color: loading,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  imgurl,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.broken_image, size: 50)),
                ),
              ),

              Positioned(
                top: 8, 
                left: 8, 
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                
                  decoration: BoxDecoration(
              color: Color2,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text( "starts from "+price +" dt/h" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),)
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
