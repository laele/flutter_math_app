import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class PencilSign extends StatefulWidget {
  const PencilSign({
    super.key,
  });

  @override
  State<PencilSign> createState() => _PencilSignState();
}

class _PencilSignState extends State<PencilSign> {
  double _opacity = 1;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        if (!mounted) return;
        setState(() {
          _opacity = 0.10;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BounceInDown(
      from: 20,
      duration: Duration(milliseconds: 500),
      child: Align(
        alignment: AlignmentGeometry.center,
        child: AnimatedOpacity(
          duration: Duration(seconds: 1),
          opacity: _opacity,
          child: Container(
            width: 100,
            height: 100,
            child: Image.asset(
              'lib/core/assets/images/pencil.png',
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
