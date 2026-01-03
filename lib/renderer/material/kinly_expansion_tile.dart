import 'package:flutter/material.dart';

class KinlyExpansionTile extends StatelessWidget {
  const KinlyExpansionTile({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.children = const <Widget>[],
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.subtitle,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.childrenPadding,
  });

  final Widget title;
  final Widget? leading;
  final Widget? trailing;
  final List<Widget> children;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onExpansionChanged;
  final Widget? subtitle;
  final Color? backgroundColor;
  final Color? collapsedBackgroundColor;
  final EdgeInsetsGeometry? childrenPadding;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: title,
      leading: leading,
      trailing: trailing,
      initiallyExpanded: initiallyExpanded,
      onExpansionChanged: onExpansionChanged,
      subtitle: subtitle,
      backgroundColor: backgroundColor,
      collapsedBackgroundColor: collapsedBackgroundColor,
      childrenPadding: childrenPadding,
      children: children,
    );
  }
}
