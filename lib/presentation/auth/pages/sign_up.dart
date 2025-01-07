import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone/common/widgets/button/basic_app_button.dart';
import 'package:spotify_clone/core/configs/assets/app_vectors.dart';
import 'package:spotify_clone/data/models/auth/create_user_request.dart';
import 'package:spotify_clone/domain/usecases/auth/signup.dart';
import 'package:spotify_clone/presentation/home/pages/home.dart';
import 'package:spotify_clone/presentation/home/pages/home_navigation.dart';
import 'package:spotify_clone/service_locator.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullName = TextEditingController();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();

  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        // padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _registerText(),
            SizedBox(
              height: 24.h,
            ),
            _fullNameField(context),
            SizedBox(
              height: 16.h,
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
              title: 'Create Account',
              onPressed: () async {
                var result = await sl<SignUpUseCase>().call(
                  params: CreateUserRequest(
                    fullName: _fullName.text.toString(),
                    email: _email.text.toString(),
                    password: _password.text.toString(),
                  ),
                );

                result.fold(
                  (l) {
                    var snackbar = SnackBar(
                        content: Text(
                          l,
                          style: const TextStyle(color: Colors.black),
                        ),
                        behavior: SnackBarBehavior.floating);
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  },
                  (r) {
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

  Widget _registerText() {
    return Text(
      'Register',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp),
    );
  }

  Widget _fullNameField(BuildContext context) {
    return TextField(
      style: TextStyle(
        fontSize: 16.sp,
        letterSpacing: 0.4
      ),
      controller: _fullName,
      decoration: const InputDecoration(
        hintText: 'Full name',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      style: TextStyle(
        fontSize: 16.sp,
        letterSpacing: 0.4
      ),
      controller: _email,
      decoration: const InputDecoration(
        hintText: 'Enter email',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      style: TextStyle(
        fontSize: 16.sp,
        letterSpacing: 0.4
      ),
      controller: _password,
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
      padding: EdgeInsets.symmetric(vertical: 25.h,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Do you have an account?',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
          ),
          TextButton(onPressed: () {}, child: const Text('Sign in'))
        ],
      ),
    );
  }
}
