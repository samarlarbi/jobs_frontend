import 'package:flutter/material.dart';
import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:jobs_app/utils/imageRow.dart';
import 'package:jobs_app/utils/mybutton.dart';
import 'package:jobs_app/utils/mybutton2.dart';
import 'package:jobs_app/utils/servicecard2.dart';
import 'package:jobs_app/utils/simpleappbar.dart';
import 'package:jobs_app/utils/timetable.dart';

class Workerscreen extends StatelessWidget {
  const Workerscreen({super.key});
 

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> imgList = [
    {
      "title": "Plumber of every house",
      "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsKtVwkch5kVtAVpMvhioDK6zejTxw6BIDfw&s",
      "price": "100",
      "status": "Available",
      "location":"tunis",
      "description":"dfgh dfghjk; dfcv erfvb tygvj bfuvjh n"
    },
    {
      "title": "Gardner",
      "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4TvQOGeDUL8I4Qb2kIe6PoHOm4CDAkPMH6g&s",
      "price": "100",
      "status": "Available",
      "location":"tunis",      "description":"dfgh dfghjk; dfcv erfvb tygvj bfuvjh n"

    },
    {
      "title": "Pusddf dsfdf dsfsd fdsf se",
      "url": "https://4.imimg.com/data4/ON/QI/MY-28206320/hire-electricians-or-plumbers-500x500.png",
      "price": "100",
      "status": "Available",
      "location":"tunis",      "description":"dfgh dfghjk; dfcv erfvb tygvj bfuvjh n"

    },
    {
      "title": "House Cleaner",
      "url": "https://res.cloudinary.com/upwork-cloud/image/upload/c_scale,w_1000/v1690716185/catalog/1685610484779212800/byrvlgmiz6bx5yyxnfez.jpg",
      "price": "100",
      "status": "Available",
      "location":"tunis",      "description":"dfgh dfghjk; dfcv erfvb tygvj bfuvjh n"

    }
  ];
    return Scaffold(
      appBar:SimpleAppBar(context),
      backgroundColor: bg,
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rami ben achour",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.location_on_outlined, color: Colors.blueGrey),
                      SizedBox(width: 6),
                      Text("Location"),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(Icons.circle, size: 5),
                      ),
                      Text("Available", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: const [
                      Icon(Icons.star_rounded, color: Color2),
                      SizedBox(width: 6),
                      Text("4.7"),
                      Text(" (122 Reviews)", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: MyButton("Contact",(){})),
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
                labelPadding: const EdgeInsets.symmetric(horizontal: 24),
                tabs: const [
                  Tab(child: Text('Profile', style: TextStyle(color: Colors.black))),
                  Tab(child: Text('Reviews', style: TextStyle(color: Colors.black))),
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
                      
                      padding: const EdgeInsets.all(16),
                      children: [
                        
                       
                      ProfileWorker(imglist:imgList )
                                    ]),
                  ),
                  Container(
                    color: Colors.white,
                    child: ListView.builder(
                      
                      
                      padding: const EdgeInsets.all(16),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return const ListTile(
                          leading: Icon(Icons.person),
                          title: Text("User Review"),
                          subtitle: Text("Great service! Highly recommended."),
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
