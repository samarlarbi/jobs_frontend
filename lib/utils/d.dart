import 'dart:async';
import 'package:flutter/material.dart';

class LodingContainer extends StatefulWidget {
  final Widget child ;
  const LodingContainer({super.key, required this.child});
  @override
  State<LodingContainer> createState() => _LodingContainerState();
}

class _LodingContainerState extends State<LodingContainer> {
  bool toggle = false;
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 2), (_) {
      setState(() => toggle = !toggle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 100,
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: toggle
              ? [const Color.fromARGB(255, 212, 212, 212), Colors.grey.shade600]
              : [Colors.grey.shade400, const Color.fromARGB(255, 232, 231, 231)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child:this.widget.child
    );
  }
}
