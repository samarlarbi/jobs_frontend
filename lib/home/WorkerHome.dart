import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_app/Controller/Controller.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:jobs_app/utils/chart.dart';
import 'package:jobs_app/utils/simpleappbar.dart';

class Workerhome extends StatefulWidget {
  const Workerhome({super.key});

  @override
  State<Workerhome> createState() => _WorkerhomeState();
}

class _WorkerhomeState extends State<Workerhome> with SingleTickerProviderStateMixin {
  final Controller controller = Controller();

  int todayCount = 0;
  int totalCount = 0;
  double revenue = 0.0;
  List<Map<String, dynamic>> weeklyData = [];
  List<Map<String, dynamic>> todayList = [];
  bool isLoading = true;

  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fetchStats();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _fetchStats() async {
    setState(() => isLoading = true);
    try {
      final stats = await controller.getstatsworker();
      if (!mounted) return;
      setState(() {
        todayCount = stats["todayCount"] ?? 0;
        totalCount = stats["totalCount"] ?? 0;
        revenue = (stats["revenue"] != null) ? double.tryParse(stats["revenue"].toString()) ?? 0.0 : 0.0;
        weeklyData = List<Map<String, dynamic>>.from(stats["weeklyData"] ?? []);
        todayList = List<Map<String, dynamic>>.from(stats["todayList"] ?? []);
        isLoading = false;
      });

      _animController.forward(from: 0);
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      debugPrint("Error fetching stats: $e");
    }
  }
  void _openCalendar() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Open calendar (placeholder)")));
  }

  void _editAvailability() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Edit availability (placeholder)")));
  }

  void _contactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Contact support (placeholder)")));
  }

  Color _statusColor(String? status) {
    switch ((status ?? "").toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();
    final date = DateFormat('EEE, dd MMM').format(now);

    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Color2.withOpacity(0.12), Color2.withOpacity(0.03)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color2.withOpacity(0.14)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date.toUpperCase(), style: TextStyle(color: Color2, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                const Text("Good day,", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text("Here’s your schedule & summary", style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          ),
       
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _quickActionTile(Icons.calendar_today, "Calendar", _openCalendar),
        _quickActionTile(Icons.schedule, "Availability", _editAvailability),
        _quickActionTile(Icons.task_alt, "reservations", _contactSupport),
      ],
    );
  }

  Widget _quickActionTile(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color.fromARGB(30, 0, 0, 0)),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colorone),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, IconData icon, String value, {Color? accent}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(colors: [Colors.white, Colors.white]),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))],
        border: Border.all(color: const Color.fromARGB(30, 0, 0, 0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (accent ?? Color2).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accent ?? Color2),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 13))),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildReservationCard(Map<String, dynamic> reservation, int index) {
    final status = reservation["status"] ?? "";
    final client = reservation["clientName"] ?? "Unknown";
    final service = reservation["serviceName"] ?? "Service";
    final startTime = (reservation["startTime"] ?? "").toString();
    final endTime = (reservation["endTime"] ?? "").toString();

    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: _animController, curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
      axisAlignment: 0.0,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        color:Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(color: const Color.fromARGB(44, 122, 120, 120))),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => Reservation(reservationId: reservation["id"])));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: reservation["clientImg"] != null ? NetworkImage(reservation["clientImg"]) : null,
                  backgroundColor: Colors.grey[200],
                  child: reservation["clientImg"] == null ? Text(client.isNotEmpty ? client[0].toUpperCase() : "U") : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(client, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(service, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text("${startTime.toString().substring(0, startTime.toString().length >= 5 ? 5 : startTime.length)} - ${endTime.toString().substring(0, endTime.toString().length >= 5 ? 5 : endTime.length)}",
                              style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _statusColor(status).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _statusColor(status).withOpacity(0.18)),
                      ),
                      child: Text(
                        (status ?? "").toString().isNotEmpty ? status[0].toUpperCase() + status.substring(1) : "Unknown",
                        style: TextStyle(color: _statusColor(status), fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    PopupMenuButton<String>(
                      onSelected: (val) {
                        if (val == 'call') {
                          // TODO: implement call
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Call action (placeholder)")));
                        } else if (val == 'message') {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Message action (placeholder)")));
                        } else if (val == 'details') {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => Reservation(reservationId: reservation["id"])));
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'call', child: Text('Call')),
                        const PopupMenuItem(value: 'message', child: Text('Message')),
                        const PopupMenuItem(value: 'details', child: Text('Details')),
                      ],
                      icon: const Icon(Icons.more_vert, size: 18),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromARGB(30, 0, 0, 0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Icon(Icons.event_busy, size: 56, color: Color2.withOpacity(0.85)),
          const SizedBox(height: 12),
          const Text("No reservations today", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text("You have a free day! Try checking the calendar or adjusting availability.", style: TextStyle(color: Colors.grey[700]), textAlign: TextAlign.center),
          const SizedBox(height: 12),
        ])
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final statCardWidth = (width - 36) / 3;

    return  isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(

              onRefresh: _fetchStats,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text("Overview"  ,style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20 , color: Colorone),)
                    ,
                    _buildHeader(context),   

                     Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color.fromARGB(30, 0, 0, 0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         WeeklyBarChart(data: weeklyData),
                        ],
                      ),
                    ),                    const SizedBox(height: 12),

                 _buildQuickActions(),
                    // // Stats row
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Expanded( child: _buildStatCard("Today's reservations", Icons.assignment, todayCount.toString())),
                    //     const SizedBox(width: 8),
                    //     Expanded( child: _buildStatCard("Total reservations", Icons.bar_chart, totalCount.toString())),
                    //   ],
                    // ),

                 


                    Padding(
                      padding: const EdgeInsets.symmetric(  vertical:  8.0, horizontal: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Current Reservations", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500 , color: Colorone)),
                          Row(
                            children: [
                              
                              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colorone),
                            ],
                          )
                        ],
                      ),
                    ),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: todayList.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              key: ValueKey<int>(todayList.length),
                              itemCount: todayList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final reservation = todayList[index];
                                return _buildReservationCard(reservation, index);
                              },
                            ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            
    );
  }
}

