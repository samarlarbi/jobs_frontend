import 'package:flutter/material.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

PreferredSizeWidget myAppBar(String title) {
  return AppBar(
    
    backgroundColor: Colors.white,
    shadowColor: const Color.fromARGB(255, 244, 243, 243),
    actions: [Padding(
          padding: const EdgeInsets.only(right:20.0),
          child: Icon(Icons.settings_outlined, color: Colorone,),
        )],
    title:   Text(title, style: TextStyle(color: Colorone   ), textAlign: TextAlign.start,),
  );
}
