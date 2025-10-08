import 'package:flutter/material.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

PreferredSizeWidget myAppBar() {
  return AppBar(
    
    backgroundColor: Colors.white,
    elevation: 2,
    shadowColor: const Color.fromARGB(255, 244, 243, 243),
    leading: Icon(Icons.work , color: Colorone,),
   
    title:   Text("Jobs", style: TextStyle(color: Colorone , fontWeight: FontWeight.bold  ), textAlign: TextAlign.start,),
  );
}
