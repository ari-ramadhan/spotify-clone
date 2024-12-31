import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Debug extends StatelessWidget {
  Debug({Key? key}) : super(key: key);


  List item = [1,2,3,4,5,6,7,8,12,31,3,11,2,3,1,1,4,1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 200.h,
                color: Colors.blue,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  // height: 200.h,
                  // color: Colors.amber,
                  child: ListView(
                    children: item.map((e) {
                      return ListTile(
                        contentPadding: EdgeInsets.all(10),
                        title: Text(e.toString(), style: TextStyle(fontSize: 20.sp, color: Colors.blue),),
                        tileColor: Colors.white,
                      );
                    },).toList(),
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(
                top: 182.h, left: ScreenUtil().screenWidth * 0.80),
            padding: EdgeInsets.all(10.h),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.purple),
            child: Icon(
              Icons.play_arrow_rounded,
              size: 30.sp,
            ),
          )
        ],
      ),
    );
  }
}
