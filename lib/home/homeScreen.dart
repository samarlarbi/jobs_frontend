import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jobs_app/home/homeController.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:jobs_app/utils/ImageRow2.dart';
import 'package:jobs_app/utils/ImageRow3.dart';
import 'package:jobs_app/utils/appbar.dart';
import 'package:jobs_app/utils/d.dart';
import 'package:jobs_app/utils/imageRow.dart';
import 'package:jobs_app/utils/serviceCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Homecontroller homecontroller = Homecontroller();

List<Map<String, String>> imgList = [];
    // {
    //   "title": "sami ",
    //   "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsKtVwkch5kVtAVpMvhioDK6zejTxw6BIDfw&s",
    //   "price": "100",
    //   "status": "Available",
    //   "location":"tunis",
    //   "description":"dfgh dfghjk; dfcv erfvb tygvj bfuvjh n"
    // },
    // {
    //   "title": "sdfghjkl",
    //   "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4TvQOGeDUL8I4Qb2kIe6PoHOm4CDAkPMH6g&s",
    //   "price": "100",
    //   "status": "Available",
    //   "location":"tunis",      "description":"dfgh dfghjk; dfcv erfvb tygvj bfuvjh n"

    // },
    // {
    //   "title": "sdfghjkl",
    //   "url": "https://4.imimg.com/data4/ON/QI/MY-28206320/hire-electricians-or-plumbers-500x500.png",
    //   "price": "100",
    //   "status": "Available",
    //   "location":"tunis",      "description":"dfgh dfghjk; dfcv erfvb tygvj bfuvjh n"

    // },
    // {
    //   "title": "mohamed rami",
    //   "url": "https://res.cloudinary.com/upwork-cloud/image/upload/c_scale,w_1000/v1690716185/catalog/1685610484779212800/byrvlgmiz6bx5yyxnfez.jpg",
    //   "price": "100",
    //   "status": "Available",
    //   "location":"tunis",      "description":"dfgh dfghjk; dfcv erfvb tygvj bfuvjh n"

    // }
  //];
  @override
  void initState() {
    getServices();
    super.initState();
  }
Future<void> getServices() async {
  try {
    List<Map<String, dynamic>> res = await homecontroller.getallservices();

    print("****************************");
    print(res);

    // Convert dynamic map to string map
    final converted = res.map<Map<String, String>>((item) {
      return item.map((key, value) => MapEntry(key, value.toString()));
    }).toList();

    setState(() {
      imgList = converted;
    });
  } catch (e) {
    print(e);
  }
}




  @override
  Widget build(BuildContext context) {
    final screenHight = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:Color.fromARGB(255, 250, 252, 255),
      appBar:myAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
         
       Container(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height:  MediaQuery.of(context).size.width*0.5,
                width:  MediaQuery.of(context).size.width,
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

              Positioned(
              
                child:
                
                 Container(
                  padding: EdgeInsets.symmetric(vertical: 30,horizontal: 15),
                     height:  MediaQuery.of(context).size.width*0.5,
                width:  MediaQuery.of(context).size.width,
              
                
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(57, 0, 0, 0)
                  ),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Professional Cleaning \nService",style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),),
                      ElevatedButton(onPressed: (){},
                      
                      style: ButtonStyle(
                        padding:WidgetStateProperty.all(
                          
    const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
  ),  shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // adjust radius as you like
      )),
                        backgroundColor: WidgetStateProperty.all(Colorone),
                      ),
                       child:Text("Explore",style: TextStyle(color: Colors.white,fontSize: 15),) )
                    ],
                  )
                ),
              ),
            ],
          ),
       
        ],
      ),
    ),
        SizedBox(height: 25,),
          // const Text(
          //   "Popular Services",
          //   style: TextStyle(fontWeight: FontWeight.bold, fontSize:19 ),
          // ),
          // const SizedBox(height: 5),
          // ImageRow(imglist: imgList),
           const Text(
            "all services",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize:19 ),
          ),
                  SizedBox(height: 15),

          ImageRow2(imglist: imgList),
                SizedBox(height: 20,),
  const Text(
            "Availabal Now",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize:19 ),
          ),
                          SizedBox(height: 15),
  ImageRow3(imglist:  imgList.reversed.toList()),
          const Text(
            "Best Rate",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize:19 ),
          ),
          SizedBox(
            
            height: screenHight,
            child: ListView.builder(
                          padding: const EdgeInsets.all(8.0),

              scrollDirection: Axis.vertical,
              itemCount: imgList.length,
              itemBuilder: (context, index) {
                return Servicecard(service: imgList[imgList.length-1-index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
