import 'package:flutter/material.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

PreferredSizeWidget myAppBar() {
  return AppBar(
    
    backgroundColor: Colors.white,
    elevation: 2,
    shadowColor: const Color.fromARGB(255, 244, 243, 243),
    actions: [Icon(Icons.notifications_active_outlined),Padding(padding: EdgeInsetsGeometry.all(10))],
   
    title:   Text("Welcome Ahmed !", style: TextStyle(color: Colorone , fontWeight: FontWeight.bold  ), textAlign: TextAlign.start,),
  );
}
