import 'package:flutter/material.dart';
import 'package:jobs_app/utils/Const.dart';

AppBar SimpleAppBar(BuildContext context){
  return AppBar(
    
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colorone, size: 30),
        ),
    
        backgroundColor: Colors.white,
        shadowColor: const Color.fromARGB(255, 240, 240, 240),
        elevation: 1,
      );
}