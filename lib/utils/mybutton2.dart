import 'package:flutter/material.dart';
import 'package:jobs_app/utils/Const.dart';

  ElevatedButton  MyButton2(String title)
  {
    
    return  ElevatedButton(onPressed: (){},
                      
                      style: ButtonStyle(
                         shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colorone) 
      )),
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                       child:Text(title,style: TextStyle(color: Colorone,fontSize: 15),) )  ;}