import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone/common/widgets/button/basic_app_button.dart';
import 'package:spotify_clone/core/configs/assets/app_vectors.dart';
import 'package:spotify_clone/data/models/auth/signin_user_req.dart';
import 'package:spotify_clone/domain/usecases/auth/signin.dart';
import 'package:spotify_clone/presentation/auth/pages/sign_up.dart';
import 'package:spotify_clone/presentation/genre_picks/pages/genre_picks.dart';
import 'package:spotify_clone/presentation/home/pages/home.dart';
import 'package:spotify_clone/presentation/home/pages/home_navigation.dart';
import 'package:spotify_clone/service_locator.dart';

import '../../../core/configs/constants/app_methods.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _signInText(context),
      appBar: BasicAppbar(
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 32.h,
          width: 32.h,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _signinText(),
            SizedBox(
              height: 24.h,
            ),
            _emailField(context),
            SizedBox(
              height: 16.h,
            ),
            _passwordField(context),
            SizedBox(
              height: 16.h,
            ),
            BasicAppButton(
              title: 'Sign in',
              onPressed: () async {
                var result = await sl<SignInUseCase>().call(
                  params: SignInUserRequest(
                    email: _emailController.text.toString(),
                    password: _passwordController.text.toString(),
                  ),
                );

                result.fold(
                  (l) {
                    customSnackBar(isSuccess: false, text: l, context: context);
                  },
                  (r) async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    bool hasCompletedOnboarding = prefs.getBool('onboarding_complete') ?? false;

                    if (!hasCompletedOnboarding) {
                      // Navigate to the genre picking screen
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GenrePicks(),
                          ),
                          (route) => false);
                    }

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeNavigation(),
                        ),
                        (route) => false);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _signinText() {
    return Text(
      'Sign in',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      style: TextStyle(fontSize: 16.sp, letterSpacing: 0.4),
      controller: _emailController,
      decoration: const InputDecoration(
        hintText: 'Enter email',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      style: TextStyle(fontSize: 16.sp, letterSpacing: 0.4),
      controller: _passwordController,
      obscureText: !isVisible,
      decoration: InputDecoration(
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: IconButton(
            splashRadius: 20.w,
            // padding: EdgeInsets.only(right: 15.w),
            icon: Icon(
              isVisible ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
            ),
            onPressed: () {
              setState(() {
                isVisible = !isVisible;
              });
            },
          ),
        ),
        hintText: 'Password',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }

  Widget _signInText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 25.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Not a member?',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const SignUpPage(),
                ));
              },
              child: const Text('Register now'))
        ],
      ),
    );
  }
}
