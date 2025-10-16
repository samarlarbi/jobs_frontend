import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:jobs_app/workerPage/WorkerScreen.dart';

class Servicecard extends StatelessWidget {
  final Map<String, dynamic> service;
  final String rating;
  final int reviewCount;

  // Generate rating (3.0 - 5.0) and reviewCount once per card
  Servicecard({super.key, required this.service})
      : rating = (3 + Random().nextDouble() * 2).toStringAsFixed(1),
        reviewCount = Random().nextInt(200) + 1;

  @override
  Widget build(BuildContext context) {
    final serviceInfo = service["serviceInfo"] as Map<String, dynamic>? ?? {};
    final workerInfo = service["workerInfo"] as Map<String, dynamic>? ?? {};
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.9;
    final imageSize = screenWidth * 0.13;
    final bool isAvailable =
        service["isOffNow"] == false && service["hasReservationNow"] == false;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Workerscreen(id: service['workerId'] ?? 0),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                workerInfo["imgprofile"] ?? "",
                height: imageSize,
                width: imageSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, size: 50, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isAvailable ? "Available" : "Not Available",
                        style: TextStyle(
                          fontSize: 12,
                          color: isAvailable
                              ? const Color.fromARGB(255, 67, 127, 69)
                              : const Color.fromARGB(255, 144, 56, 50),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Colorone, size: 15),
                          const SizedBox(width: 4),
                          Text(rating, style: const TextStyle(fontSize: 11)),
                          Text(" ($reviewCount)",
                              style: const TextStyle(
                                  fontSize: 11, color: Colorone)),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    serviceInfo["title"] ?? "Untitled Service",
                    style: const TextStyle(
                      color: Color2,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 13, color: Colors.blueGrey),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          workerInfo["location"] ?? "No location info",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
