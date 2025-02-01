import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/domain/entity/auth/user.dart';

class UserTileWidget extends StatelessWidget {
  final UserWithStatus userEntity;
  final bool isOnSearch;
  const UserTileWidget({
    super.key,
    required this.userEntity,
    this.isOnSearch = false,

  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(userEntity: userEntity,),
          ),
        );
      },
      splashColor: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 5.h).copyWith(right: 6.5.w),
      child: Row(
        children: [
          Container(
            height: 40.h,
            width: 44.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  userEntity.userEntity.avatarUrl!,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 14.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userEntity.userEntity.fullName!,
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  'User',
                  style: TextStyle(fontSize: 10.sp, color: Colors.white70),
                ),
              ],
            ),
          ),
          isOnSearch ? Row(
            children: [
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.sp,
              ),
              SizedBox(
                width: 10.w,
              )
            ],
          ) : const SizedBox.shrink()
        ],
      ),
    );
  }
}
