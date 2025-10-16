import 'package:flutter/material.dart';
import 'package:jobs_app/utils/Const.dart';

class WeeklyBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const WeeklyBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    const weekDays = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];
    String todayShort = weekDays[DateTime.now().weekday - 1];

    // Ensure days are ordered and missing days have 0 count
    List<Map<String, dynamic>> orderedData = weekDays.map((day) {
      final match = data.firstWhere(
        (e) => (e["day"] ?? "").toString().toUpperCase() == day,
        orElse: () => {"day": day, "count": 0},
      );
      return {
        "day": day,
        "count": (match["count"] ?? 0) as int,
      };
    }).toList();

    // Avoid division by zero by making sure maxCount >= 1
    int maxCount = orderedData.map((e) => e["count"] as int).fold(0, (a, b) => a > b ? a : b);
    if (maxCount == 0) maxCount = 1;

    double maxBarHeight = 120; // fixed height instead of screen-dependent

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Reservations  ",
              style: TextStyle(color: Color2, fontSize: 15)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(orderedData.length, (index) {
              final day = orderedData[index]["day"] as String;
              final count = orderedData[index]["count"] as int;

              final heightFactor = count / maxCount;
              final barHeight = maxBarHeight * heightFactor;

              bool isToday = day == todayShort;

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 30,
                    height: maxBarHeight,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 238, 238, 238),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: isToday
                              ? const Color.fromARGB(255, 240, 167, 110)
                              : const Color.fromARGB(90, 240, 166, 110),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(day, style: const TextStyle(color: Colors.black54)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
