import 'package:flutter/material.dart';

class SizedSpinner extends StatelessWidget {
  final double height;
  final double width;

  const SizedSpinner({Key? key, this.height = 16, this.width = 16})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CircularProgressIndicator(
        strokeWidth: 2,
      ),
    );
  }
}
