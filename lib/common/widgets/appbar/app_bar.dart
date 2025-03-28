import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? action;
  final Widget? leading;
  final bool? hideBackButton;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  const BasicAppbar({
    super.key,
    this.leading,
    this.title,
    this.hideBackButton = false,
    this.action,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title ?? const Text(''),
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      actions: [action ?? Container()],
      centerTitle: true,
      leading: hideBackButton!
          ? leading ?? const SizedBox.shrink()
          : IconButton(
              onPressed: onTap ??
                  () {
                    Navigator.pop(context);
                  },
              icon: Container(
                height: 50.h,
                width: 50.w,
                decoration: BoxDecoration(
                    color: context.isDarkMode
                        ? Colors.white.withOpacity(0.03)
                        : Colors.black.withOpacity(0.04),
                    shape: BoxShape.circle),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 15.h,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
