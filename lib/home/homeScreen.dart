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

  bool isLoading = true; 
   TextEditingController  q= TextEditingController();
    List<Map<String, dynamic>> searchlist=[];


  Future<void> search(String q) async
  {
    try{
      var res = await  controller.searchworker(q: q);
if (!mounted) return;
setState(() {        searchlist = res;
      });


    }catch(e){

    }
  } 

  @override
  void initState() {
    super.initState();
    getData();
          search(q.text);

  }

  Future<void> getData() async {
    try {
      setState(() => isLoading = true);

      final user = await controller.getmyprofile();
      userinf =user["user"]?? user??{}; 

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
      backgroundColor:  Color.fromARGB(209, 253, 253, 254),
      appBar:AppBar(

        title:      Row(
                    children: [
                      const Icon(Icons.wb_sunny_sharp,
                          size: 20, color: Color.fromARGB(206, 39, 60, 96)),
                      const SizedBox(width: 4),
                      Text(
                  isLoading
          ?" Hi"
          :      "  Hi , "+ userinf["name"].split(' ')[0]+" !",
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: "Arial",
                          fontWeight: FontWeight.w900,

                          color: Color.fromARGB(206, 39, 60, 96),
                        ),
                      ),
                    ],
                  ),
      // leading:Container(
          
      //     margin: const EdgeInsets.all(4.0),
      //     child: CircleAvatar(
            
      //       backgroundColor: const Color.fromARGB(255, 239, 239, 239),
      //       radius: 30,
      //       backgroundImage: (userinf["imgprofile"] != null && (userinf["imgprofile"] as String).isNotEmpty)
      //           ? NetworkImage(userinf["imgprofile"])
      //           : null,
      //       child: (userinf["imgprofile"] == null || (userinf["imgprofile"] as String).isEmpty)
      //           ? const Icon(Icons.person, size: 30 , color: Colorone,)
      //           : null,
      //     ),
      //   ),
        backgroundColor:Colors.white,
        actions: [Padding(
          padding: const EdgeInsets.only(right:20.0),
          child: Icon(Icons.notifications_active_outlined, color: Colorone,),
        )],

        
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userinf["role"] == "WORKER"
              ? const Workerhome()
              : RefreshIndicator(
                  onRefresh: clientFun,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            // color: const Color.fromARGB(221, 149, 107, 52),
                          ),
                          padding: const EdgeInsets.all( 10),
                          child: 
        
                     Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      "Now, it's easy \nto find your service!",
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: Colorone,
      ),
    ),
    const SizedBox(height: 18),

    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.78,
          height: 45, 
          child: TextField(
            onChanged: (value) => search(value),
            cursorColor: Colorone,
            style: const TextStyle(fontSize: 14, color: Colorone),

            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              
              fillColor:Color.fromARGB(221, 214, 215, 221),
              filled: true,
              prefixIcon: const Icon(
                Icons.search,
                size: 20,
                color: Color.fromARGB(138, 39, 60, 96),
              ),
              hintText: 'Search...',
              hintStyle: const TextStyle(   
                color: Colorone
, fontSize: 13),

              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(0, 109, 110, 110),
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
          ),
        ),

        Container(
          height: 45,
          width: 45,
          decoration:  BoxDecoration(
            color:Color.fromARGB(221, 214, 215, 221),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: const Icon(
            Icons.filter_alt,
            color:Colorone,
            size: 24,
          ),
        ),
      ],
    ),
  ],
)


                          ), 
                                                  Container(
                                                    margin: EdgeInsets.all(8),
                          child: Stack(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.width * 0.45,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: loading,
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Image.network(
"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQi-t0ckhjNMKrGnDcP6s1f6mQLCnsXP9OgyA&shttps://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQi-t0ckhjNMKrGnDcP6s1f6mQLCnsXP9OgyA&s",

                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(child: Icon(Icons.broken_image, size: 50)),
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(57, 0, 0, 0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Professional Plumbing \nService",
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      ElevatedButton(
                                        
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          elevation: MaterialStateProperty.all(0                                        ), 
                                          padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                          ),
                           
                                          backgroundColor: MaterialStateProperty.all(Colors.transparent,
                                        ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Explore",
                                              style: TextStyle(color: Colors.white, fontSize: 15),
                                            ),
                                            Icon(Icons.arrow_forward_ios_rounded , color: Colors.white,)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                         ,
                     
                      Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 8),
                          child: const Text("Best Rate",
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13)),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal:  8.0),
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
