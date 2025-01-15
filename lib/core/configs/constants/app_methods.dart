import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spotify_clone/common/helpers/export.dart';

Future<Object?> blurryDialog({required BuildContext context, required String dialogTitle, required Widget content, required double horizontalPadding}) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: '',

    barrierColor: Colors.black38,
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (ctx, anim1, anim2) => Padding(
      padding: EdgeInsets.all(10.sp),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            // alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w, vertical: 15.h),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.sp), color: AppColors.medDarkBackground),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 21.w),
                      child: Text(
                        dialogTitle,
                        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                      width: 30.h,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close_rounded),
                        splashRadius: 22.sp,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                content
              ],
            ),
          ),
        ),
      ),
    )
    // AlertDialog(
    //   alignment: Alignment.bottomCenter,
    //   backgroundColor: AppColors.medDarkBackground,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.all(
    //       Radius.circular(
    //         15.sp,
    //       ),
    //     ),
    //   ),
    //   title: Text(dialogTitle),
    //   content: content,
    //   elevation: 0,
    // ),,
    ,
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
      child: FadeTransition(
        opacity: anim1,
        child: child,
      ),
    ),
    context: context,
  );
}
