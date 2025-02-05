import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';

class ElementTitleWidget extends StatelessWidget {
  final String elementTitle;
  final List<dynamic> list;
  final double limit;
  final VoidCallback onTap;
  const ElementTitleWidget({
    required this.elementTitle,
    required this.list,
    required this.limit,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      padding: EdgeInsets.symmetric(horizontal: 13.w).copyWith(right: 6.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                elementTitle,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(
                Icons.arrow_drop_down_rounded,
                color: AppColors.primary,
              )
            ],
          ),
          list.length >= limit
              ? Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.sp,
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
