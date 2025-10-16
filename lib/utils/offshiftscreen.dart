import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_app/Controller/Controller.dart';
import 'package:jobs_app/utils/Const.dart';

class OffShiftScreen extends StatefulWidget {
  const OffShiftScreen({super.key});

  @override
  State<OffShiftScreen> createState() => _OffShiftScreenState();
}

class _OffShiftScreenState extends State<OffShiftScreen> {
  final Controller controller = Controller();
  DateTime selectedDate = DateTime.now();
  TimeOfDay fromTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay toTime = const TimeOfDay(hour: 12, minute: 0);
  TextEditingController reasonController = TextEditingController();
  List<Map<String, dynamic>> offShifts = [];
  List<Map<String, dynamic>> filteredShifts = [];
  bool isLoading = false;

  // This variable controls the first day of the 7-day horizontal list
  DateTime firstDayOfWeek = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchOffShifts();
  }

  Future<void> fetchOffShifts() async {
    setState(() => isLoading = true);
    try {
      final data = await controller.getWorkerOffShifts();
      setState(() {
        offShifts = data;
        filterByDate(selectedDate);
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  void filterByDate(DateTime date) {
    setState(() {
      filteredShifts = offShifts
          .where((shift) =>
              shift['day'] == DateFormat('yyyy-MM-dd').format(date))
          .toList();
    });
  }

  Future<void> pickTime(bool isFrom) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isFrom ? fromTime : toTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colorone,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isFrom) fromTime = picked;
        else toTime = picked;
      });
    }
  }

  Future<void> saveOffShift() async {
    try {
      final newShift = {
        "day": DateFormat('yyyy-MM-dd').format(selectedDate),
        "startTime": formatTime(fromTime),
        "endTime": formatTime(toTime),
      };
      await controller.addOffShift(newShift);
      reasonController.clear();
      fetchOffShifts();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Off Shift added successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Off Shift already exists")),
      );
    }
  }

  String formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> deleteShift(int id) async {
    await controller.deleteOffShift(id);
    fetchOffShifts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f8fa),
      appBar: AppBar(
        title: const Text("Availability", style: TextStyle(fontSize: 18)),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchOffShifts,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderCard(),
                    const SizedBox(height: 20),
                    _buildFormCard(),
                    const SizedBox(height: 20),
                    _buildHorizontalCalendar(),
                    const SizedBox(height: 20),
                    const Text(
                      "Your Off Shifts",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildOffShiftList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(104, 171, 196, 238),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromARGB(255, 186, 202, 231)),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Plan Your Day Off",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colorone),
          ),
          SizedBox(height: 4),
          Text(
            "Select a date and time to mark as your off-shift.",
            style: TextStyle(
                color: Color.fromARGB(185, 68, 63, 63), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: const Color.fromARGB(91, 158, 158, 158))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDatePicker(),
            const SizedBox(height: 12),
            _buildTimeRow(),
            const SizedBox(height: 12),
            _buildReasonField(),
            const SizedBox(height: 16),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(primary: Colorone),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            selectedDate = picked;
            firstDayOfWeek = picked; // picked date becomes the first day
            filterByDate(selectedDate);
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('EEE, MMM d, yyyy').format(selectedDate),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
            const Icon(Icons.calendar_today_rounded, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRow() {
    return Row(
      children: [
        Expanded(child: _buildTimeTile("From", fromTime, true)),
        const SizedBox(width: 12),
        Expanded(child: _buildTimeTile("To", toTime, false)),
      ],
    );
  }

  Widget _buildTimeTile(String label, TimeOfDay time, bool isFrom) {
    return GestureDetector(
      onTap: () => pickTime(isFrom),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$label: ${formatTime(time)}", style: const TextStyle(fontSize: 13)),
            const Icon(Icons.access_time_filled_rounded, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonField() {
    return TextField(
      controller: reasonController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        prefixIcon: const Icon(Icons.note_alt_outlined, size: 20),
        hintText: "Add a reason (optional)",
        hintStyle: const TextStyle(fontSize: 13),
        filled: true,
        fillColor: Colors.grey[100],
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      maxLines: 2,
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: saveOffShift,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colorone,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        elevation: 0,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Text(
            "Save Off Shift",
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCalendar() {
    final days = List.generate(7, (i) => firstDayOfWeek.add(Duration(days: i)));

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length + 1,
        itemBuilder: (context, index) {
          if (index == days.length) {
            return GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(primary: Colorone),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                    firstDayOfWeek = picked; // picked date becomes first day
                    filterByDate(selectedDate);
                  });
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colorone,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "Pick Date",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }

          final day = days[index];
          final isSelected = day.day == selectedDate.day &&
              day.month == selectedDate.month &&
              day.year == selectedDate.year;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = day;
                filterByDate(selectedDate);
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colorone : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isSelected ? Colorone : Colors.grey.shade300),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('EEE').format(day),
                      style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.black87)),
                  const SizedBox(height: 4),
                  Text(day.day.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87)),
                  Text(
                    " ${DateFormat('MMM').format(day)}",
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected ? Colors.white : const Color.fromARGB(82, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOffShiftList() {
    if (filteredShifts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Icon(Icons.not_interested, size: 40, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                "No Off Shifts In This Date",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: filteredShifts.map((shift) {
        final formattedDate =
            DateFormat('EEE, MMM d').format(DateTime.parse(shift['day']));
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            leading: CircleAvatar(
              backgroundColor: Colorone.withOpacity(0.2),
              child: Icon(Icons.event_available, color: Colorone, size: 18),
            ),
            title: Text(
              formattedDate,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "From ${shift['startTime']} to ${shift['endTime']}",
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
              onPressed: () => deleteShift(shift['id']),
            ),
          ),
        );
      }).toList(),
    );  
  }
}
