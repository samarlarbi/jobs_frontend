import 'package:flutter/material.dart';
import 'package:jobs_app/utils/Const.dart';

  ElevatedButton  MyButton(String title, VoidCallback? onPressed )
  {
    
    return  ElevatedButton(onPressed:onPressed,
                      
                      style: ButtonStyle(
                        padding:WidgetStateProperty.all(
                          
    const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
  ),  shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // adjust radius as you like
      )),
                        backgroundColor: WidgetStateProperty.all(Colorone),
                      ),
                       child:Text(title,style: TextStyle(color: Colors.white,fontSize: 13),) )  ;}