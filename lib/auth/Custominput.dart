import 'package:flutter/material.dart';
import 'package:jobs_app/utils/Const.dart';

class CInput extends StatelessWidget {
  final String name;
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextEditingController myController;
  final String? Function(String?) validator;

  const CInput({
    super.key,
    required this.name,
    required this.hintText,
    this.prefixIcon,
    required this.obscureText,
    required this.myController,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 0, bottom: 20),
          child: TextFormField(
            controller: myController,
            obscureText: obscureText,
            validator: validator,
decoration: InputDecoration(
  
  
  labelText: hintText,
  alignLabelWithHint: true,
  floatingLabelBehavior: FloatingLabelBehavior.auto,

  labelStyle: TextStyle(
    fontSize: 16,
    color: Colors.grey,
    fontWeight: FontWeight.normal,
  ),

  floatingLabelStyle: TextStyle(
    fontSize: 20,
    color: Colorone,
    fontWeight: FontWeight.bold,
  ),

  hintStyle: TextStyle(
    color: Colors.grey,
    fontSize: 12,
  ),

  prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,

  border: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  ),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colorone),
  ),
  errorBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2.0),
  ),
  focusedErrorBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2.0),
  ),
),


          ),
        ),
      ],
    );
  }
}
