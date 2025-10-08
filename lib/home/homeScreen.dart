import 'package:flutter/material.dart';
import 'package:jobs_app/Controller/Controller.dart';
import 'package:jobs_app/home/WorkerHome.dart';
import 'package:jobs_app/home/homeController.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:jobs_app/utils/ImageRow2.dart';
import 'package:jobs_app/utils/ImageRow3.dart';
import 'package:jobs_app/utils/appbar.dart';
import 'package:jobs_app/utils/serviceCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Homecontroller homecontroller = Homecontroller();
  final Controller controller = Controller();

  List<Map<String, dynamic>> imgList = [];
  List<Map<String, dynamic>> workerServices = [];
  Map<String, dynamic> userinf = {};

  bool isLoading = true; // loading state

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      setState(() => isLoading = true);

      final user = await controller.getmyprofile();
      userinf =user["user"]?? user??{};  // <-- assign directly here

      if (userinf["role"] != "WORKER") {
        await clientFun();
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    } finally {
      if (!mounted) return;
setState(()  => isLoading = false);
    }
  }

  Future<void> clientFun() async {
    final res = await homecontroller.getallservices();
    final res2 = await homecontroller.getAllWorkersServices();

if (!mounted) return;
setState(() {      imgList = res;
      workerServices = res2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: myAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userinf["role"] == "WORKER"
              ? const Workerhome()
              : RefreshIndicator(
                  onRefresh: clientFun,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Banner
                        Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: Stack(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.width * 0.5,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: loading,
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Image.network(
                                  "https://images.fineartamerica.com/images/artworkimages/mediumlarge/3/plumber-electrician-paintercleaning-in-vasant-kunj-vasant-vihar-delhi-mistribabu.jpg",
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(child: Icon(Icons.broken_image, size: 50)),
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(57, 0, 0, 0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Professional Cleaning \nService",
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                                          ),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          backgroundColor: MaterialStateProperty.all(Colorone),
                                        ),
                                        child: const Text(
                                          "Explore",
                                          style: TextStyle(color: Colors.white, fontSize: 15),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),
                        const Text("All Services",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
                        const SizedBox(height: 15),
                        ImageRow2(imglist: imgList),

                        const SizedBox(height: 20),
                        const Text("Available Now",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
                        const SizedBox(height: 15),
                        ImageRow3(imglist: workerServices),

                        const SizedBox(height: 20),
                        const Text("Best Rate",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
                        const SizedBox(height: 10),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(8.0),
                          itemCount: workerServices.length,
                          itemBuilder: (context, index) {
                            return Servicecard(service: workerServices[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
