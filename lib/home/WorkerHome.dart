import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_app/Controller/Controller.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:jobs_app/utils/chart.dart';
import 'package:jobs_app/utils/simpleappbar.dart'; // WeeklyBarChart

class Workerhome extends StatefulWidget {
  const Workerhome({super.key});

  @override
  State<Workerhome> createState() => _WorkerhomeState();
}

class _WorkerhomeState extends State<Workerhome> {
  final Controller controller = Controller();

  int todayCount = 0;
  int totalCount = 0;
  List<Map<String, dynamic>> weeklyData = [];
  List<Map<String, dynamic>> todayList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    try {
      final stats = await controller.getstatsworker();
if (!mounted) return;
setState(() {        todayCount = stats["todayCount"] ?? 0;
        totalCount = stats["totalCount"] ?? 0;
        weeklyData = List<Map<String, dynamic>>.from(stats["weeklyData"] ?? []);
        todayList = List<Map<String, dynamic>>.from(stats["todayList"] ?? []);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error fetching stats: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE dd MMM').format(now).toUpperCase();

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _fetchStats,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.wb_sunny_sharp,
                          size: 20, color: Color.fromARGB(206, 39, 60, 96)),
                      const SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontFamily: "Arial",
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(206, 39, 60, 96),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Overview",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25)),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.rocket_launch_outlined,
                                color: Color2, size: 16),
                            Text(" see more", style: TextStyle(color: Color2)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  WeeklyBarChart(data: weeklyData),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard(context, "today's reservations",
                          Icons.assignment_outlined, todayCount.toString()),
                      _buildStatCard(context, "total reservations",
                          Icons.bar_chart_rounded, totalCount.toString()),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text("Current Reservations  ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    ],
                  ),
                  const SizedBox(height: 10),

                  ListView.builder(
                    itemCount: todayList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final reservation = todayList[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.location_on),
                          title: Text(reservation["clientName"] ?? "Unknown",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle:
                              Text(reservation["serviceName"] ?? "Unknown Service"),
                          trailing: Text(reservation["status"] ?? ""),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Reservation(
                                  reservationId: reservation["id"],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildStatCard(
      BuildContext context, String title, IconData icon, String value) {
    return Container(
      width: MediaQuery.of(context).size.width*0.45,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: const Color.fromARGB(172, 219, 219, 219)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              Text(" $value",
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
            ],
          ),
        ],
      ),
    );
  }
}class Reservation extends StatefulWidget {
  final int reservationId;
  const Reservation({super.key, required this.reservationId});

  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  final Controller controller = Controller();

  Map<String, dynamic>? reservationDetails;
  bool isLoading = true;
  String? error;

  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    _fetchReservationDetails();
  }

  Future<void> _fetchReservationDetails() async {
    try {
      final data = await controller.getareservation(widget.reservationId);
if (!mounted) return;
setState(() {        reservationDetails = data;
        selectedStatus = data['status'];
        isLoading = false;
      });
    } catch (e) {
if (!mounted) return;
setState(() {        error = "Failed to load reservation details.";
        isLoading = false;
      });
      debugPrint("Error fetching reservation details: $e");
    }
  }

  Future<void> _updateStatus(String newStatus) async {
    if (newStatus == selectedStatus) return;
    setState(() => isLoading = true);
    try {
      await controller.updatereservation(widget.reservationId, {'status': newStatus});
if (!mounted) return;
setState(() {        selectedStatus = newStatus;
        reservationDetails?['status'] = newStatus;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Status updated to $newStatus")),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update status")),
      );
      debugPrint("Error updating status: $e");
    }
  }

  Future<void> _deleteReservation() async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this reservation?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => isLoading = true);
    try {
      await controller.deletreservation(widget.reservationId);
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reservation deleted")),
      );
      Navigator.pop(context); // go back after deletion
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete reservation")),
      );
      debugPrint("Error deleting reservation: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: SimpleAppBar(context, "Reservation Details"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              :  Container(
                color: Colors.white,
                   
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reservationDetails?["title"] ?? "No Title",
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundImage: reservationDetails?["workerImg"] != null
                                    ? NetworkImage(reservationDetails!["workerImg"])
                                    : null,
                                child: reservationDetails?["workerImg"] == null
                                    ? const Icon(Icons.person, size: 28)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reservationDetails?["workerName"] ?? "Unknown",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    reservationDetails?["workerPhone"] ?? "",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                reservationDetails?["day"] ?? "",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.access_time, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                "${(reservationDetails?["startTime"] ?? "").toString().substring(0, 5)} - ${(reservationDetails?["endTime"] ?? "").toString().substring(0, 5)}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.location_on_outlined, color: Colors.grey),
                              SizedBox(width: 8),
                              Text("Medenine", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Status Dropdown
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButton<String>(
                                value: selectedStatus,
                                items: <String>['pending', 'accepted', 'rejected']
                                    .map((status) => DropdownMenuItem(
                                          value: status,
                                          child: Text(status[0].toUpperCase() + status.substring(1)),
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    _updateStatus(val);
                                  }
                                },
                              ),

                              // Delete button
                              ElevatedButton(
                                onPressed: _deleteReservation,
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(Colors.white),
                                  foregroundColor: MaterialStateProperty.all<Color>(
                                      const Color.fromARGB(255, 244, 139, 132)),
                                  side: MaterialStateProperty.all<BorderSide>(
                                    const BorderSide(color: Color.fromARGB(255, 244, 139, 132)),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.delete_forever,
                                        color: Color.fromARGB(255, 220, 126, 119)),
                                    SizedBox(width: 4),
                                    Text(
                                      "Delete",
                                      style: TextStyle(color: Color.fromARGB(255, 220, 126, 119)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                
    );
  }
}
