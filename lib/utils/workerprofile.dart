import 'package:flutter/material.dart';
import 'package:jobs_app/utils/servicecard2.dart';
import 'package:jobs_app/utils/verticalCard.dart';

class ProfileWorker extends StatelessWidget {
  final List<Map<String, dynamic>> posts=[
    {
      "title": "sami ",
      "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsKtVwkch5kVtAVpMvhioDK6zejTxw6BIDfw&s",
      "price": "100",
      "status": "Available",
      "location":"tunis",
      "description":"dfgh dfghjk; dfcv erfvb tygvj bfuvjh n"
    },
    {
      "title": "sdfghjkl",
      "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4TvQOGeDUL8I4Qb2kIe6PoHOm4CDAkPMH6g&s",
      "price": "100",
      "status": "Available",
      "location":"tunis",      "description":"dfgh dfghjk; dfcv erfvb tygvj bfuvjh n"

    },
    {
      "title": "sdfghjkl",
      "url": "https://4.imimg.com/data4/ON/QI/MY-28206320/hire-electricians-or-plumbers-500x500.png",
      "price": "100",
      "status": "Available",
      "location":"tunis",      "description":"dfgh dfghjk; dfcv erfvb tygvj bfuvjh n"

    },
    {
      "title": "mohamed rami",
      "url": "https://res.cloudinary.com/upwork-cloud/image/upload/c_scale,w_1000/v1690716185/catalog/1685610484779212800/byrvlgmiz6bx5yyxnfez.jpg",
      "price": "100",
      "status": "Available",
      "location":"tunis",      "description":"dfgh dfghjk; dfcv erfvb tygvj bfuvjh n"

    }
  ];
  final String description;
  final List<Map<String, dynamic>> services;

   ProfileWorker({super.key, required this.services, required this.description});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height*0.6;
    final cardWidth = screenWidth ; 
    final cardHeight = cardWidth* 0.8 ; 
    return SizedBox(
      height: screenheight,
      
      child: ListView.separated(
        padding: EdgeInsets.only(bottom:  30),
        physics: ScrollPhysics(),
        
        itemCount: services.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return 
          index==0?
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
             children: [
            
            
       description!=''?        Text("About" , style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),):Padding(padding: EdgeInsets.all(0))
                            
                             , description!=''?   Text( description, style: TextStyle(fontSize: 20)):Padding(padding: EdgeInsets.all(0)),
                          
             
      Text("Services" , style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
          ,                      
SizedBox(height: 5,),
  SizedBox(
    height: cardHeight*0.53,
            width: screenWidth,
            child: ListView.builder(
                          padding: const EdgeInsets.all(8.0),

              scrollDirection: Axis.horizontal,
              itemCount: services.length,
              itemBuilder: (context, index) {
                return Servicecard2(service: services[index]);
              },
            ),),
                        Text("Posts  " , style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

          SizedBox(height: 5,),

          SizedBox(
            width: cardWidth,
            child: VerticalCard(
              imgurl: posts[index]['url'] ?? '',
              title: posts[index]['title'] ?? '',
            ),
          )
             ])      
          :
             
             SizedBox(
            width: cardWidth,
            child: VerticalCard(
              imgurl: posts[index]['url'] ?? '',
              title: posts[index]['title'] ?? '',
            ),
          )
          ;
        },
      ),
    );
  }
}
