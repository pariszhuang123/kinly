import 'package:flutter/material.dart';

class KinlyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KinlyAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle,
    this.backgroundColor,
    this.foregroundColor,
    this.surfaceTintColor,
    this.iconTheme,
    this.automaticallyImplyLeading,
    this.elevation,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool? centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? surfaceTintColor;
  final IconThemeData? iconTheme;
  final bool? automaticallyImplyLeading;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      surfaceTintColor: surfaceTintColor,
      iconTheme: iconTheme,
      automaticallyImplyLeading: automaticallyImplyLeading ?? true,
      elevation: elevation,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
