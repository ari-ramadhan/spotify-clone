import 'package:flutter/material.dart';

class Debug extends StatelessWidget {
  const Debug({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          color: Colors.blue,
          child: Stack(
            clipBehavior: Clip.none, // Pastikan overflow tidak dipotong
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.blue,
                ),
              ),
              Positioned(
                bottom: -50, // Geser lingkaran keluar dari container
                left: 50,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
