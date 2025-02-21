import 'package:spotify_clone/common/helpers/export.dart';

class FollowCount extends StatelessWidget {
  final String title;
  final int count;
  const FollowCount({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 18.3.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w300),
        )
      ],
    );
  }
}
