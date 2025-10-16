import 'package:flutter/material.dart';

class VerticalCard3 extends StatelessWidget {
  final String imgurl;
  final String title;
  final String price;

  const VerticalCard3({
    super.key,
    required this.imgurl,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(72, 140, 138, 138)),
        // gradient: const LinearGradient(
        //   colors: [ Color.fromARGB(31, 138, 138, 139),Color.fromARGB(120, 133, 133, 134), Color.fromARGB(71, 158, 158, 159)],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(25, 200, 199, 199),
        boxShadow: [
        
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                    imgurl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text("4.5 " ),
                    const Icon(
                      Icons.star_rounded,
                      color: Color.fromARGB(179, 210, 161, 97),
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),

SizedBox(height: 3,),
            Text(
              price + " dt",
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              title,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            Text(
              "Bengaluru, Karnataka",
              style: TextStyle(
                color: const Color.fromARGB(255, 6, 6, 6).withOpacity(0.6),
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
