import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:jobs_app/Controller/Controller.dart';
import 'package:jobs_app/home/homeController.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:jobs_app/utils/simpleappbar.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  final Homecontroller homecontroller = Homecontroller();
  final Controller controller = Controller();

  List<Map<String, dynamic>> reservations = [];
  List<Map<String, dynamic>> workerIncoming = [];
  List<Map<String, dynamic>> workerOwn = [];
  Map<String, dynamic>? userinf = {};

  bool loading = true;

  Future<void> getdata() async {
    try {
      Map<String, dynamic> user = await controller.getmyprofile();
      if (!mounted) return;
      setState(() {
        userinf = user["user"] ?? user ?? {};
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getClientReservations() async {
    try {
      final res = await controller.getreservations();
      if (!mounted) return;
      setState(() {
        reservations = res;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getWorkerReservations() async {
    try {
      final incoming = await controller.getworkerreservation();

      List<Map<String, dynamic>> own = [];
      try {
        own = await controller.getreservations();
      } catch (e) {
        print("Error fetching own reservations: $e");
        own = [];
      }

      if (!mounted) return;
      setState(() {
        workerIncoming = incoming;
        workerOwn = own;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateReservationStatus(
      int reservationId, String newStatus) async {
    try {
      await controller.updatereservation(
          reservationId, {'status': newStatus});
      if (userinf!['role'] == "WORKER") {
        await getWorkerReservations();
      } else {
        await getClientReservations();
      }
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print('Error updating reservation: $e');
    }
  }

  Future<void> deleteReservation(int reservationId) async {
    try {
      await controller.deletreservation(reservationId);
      if (userinf!['role'] == "CLIENT") {
        await getClientReservations();
      } else if (userinf!['role'] == "WORKER") {
        await getWorkerReservations();
      }
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print('Error deleting reservation: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getdata().then((_) {
      if (userinf!['role'] == "CLIENT") {
        getClientReservations().then((_) => setState(() => loading = false));
      } else if (userinf!['role'] == "WORKER") {
        getWorkerReservations().then((_) => setState(() => loading = false));
      } else {
        loading = false;
      }
    });
  }

 Widget buildReservationList(List<Map<String, dynamic>> data,
    {bool isIncoming = false}) {
  return RefreshIndicator(
    onRefresh: () async {
      if (userinf!['role'] == "CLIENT") {
        await getClientReservations();
      } else if (userinf!['role'] == "WORKER") {
        await getWorkerReservations();
      }
    },
    child: data.isEmpty
        ? ListView(
            children: const [
              SizedBox(height: 300),
              Center(child: Text("No reservations found.")),
            ],
          )
        : ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: data.length,
            itemBuilder: (context, index) {
              var color;
              var icon;
              var status = data[index]["status"] ?? "pending";

              if (status == "pending") {
                color = Color2;
                icon = Icons.timelapse_rounded;
              } else if (status == "confirmed" || status == "accepted") {
                color = Colors.green;
                icon = Icons.check_circle;
              } else {
                color = Colors.red;
                icon = Icons.cancel;
              }

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(
                      color: const Color.fromARGB(255, 217, 217, 217)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 230, 229, 229),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                margin: const EdgeInsets.symmetric(vertical: 3),
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display opposite user info (Client for Worker, Worker for Client)
                    Row(
                      children: [
                       CircleAvatar(
    radius: 25,
    backgroundImage: (userinf!['role'] == "WORKER"
            ? data[index]["clientimg"]
            : data[index]["workerimg"]) != null &&
            (userinf!['role'] == "WORKER"
                ? data[index]["clientimg"]
                : data[index]["workerimg"]).isNotEmpty
        ? NetworkImage(userinf!['role'] == "WORKER"
            ? data[index]["clientimg"]
            : data[index]["workerimg"])
        : null,
    child: (userinf!['role'] == "WORKER"
            ? data[index]["clientimg"]
            : data[index]["workerimg"]) == null ||
            (userinf!['role'] == "WORKER"
                ? data[index]["clientimg"]
                : data[index]["workerimg"]).isEmpty
        ? const Icon(Icons.person)
        : null,
  ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
  userinf!['role'] == "WORKER"
                                    ? data[index]["clientname"] ?? "Unknown Client"
                                    : data[index]["workerName"] ?? "Unknown Worker",
                                                           style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                 data[index]["title"] ?? 'No Service'
                            ,       style: const TextStyle(fontSize: 16),
                              ),
                             
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            color: Color.fromARGB(255, 146, 148, 150), size: 15),
                        const SizedBox(width: 8),
                        Text(data[index]["day"] ?? '',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 146, 148, 150))),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            color: Color.fromARGB(255, 146, 148, 150), size: 15),
                        const SizedBox(width: 8),
                        Text(
                          "${data[index]["startTime"]?.substring(0, 5) ?? ''} - ${data[index]["endTime"]?.substring(0, 5) ?? ''}",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 146, 148, 150)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: userinf!['role'] == "CLIENT"
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.spaceBetween,
                      children: [
                        // Worker can update status for incoming reservations
                        if (userinf!['role'] == "WORKER")
                          DropdownButton<String>(
                            value: data[index]["status"],
                            items: <String>['pending', 'accepted', 'rejected']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                    value[0].toUpperCase() + value.substring(1)),
                              );
                            }).toList(),
                            onChanged: (newStatus) {
                              if (newStatus != null &&
                                  newStatus != data[index]["status"]) {
                                updateReservationStatus(data[index]["id"], newStatus);
                              }
                            },
                          ),
                        ElevatedButton(
                          onPressed: () => deleteReservation(data[index]["id"]),
                          style: ButtonStyle(
                            fixedSize: userinf!['role'] == "CLIENT"
                                ? MaterialStateProperty.all(
                                    Size(MediaQuery.of(context).size.width * 0.8, 20))
                                : null,
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 244, 139, 132)),
                            side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(
                                  color: Color.fromARGB(255, 244, 139, 132)),
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
                                style: TextStyle(
                                    color: Color.fromARGB(255, 220, 126, 119)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
  );
}

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: SimpleAppBar(context, "Reservations"),
      body: userinf!['role'] == "CLIENT"
          ? buildReservationList(reservations)
          : DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Colors.black,
                    indicatorColor: Colors.blue,
                    tabs: [
                      Tab(text: "Incoming Reservations"),
                      Tab(text: "My Reservations"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        buildReservationList(workerIncoming, isIncoming: true),
                        buildReservationList(workerOwn),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