class DetailsStatsPage extends StatelessWidget {
  const DetailsStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(context, "Detailed Stats"),
      backgroundColor: bg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Detailed statistics & insights", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text("This is a placeholder. Add graphs, filters and date pickers here to show more details.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700])),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Go back"),
                style: ElevatedButton.styleFrom(backgroundColor: Color2),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// Reservation details screen (kept similar to your previous implementation,
/// but slightly polished — unchanged backend calls).
class Reservation extends StatefulWidget {
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
      setState(() {
        reservationDetails = data;
        selectedStatus = data['status'];
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = "Failed to load reservation details.";
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
      setState(() {
        selectedStatus = newStatus;
        reservationDetails?['status'] = newStatus;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Status updated to $newStatus")));
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to update status")));
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reservation deleted")));
      Navigator.pop(context);
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to delete reservation")));
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
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(reservationDetails?["title"] ?? "No Title", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: reservationDetails?["workerImg"] != null ? NetworkImage(reservationDetails!["workerImg"]) : null,
                              child: reservationDetails?["workerImg"] == null ? const Icon(Icons.person, size: 28) : null,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(reservationDetails?["workerName"] ?? "Unknown", style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 4),
                                Text(reservationDetails?["workerPhone"] ?? "", style: const TextStyle(color: Colors.grey)),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(reservationDetails?["day"] ?? "", style: const TextStyle(color: Colors.grey)),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton<String>(
                              value: selectedStatus,
                              items: <String>['pending', 'accepted', 'rejected'].map((status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status[0].toUpperCase() + status.substring(1)),
                                  )).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  _updateStatus(val);
                                }
                              },
                            ),
                            ElevatedButton(
                              onPressed: _deleteReservation,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 244, 139, 132)),
                                side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Color.fromARGB(255, 244, 139, 132))),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.delete_forever, color: Color.fromARGB(255, 220, 126, 119)),
                                  SizedBox(width: 4),
                                  Text("Delete", style: TextStyle(color: Color.fromARGB(255, 220, 126, 119))),
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
