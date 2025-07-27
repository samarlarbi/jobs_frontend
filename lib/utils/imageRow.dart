import 'package:flutter/material.dart';
import 'package:jobs_app/utils/servicecard2.dart';
import 'package:jobs_app/utils/verticalCard.dart';

class ProfileWorker extends StatelessWidget {
  final List<Map<String, String>> imglist;

  const ProfileWorker({super.key, required this.imglist});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height*0.6;
    final cardWidth = screenWidth ; 
    final cardHeight = cardWidth* 0.8; 
    return SizedBox(
      height: screenheight,
      
      child: ListView.separated(
        padding: EdgeInsets.only(bottom:  30),
        physics: ScrollPhysics(),
        
        itemCount: imglist.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return 
          index==0?
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text("About Sami " , style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
                            
                             , Text(
                            "This is the description of the worker. "
                            "Rami ben achour is a professional worker offering high-quality services.",
                            style: TextStyle(fontSize: 20),
                          ),
             
           
SizedBox(height: 10,),
  SizedBox(
    height: cardHeight*0.53,
            width: screenWidth,
            child: ListView.builder(
                          padding: const EdgeInsets.all(8.0),

              scrollDirection: Axis.horizontal,
              itemCount: imglist.length,
              itemBuilder: (context, index) {
                return Servicecard2(service: imglist[imglist.length-1-index]);
              },
            ),),
                        Text("Posts  " , style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

          
          SizedBox(
            width: cardWidth,
            child: VerticalCard(
              imgurl: imglist[index]['url'] ?? '',
              title: imglist[index]['title'] ?? '',
            ),
          )
             ])      
          :
             SizedBox(
            width: cardWidth,
            child: VerticalCard(
              imgurl: imglist[index]['url'] ?? '',
              title: imglist[index]['title'] ?? '',
            ),
          )
          ;
        },
      ),
    );
  }
}
