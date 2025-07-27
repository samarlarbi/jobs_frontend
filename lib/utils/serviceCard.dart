import 'package:flutter/material.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:jobs_app/workerPage/WorkerScreen.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class Servicecard extends StatelessWidget {
  final Map<String, String> service ;
  const Servicecard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.13; 
    final cardHeight = cardWidth ;  

    return GestureDetector(
      onTap: (){
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => Workerscreen()),
);      },
      child: Container(
        margin: EdgeInsets.only(bottom: 7),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: const Color.fromARGB(255, 241, 241, 241),
      spreadRadius: 2, 
      blurRadius: 3,   
      offset: Offset(0, 3), // x,y offset of shadow
    ),
  ],             ),
        child: 
        Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(service["status"]??"" , style: TextStyle(color: const Color.fromARGB(255, 198, 22, 10),fontWeight: FontWeight.w600),),
               Row(
                    children: const [
                      Icon(Icons.star_rounded, color: Colorone,size: 20,),
                      SizedBox(width: 6),
                      Text("4.7",style: TextStyle(fontSize: 13),),
                      Text(" (122 Reviews)",style: TextStyle(fontSize: 13,color: Colorone)),
                    ],
                  ), ],
            ),
            SizedBox(height: 6,),
            Row(
              
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              
              children: [
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service["title"]??"",style: TextStyle(color: Color2,fontWeight: FontWeight.bold,fontSize: 20), )                ,
               
                                     SizedBox(height: 6),
 Row(
                  children: [ 
                      Text("medenines",style: TextStyle(fontSize: 15),),
                      SizedBox(width: 6),
                    Icon(Icons.route_outlined, color: Colors.blueGrey,size: 15,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                      ),]
                      
                      
                      ,),
                      
                      
            
                
                ]),     
                
                
                 Container(
                    height:cardHeight ,
                    width: cardWidth,
            decoration: BoxDecoration(

              color: loading,
              borderRadius: const BorderRadius.all(Radius.circular(1000)),
            ),
            clipBehavior: Clip.hardEdge,     child: Image.network(
              service["url"]??"",
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image, size: 50)),
            ),
          ),
              ],
            )

          ],
        )
        ,
      ),
    );
  }
}