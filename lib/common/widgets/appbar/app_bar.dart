import 'package:flutter/material.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? action;
  final bool? hideBackButton;
  final VoidCallback ? onTap;
  const BasicAppbar({Key? key, this.title, this.hideBackButton = false, this.action, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title ?? const Text(''),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        action ?? Container()
      ],
      centerTitle: true,
      leading: hideBackButton!
          ? const SizedBox.shrink()
          : IconButton(
              onPressed: onTap ?? () {
                Navigator.pop(context);
              },
              icon: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: context.isDarkMode
                        ? Colors.white.withOpacity(0.03)
                        : Colors.black.withOpacity(0.04),
                    shape: BoxShape.circle),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
