import 'package:flutter/material.dart';
import 'package:jobs_app/utils/Const.dart';

  ElevatedButton  MyButton2(String title)
  {
    
    return  ElevatedButton(onPressed: (){},
                      
                      style: ButtonStyle(
                           padding:WidgetStateProperty.all(
                          
    const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  ), 
                         shape: WidgetStateProperty.all(
                          
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colorone) 
      )),
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                       child:Center(
                         child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                            Icon(Icons.favorite_border_outlined,color: Colorone,),
                            SizedBox(width: 5,),
                             Text(title,style: TextStyle(color: Colorone,fontSize: 12),),
                           ],
                         ),
                       ) )  ;}