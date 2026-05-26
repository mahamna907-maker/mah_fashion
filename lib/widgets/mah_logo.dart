import 'package:flutter/material.dart';

class MahLogo extends StatelessWidget {
  final double size;
  final bool showBackground;

  const MahLogo({super.key, this.size = 64, this.showBackground = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset('assets/images/mah_logo.png', fit: BoxFit.contain),
    );
  }
}
