import 'package:flutter/material.dart';

import 'filter.dart';

class Redesigned extends StatefulWidget {
  const Redesigned({super.key});

  @override
  State<Redesigned> createState() => _RedesignedState();
}

class _RedesignedState extends State<Redesigned> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: 1600,
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white,
                  shape: RoundedRectangleBorder(
                  side: const BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0xFFE6E6EC),
                  ),
                  borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Filters()
        ),
      ),
    ),
    );
  }
}