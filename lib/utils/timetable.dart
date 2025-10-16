import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_app/Controller/Controller.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:jobs_app/utils/simpleappbar.dart';
import 'package:jobs_app/utils/mybutton.dart';

class ReservationPage extends StatefulWidget {
  final int workerinfo;
  final Map<String, dynamic> service;

  const ReservationPage({
    super.key,
    required this.service,
    required this.workerinfo,
  });

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  DateTime selectedDate = DateTime.now();
  DateTime startDay = DateTime.now(); // The first day of horizontal list
  TimeOfDay fromTime = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay toTime = const TimeOfDay(hour: 16, minute: 0);
  Map<String, dynamic> userinfo = {};
  final Controller controller = Controller();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  Future<void> getprofile() async {
    try {
      final res = await controller.getprofile(widget.workerinfo);
      if (!mounted) return;
      setState(() => userinfo = res["user"]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> addreservation(Map<String, dynamic> body) async {
    try {
      final res = await controller.addreservation(body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reservation created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getprofile();
  }

  // Fixed 6-day list starting from startDay
  List<DateTime> get days => List.generate(6, (index) => startDay.add(Duration(days: index)));

  String getWeekdayAbbr(int weekday) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[weekday - 1];
  }

  Future<void> pickFromTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: fromTime,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        fromTime = picked;
        if (_toMinutes(fromTime) > _toMinutes(toTime)) toTime = fromTime;
      });
    }
  }

  Future<void> pickToTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: toTime,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        toTime = picked;
        if (_toMinutes(toTime) < _toMinutes(fromTime)) {
          final temp = fromTime;
          fromTime = toTime;
          toTime = temp;
        }
      });
    }
  }

  int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  String formatTimeOfDay(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}.${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.18;
    final cardHeight = cardWidth;

    return Scaffold(
      appBar: SimpleAppBar(context,userinfo["name"] ?? "Loading..."),
      backgroundColor: const Color.fromARGB(198, 231, 233, 245),
      body: ListView(
        children: [
          Container(
                     margin:            const EdgeInsets.symmetric(horizontal: 9, vertical: 9),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:  8,vertical: 0),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                title: Text(
                  widget.service["serviceInfo"]["title"] ?? "",
                  style: const TextStyle(
                      color: Color2, fontWeight: FontWeight.w800, fontSize: 18),
                ),
                subtitle:  Text(
                  widget.service["description"] ?? "",
                  style: const TextStyle(
                      color: Color.fromARGB(172, 75, 74, 74), fontSize: 10),
                ),
                trailing: Container(
                  height: cardHeight,
                  width: cardWidth,
                  decoration: const BoxDecoration(
                    color: loading,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                    userinfo['imgprofile'] ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal:10.0),
            child: const Text("Select a day",
                style: TextStyle(fontSize: 13, color: Colors.black87)),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(6),
            child: Row(

              children: [
                ...days.map((date) {
                  final isSelected = DateUtils.isSameDay(selectedDate, date);
                  return GestureDetector(
                    onTap: () => setState(() => selectedDate = date),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 9),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFEADBC8) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ?  const Color.fromARGB(68, 204, 128, 70) : Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "${date.day}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isSelected ? Color2 : Colors.black87,
                            ),
                          ),   const SizedBox(height: 4),
                          Text(
                            getWeekdayAbbr(date.weekday),
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected ? Color2 : Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                            Text(
                            " ${DateFormat('MMM').format(date)}",
                            style: TextStyle(
                              fontSize: 13,
                              color: isSelected ? Color2 : const Color.fromARGB(82, 0, 0, 0),
                            ),
                          ),
                        //      const SizedBox(height: 4),
                        // isSelected?  Icon(
                        //     Icons.circle
                        //    ,
                        //       size: 10,
                        //       color:   Color2 
                        //     ,
                        //   ):SizedBox(height:4 ),
                       
                        ],
                      ),
                    ),
                  );
                }).toList(),

                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && mounted) {
                      setState(() {
                        selectedDate = picked;
                        startDay = picked; // update horizontal list start
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
    padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 30),
                                      decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 175, 197, 234),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.calendar_today, color: Colorone),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal:10.0),
            child: const Text("Select a time",
                style: TextStyle(fontSize: 13, color: Colors.black87)),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:10.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal:0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: pickFromTime,
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      children: [
                        const Text("From",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54)),
                        const SizedBox(height: 4),
                        Text(_formatTime(fromTime),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, size: 30, color: Colors.black54),
                  InkWell(
                    onTap: pickToTime,
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      children: [
                        const Text("To",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54)),
                        const SizedBox(height: 4),
                        Text(_formatTime(toTime),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:10.0),
            child: const Text("Location",
                style: TextStyle(fontSize: 13, color: Colors.black87)),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:10.0),
            child: TextField(
              controller: locationController,
              
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 6,horizontal: 10),
                suffixIcon: const Icon(Icons.location_on_outlined,
                    color: Colors.blueGrey),
                hintText: "Enter the work location...",
                hintStyle: TextStyle(fontSize: 13,color:Colors.grey ),
                filled: true,
                fillColor: const Color(0xFFF7FAFC),
                border: OutlineInputBorder(
                  
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:10.0),
            child: const Text("Note",
                style: TextStyle(fontSize: 13, color: Colors.black87)),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:10.0),
            child: TextField(
              controller: noteController,
              maxLines: 3,
            
              decoration: InputDecoration(
                
                contentPadding: EdgeInsets.all(10),
                hintText: "Add any extra details...",
                hintStyle:              TextStyle(fontSize: 13, color: Colors.grey),
            
                filled: true,
                fillColor: const Color(0xFFF7FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyButton("Save", () {
              final day = DateFormat('yyyy-MM-dd').format(selectedDate);
              final from = formatTimeOfDay(fromTime);
              final to = formatTimeOfDay(toTime);
              addreservation({
                "serviceId": widget.service["id"],
                "day": day,
                "startTime": from,
                "endTime": to,
              });
            }),
          ),
        ],
      ),
    );
  }
}
