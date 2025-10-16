import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:jobs_app/utils/timetable.dart';
import 'package:jobs_app/workerPage/WorkerScreen.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class Servicecard2 extends StatelessWidget {
  final Map<String, dynamic> service;
  final String rating;
  final int reviewCount;

  // Generate rating (3.0 - 5.0) and reviewCount once per card
  Servicecard2({super.key, required this.service})
      : rating = (3 + Random().nextDouble() * 2).toStringAsFixed(1),
        reviewCount = Random().nextInt(200) + 1;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReservationPage(
                service: service,
                workerinfo: service["workerId"] ?? 0,
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                service["serviceInfo"]["title"] ?? "Untitled Service",
                style: const TextStyle(fontSize: 15),
              ),
              Row(
                children: [
                  const Icon(Icons.payments_outlined,
                      color: Colors.blueGrey, size: 15),
                  const SizedBox(width: 6),
                  Text(
                    service['price'] == 0
                        ? 'discusable'
                        : "${service['price']} dt/h",
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.star_rounded, color: Color2, size: 20),
                  const SizedBox(width: 6),
                  Text(rating, style: const TextStyle(fontSize: 13)),
                  ],
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      "Book",
                      style: TextStyle(
                        color: Color2,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.keyboard_double_arrow_right_rounded,
                      color: Color2,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
