import 'package:flutter/material.dart';
import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:jobs_app/Controller/Controller.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:jobs_app/utils/workerprofile.dart';
import 'package:jobs_app/utils/mybutton.dart';
import 'package:jobs_app/utils/mybutton2.dart';
import 'package:jobs_app/utils/servicecard2.dart';
import 'package:jobs_app/utils/simpleappbar.dart';
import 'package:jobs_app/utils/timetable.dart';

class Workerscreen extends StatefulWidget {
  final int id;
  const Workerscreen({super.key, required this.id});

  @override
  State<Workerscreen> createState() => _WorkerscreenState();
}

class _WorkerscreenState extends State<Workerscreen> {
  final Controller controller = Controller();
  Map<String, dynamic> infos = {};
  Map<String, dynamic> workerinfo = {};
  Map<String, dynamic> userinfo = {};
  List<Map<String, dynamic>> services = [];

  bool isLoading = true;

  Future<void> getprofile() async {
    try {
      if (!mounted) return;
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> res = await controller.getprofile(widget.id);

      if (!mounted) return;
      setState(() {
        infos = res;
        userinfo = res["user"] ?? {};
        workerinfo = res["workerinfo"] ?? {};
        services = (res['services'] as List<dynamic>?)
                ?.map((item) => item as Map<String, dynamic>)
                .toList() ??
            [];
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getprofile();
  }

  void showContactDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Contact Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (userinfo["phone"] != null &&
                  userinfo["phone"].toString().isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.phone, color: Color2),
                    const SizedBox(width: 10),
                    Text(userinfo["phone"].toString()),
                  ],
                ),
              if (userinfo["email"] != null &&
                  userinfo["email"].toString().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.email, color: Color2),
                      const SizedBox(width: 10),
                      Expanded(child: Text(userinfo["email"].toString())),
                    ],
                  ),
                ),
              if ((userinfo["phone"] == null ||
                      userinfo["phone"].toString().isEmpty) &&
                  (userinfo["email"] == null ||
                      userinfo["email"].toString().isEmpty))
                const Text("No contact information available."),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(context, ""),
      backgroundColor: bg,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal:  5),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor:
                              const Color.fromARGB(255, 230, 230, 230),
                          backgroundImage: (userinfo["imgprofile"] != null &&
                                  (userinfo["imgprofile"] as String).isNotEmpty)
                              ? NetworkImage(userinfo["imgprofile"])
                              : null,
                          child: (userinfo["imgprofile"] == null ||
                                  (userinfo["imgprofile"] as String).isEmpty)
                              ? const Icon(Icons.person,
                                  size: 45, color: Colors.grey)
                              : null,
                        ),
                        Text(
                          userinfo["name"] ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    color: Colors.blueGrey),
                                const SizedBox(width: 6),
                                Text(
                                  userinfo["location"] ?? '',
                                  style:
                                      const TextStyle(color: Colors.blueGrey),
                                ),
                              ],
                            ),
                            Text("|"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.star_rounded, color: Color2),
                                SizedBox(width: 3),
                                Text("4.7"),
                                Text(" (122 Reviews)",
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: MyButton("Contact", showContactDialog),
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: MyButton2("Add to favorites")),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      
                      labelPadding:
                          const EdgeInsets.symmetric(horizontal: 25),
                      tabs: const [
                        Tab(
                            child: Text('Profile',
                                style: TextStyle(color: Colors.black))),
                        Tab(
                            child: Text('Reviews',
                                style: TextStyle(color: Colors.black))),
                      ],
                      indicator: ContainerTabIndicator(
                        width: 100,
                        height: 4,
                        color: Color2,
                        radius: BorderRadius.circular(2),
                        borderWidth: 1.0,
                        borderColor: Colors.black,
                        padding: const EdgeInsets.only(top: 25),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Container(
                          color: Colors.white,
                          child: ListView(
                            padding: const EdgeInsets.all(10),
                            children: [
                              ProfileWorker(
                                services: services,
                                description: workerinfo["description"] ?? "",
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return const ListTile(
                                leading: Icon(Icons.person),
                                title: Text("User Review"),
                                subtitle: Text(
                                    "Great service! Highly recommended."),
                              );
                            },
                          ),
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
