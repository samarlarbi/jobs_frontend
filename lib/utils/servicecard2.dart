import 'package:flutter/material.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:jobs_app/utils/mybutton.dart';
import 'package:jobs_app/utils/timetable.dart';
import 'package:jobs_app/workerPage/WorkerScreen.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class Servicecard2 extends StatelessWidget {
  final Map<String, dynamic> service ;
  
  const Servicecard2({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.4; 
    final cardHeight = cardWidth *1.2;  

    return Container(
       constraints: BoxConstraints(
        minWidth: cardWidth, 
        minHeight: cardHeight,
      ),
        margin: EdgeInsets.only(right: 10),
          padding: EdgeInsets.symmetric(vertical: 3,horizontal: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            
            color: Colors.white,
          boxShadow: [
            BoxShadow(
        color: const Color.fromARGB(255, 235, 233, 233),
        spreadRadius: 2, 
        blurRadius: 3,   
        offset: Offset(0, 3),
            ),
          ],             ),
          child: 
          Column(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                                                       SizedBox(height: 6),
        
                  Text(service["serviceInfo"]["title"]??"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20), )                ,
                 
         Row(
                    children: [ 
                      Icon(Icons.payments_outlined, color: Colors.blueGrey,size: 15,),
                        SizedBox(width: 6),
                        Text(service['price']==0?'discusable': "${service['price']} dt/h",style: TextStyle(fontSize: 15),),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                        ),
                        
                        
                        ]
                        
                        
                        ,),
                         Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Icon(Icons.star_rounded, color: Color2,size: 20,),
                        SizedBox(width: 6),
                        Text("4.7",style: TextStyle(fontSize: 13),),
                      ],
                    
              ),
              ElevatedButton(
  onPressed: () {
Navigator.push(context,
  MaterialPageRoute(builder: (context) => ReservationPage(service: service ,workerinfo: service["workerId"]??0 ,))
               ); },
  style: ButtonStyle(
    minimumSize: WidgetStateProperty.all(const Size(0, 0)), // smallest size
    padding: WidgetStateProperty.all(EdgeInsets.zero),     // no padding
    shadowColor: WidgetStateProperty.all(Colors.grey),
    elevation: WidgetStateProperty.all(0),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    backgroundColor: WidgetStateProperty.all(Colors.white),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min, 
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "book",
        style: TextStyle(
          color: Color2,
          fontSize: 15,
        ),
      ),        Padding(
        padding: const EdgeInsets.only(top:  3.0),
        child: Icon(Icons.keyboard_double_arrow_right_rounded,color:       Color2,
        ),
      )

    ],
  ),
)

         ]), 
              
          
        );
      
    
  }
}