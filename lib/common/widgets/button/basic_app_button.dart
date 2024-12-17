import 'package:flutter/material.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';

class BasicAppButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double ? height ;
  final bool isTransparent;

  const BasicAppButton({super.key, required this.title, required this.onPressed, this.height, this.isTransparent = false});

  @override
  Widget build(BuildContext context) {
    //   return Container(
    //     padding: const EdgeInsets.symmetric(
    //       horizontal: 30,
    //       vertical: 30,
    //     ),
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(30),
    //       color: AppColors.primary,
    //     ),
    //     child: Center(
    //       child: Text(
    //         widget.text,
    //         style: const TextStyle(
    //           fontWeight: FontWeight.w500,
    //           color: Colors.white,
    //           fontSize: 22,
    //         ),
    //       ),
    //     ),
    //   );
    // }
    return ElevatedButton(
      onPressed: onPressed,

      style: ElevatedButton.styleFrom(
        backgroundColor: isTransparent? Colors.transparent : AppColors.primary,
        minimumSize: Size.fromHeight(height ?? 80)
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.white,
          fontSize: 22,
        ),
      ),
    );
  }
}
