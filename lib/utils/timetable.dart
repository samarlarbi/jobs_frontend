import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:jobs_app/utils/appbar.dart';
import 'package:jobs_app/utils/mybutton.dart';
import 'package:jobs_app/utils/simpleappbar.dart';

class ReservationPage extends StatefulWidget {
  final Map<String, String> service;
  ReservationPage({super.key, required this.service});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay fromTime = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay toTime = const TimeOfDay(hour: 16, minute: 0);

  // Generate days list relative to selectedDate, so the selected day is always included and visible
  List<DateTime> get days =>
      List.generate(6, (index) => selectedDate.add(Duration(days: index)));

  String getWeekdayAbbr(int weekday) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[weekday - 1];
  }

  Future<void> pickFromTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: fromTime,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        fromTime = picked;
        if (_toMinutes(fromTime) > _toMinutes(toTime)) {
          toTime = fromTime;
        }
      });
    }
  }

  Future<void> pickToTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: toTime,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        toTime = picked;
        if (_toMinutes(toTime) < _toMinutes(fromTime)) {
          final aux = fromTime;
          fromTime = toTime;
          toTime = aux;
        }
      });
    }
  }

  int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return "$h.$m";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.13;
    final cardHeight = cardWidth;

    return Scaffold(
      appBar: SimpleAppBar(context),
      backgroundColor: bg,
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                widget.service["title"] ?? "",
                style: TextStyle(color: Color2, fontWeight: FontWeight.w800),
              ),
              subtitle: Text("@ sami ashour"),
              onTap: () {},
              trailing: Container(
                height: cardHeight,
                width: cardWidth,
                decoration: BoxDecoration(
                  color: loading,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  this.widget.service["url"] ?? "",
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.broken_image, size: 50)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Select a day",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...days.map((date) {
                  final isSelected = DateUtils.isSameDay(selectedDate, date);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color.fromARGB(255, 236, 203, 178)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            date.day.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: isSelected ? Color2 : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            getWeekdayAbbr(date.weekday),
                            style: TextStyle(
                              color: isSelected ? Color2 : Colors.black54,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 4),
                          isSelected
                              ? Icon(
                                  Icons.circle,
                                  size: 9,
                                  color: Color2,
                                )
                              : Padding(padding: EdgeInsets.all(0))
                        ],
                      ),
                    ),
                  );
                }).toList(),
                // calendar button at the end
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding:
                        const EdgeInsets.symmetric(vertical: 27, horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 175, 197, 234),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.calendar_today, color: Colorone),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Selected time",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // FROM
                InkWell(
                  onTap: pickFromTime,
                  child: Column(
                    children: [
                      const Text(
                        "From",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTime(fromTime),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 28, color: Colors.black87),
                InkWell(
                  onTap: pickToTime,
                  child: Column(
                    children: [
                      const Text(
                        "To",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTime(toTime),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
           const SizedBox(height: 18),
          const Text(
            "Location",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),const SizedBox(height: 10),

           TextField(
            
            decoration: InputDecoration(
                  suffixIcon: Icon(Icons.location_on_outlined,color: const Color.fromARGB(255, 118, 130, 150),),
              hint: Text(
                "Add any details...",
                style: TextStyle(color: Colors.grey),
              ),
              filled: true,
              fillColor: const Color(0xFFF7FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            "Note",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hint: Text(
                "Add any details...",
                style: TextStyle(color: Colors.grey),
              ),
              filled: true,
              fillColor: const Color(0xFFF7FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),SizedBox(height: 15,),
          
          MyButton("Save", () {
            String day = DateFormat('yyyy-MM-dd').format(selectedDate);
            String from = formatTimeOfDay(fromTime);
            String to = formatTimeOfDay(toTime);

            print(day);
            print(from);
            print(to);
          }),
        ],
      ),
    );
  }
}
