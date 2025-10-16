import 'package:flutter/material.dart';
import 'package:jobs_app/utils/Const.dart';

PreferredSizeWidget SimpleAppBar(BuildContext context, String title) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(45), // smaller height (default is ~56)
    child: AppBar(
      leadingWidth: 40,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_rounded, color: Colorone, size: 28),
      ),
      backgroundColor: Colors.white,
      shadowColor: const Color.fromARGB(255, 240, 240, 240),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 18,
        ),
        
      ),
    ),
  );
}
