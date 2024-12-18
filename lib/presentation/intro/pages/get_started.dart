import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_clone/common/widgets/button/basic_app_button.dart';
import 'package:spotify_clone/core/configs/assets/app_images.dart';
import 'package:spotify_clone/core/configs/assets/app_vectors.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/presentation/choose_mode/pages/choose_mode.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  AppImages.introBg,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.10),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 40.h),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AppVectors.logo,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Enjoy Listening to Music',
                    style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.5),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      'Join millions of listeners. Find new friends with similar musical tastes. Lose yourself in millions of high-quality songs. Your music, anytime, anywhere',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  BasicAppButton(
                    title: 'Get Started',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChooseModePage(),
                        ),
                      );
                    },
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
