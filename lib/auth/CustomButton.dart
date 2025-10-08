
import 'package:flutter/material.dart';
import 'package:jobs_app/utils/Const.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Color bgcolor, titlecolor;
  final VoidCallback onPressed;
   
  const CustomButton(
      {super.key,
      required this.title,
      required this.bgcolor,
      required this.titlecolor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(15),
            backgroundColor: Colorone,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: titlecolor,
            ),
          ),
        ),
      ),
    );
  }
}
